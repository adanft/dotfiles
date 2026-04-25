# Persistence Contract (shared across all SDD skills)

## Mode Resolution

The standard orchestrated SDD flow passes `artifact_store.mode` as either `engram` or `openspec`.

Resolution policy is fixed:
- If Engram is available → use `engram`
- If Engram is unavailable → use `openspec` and create/bootstrap it as needed

This choice is cached for the session. The orchestrator does not ask the user to choose between runtime persistence modes for standard SDD flow.

Legacy callers may still pass `hybrid` or `none`, but those are compatibility modes, not the standard contract.

## Mode Roles

- **`engram`**: Preferred SDD backend when available. Persisted cross-session working memory / fast path with no project files created.
- **`openspec`**: Standard fallback for SDD when Engram is unavailable. Durable reconciled filesystem baseline: file-based, shareable, audit-friendly.
- **`hybrid`**: Legacy compatibility mode only. Not selected by the standard orchestrator policy.
- **`none`**: Legacy compatibility mode only. Not selected by the standard orchestrator policy.

### Mode Comparison

| Capability | `engram` | `openspec` | `hybrid` | `none` |
|------------|----------|------------|----------|--------|
| Cross-session recovery | ✅ | ✅ (via persisted files) | ✅ | ❌ |
| Compaction survival | ✅ | ✅ (filesystem survives compaction) | ✅ | ❌ |
| Shareable with team | ❌ (local DB) | ✅ (committed files) | ✅ (files) | ❌ |
| Full iteration history | ❌ (upsert overwrites) | ✅ (git history) | ✅ (files + git) | ❌ |
| Audit trail (archive) | Partial (report only) | ✅ (full folder) | ✅ (both) | ❌ |
| Project files created | Never | Yes | Yes | Never |

### `engram` mode limitation

Engram uses `topic_key`-based upserts. Re-running a phase for the same change **overwrites** the previous version — no revision history is kept. SQLite-backed persistence here means the latest artifact is durable, not that every iteration is preserved. The archive phase saves a summary report, not the full artifact folder. For iteration history, reconciled local spec files, or team collaboration, use `openspec` or `hybrid`.

## Behavior Per Mode

| Mode | Read from | Write to | Project files |
|------|-----------|----------|---------------|
| `engram` | Engram | Engram | Never |
| `openspec` | Filesystem | Filesystem | Yes |
| `hybrid` | Engram (primary) + Filesystem (fallback) | Both | Yes |
| `none` | Orchestrator prompt context | Nowhere | Never |

### Hybrid Mode

Persists every artifact to BOTH Engram and OpenSpec simultaneously:
- Engram: cross-session recovery, compaction survival, deterministic search
- OpenSpec: human-readable files, version-controllable artifacts

Write to Engram (per `engram-convention.md`) AND to filesystem (per `openspec-convention.md`) for every artifact.

Read priority: Engram first; fall back to filesystem if Engram returns no results.
Write behavior: both writes MUST succeed for the operation to be complete.
Token cost warning: hybrid consumes MORE tokens per operation. Use only when you need both cross-session persistence AND local file artifacts.

## State Persistence (Orchestrator)

The orchestrator persists DAG state after each phase transition to enable SDD recovery after compaction.

| Mode | Persist State | Recover State |
|------|--------------|---------------|
| `engram` | `mem_save(topic_key: "sdd/{change-name}/state")` | `mem_search("sdd/*/state")` → `mem_get_observation(id)` |
| `openspec` | Write `openspec/changes/{change-name}/state.yaml` | Read `openspec/changes/{change-name}/state.yaml` |
| `hybrid` | Both: `mem_save` AND write `state.yaml` | Engram first; filesystem fallback |
| `none` | Not possible — warn user | Not possible |

## Common Rules

- `engram` → do NOT write any project files; persist to Engram and return observation IDs
- `openspec` → write files ONLY to paths defined in `openspec-convention.md`
- `hybrid` → persist to BOTH Engram AND filesystem; follow both conventions only when a legacy caller explicitly requested it
- `none` → do NOT create or modify any project files; return results inline only when a legacy caller explicitly requested it
- Create `openspec/` when the resolved SDD fallback mode is `openspec`
- In `openspec`, `sdd-apply` writes cumulative progress to `openspec/changes/{change-name}/apply-progress.md`; `sdd-verify` reads it when present.
- The `skill_registry_cache` route is optional local cache only. It is never a required SDD artifact and never determines persistence mode.

## Sub-Agent Context Rules

Sub-agents launch with a fresh context and NO access to the orchestrator's instructions or memory protocol.

Who reads, who writes:
- Non-SDD (general task): orchestrator searches engram, passes summary in prompt; sub-agent saves discoveries via `mem_save`
- SDD (phase with dependencies): sub-agent reads artifacts directly from backend; sub-agent saves its artifact
- SDD (phase without dependencies, e.g. explore): nobody reads; sub-agent saves its artifact

Why this split:
- Orchestrator reads for non-SDD: it knows what context is relevant; sub-agents doing their own searches waste tokens on irrelevant results
- Sub-agents read for SDD: SDD artifacts are large; inlining them in the orchestrator prompt would consume the entire context window
- Sub-agents always write: they have the complete detail on what happened; nuance is lost by the time results flow back to the orchestrator

## Orchestrator Prompt Instructions for Sub-Agents

Non-SDD:
```
PERSISTENCE (MANDATORY):
If you make important discoveries, decisions, or fix bugs, you MUST save them to engram before returning:
  mem_save(title: "{short description}", type: "{decision|bugfix|discovery|pattern}",
           scope: "project", content: "{What, Why, Where, Learned}")
Do NOT return without saving what you learned. This is how the team builds persistent knowledge across sessions.
```

SDD (with dependencies):
```
Artifact store mode: {engram|openspec|hybrid|none}
Read these artifacts before starting (search returns truncated previews):
  mem_search(query: "sdd/{change-name}/{type}", project: "{project}") → get ID
  mem_get_observation(id: {id}) → full content (REQUIRED)

PERSISTENCE (MANDATORY — do NOT skip):
After completing your work, you MUST call:
  mem_save(
    title: "sdd/{change-name}/{artifact-type}",
    topic_key: "sdd/{change-name}/{artifact-type}",
    type: "architecture",
    scope: "project",
    content: "{your full artifact markdown}"
  )
If you return without calling mem_save, the next phase CANNOT find your artifact and the pipeline BREAKS.
```

SDD (no dependencies):
```
Artifact store mode: {engram|openspec|hybrid|none}

PERSISTENCE (MANDATORY — do NOT skip):
After completing your work, you MUST call:
  mem_save(
    title: "sdd/{change-name}/{artifact-type}",
    topic_key: "sdd/{change-name}/{artifact-type}",
    type: "architecture",
    scope: "project",
    content: "{your full artifact markdown}"
  )
If you return without calling mem_save, the next phase CANNOT find your artifact and the pipeline BREAKS.
```

## Skill Registry

The orchestrator pre-resolves compact rules from the skill registry and injects them as `## Project Standards (auto-resolved)` in your launch prompt when a registry is available. Sub-agents do NOT read the registry or individual SKILL.md files — rules arrive pre-digested.

Preferred source is Engram. The `skill_registry_cache` route is an optional local cache/fallback only.

To generate/update: run the `skill-registry` skill, or run `sdd-init` if local registry generation is desired.

Sub-agent skill loading: check for a `## Project Standards (auto-resolved)` block in your prompt — if present, follow those rules. If not present, check for `SKILL: Load` instructions as a fallback. If neither exists, proceed without — this is not an error.

## Detail Level

The orchestrator may pass `detail_level`: `concise | standard | deep`. This controls output verbosity but does NOT affect what gets persisted — always persist the full artifact.

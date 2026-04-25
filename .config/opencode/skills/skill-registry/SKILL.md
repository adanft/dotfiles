---
name: skill-registry
description: >
  Create or update the skill registry for the current project. Scans allowed skill directories and project conventions, prefers Engram persistence, and may refresh the optional `skill_registry_cache` route.
  Trigger: When user says "update skills", "skill registry", "actualizar skills", "update registry", or after installing/removing skills.
license: MIT
metadata:
  author: gentleman-programming
  version: "1.0"
---

## Purpose

You generate or update the **skill registry** — a catalog of all available skills with **compact rules** (pre-digested, 5-15 line summaries) that any delegator injects directly into sub-agent prompts. Sub-agents do NOT read the registry or individual SKILL.md files — they receive compact rules pre-resolved in their launch prompt.

This is the foundation of the **Skill Resolver Protocol** (see `_shared/skill-resolver.md`). The registry is built ONCE (expensive), then read cheaply at every delegation.

## When to Run

- After installing or removing skills
- After setting up a new project
- When the user explicitly asks to update the registry
- As part of `sdd-init` (it calls this same logic)

## What to Do

### Step 1: Scan Skill Directories

1. Read `RUNTIME_PATHS.md` from the runtime config workspace and resolve these Skill Roots:
   - `general_skills_root`
   - `runtime_skills_root`
   - `current_skill_collection_root`
   - `project_skills_root`
   - `project_runtime_skills_root`

   Then scan the resolved roots and collect matching `*/SKILL.md` files. Follow the file's resolution rules: skip missing optional paths and scan duplicate absolute paths only once.

2. **Skip internal entries**: `sdd-*`, `_shared`, and `skill-registry`.
3. **Deduplicate** by skill name using the specificity order in `RUNTIME_PATHS.md`; otherwise keep the first match.
4. For each skill found, read the **full SKILL.md** (if a SKILL.md exceeds 200 lines, focus on the frontmatter and Critical Patterns / Rules sections only) to extract:
   - `name` field (from frontmatter)
   - `description` field → extract the trigger text (after "Trigger:" in the description)
   - **Compact rules** — the actionable patterns and constraints (see Step 1b)
5. Build a table of: Trigger | Skill Name | Full Path

### Step 1b: Generate Compact Rules

For each skill found in Step 1, generate a **compact rules block** (5-15 lines max) containing:
- Actionable rules and constraints ("do X", "never Y", "prefer Z over W")
- Key patterns with one-line examples where critical
- Breaking changes or gotchas that would cause bugs if missed

Exclude purpose/motivation, when-to-use text, full code examples, installation steps, or anything the sub-agent does not need to apply the skill.

Format per skill:
```markdown
### {skill-name}
- Rule 1
- Rule 2
- ...
```

**Example** — compact rules for a React 19 skill:
```markdown
### react-19
- No useMemo/useCallback — React Compiler handles memoization automatically
- use() hook for promises/context, replaces useEffect for data fetching
- Server Components by default, add 'use client' only for interactivity/hooks
- ref is a regular prop — no forwardRef needed
- Actions: use useActionState for form mutations, useOptimistic for optimistic UI
- Metadata: export metadata object from page/layout, no <Head> component
```

**The compact rules are the MOST IMPORTANT output of this skill.** They are what sub-agents actually receive. Invest time making them accurate and concise.

### Step 2: Scan Project Conventions

1. Read `RUNTIME_PATHS.md` and resolve these routes from **Agent Instructions** and **Runtime Config**:
   - `agent_instructions_primary`
   - `agent_instructions_secondary`
   - `runtime_config_file`
2. **If an index file is found** (e.g., `agents.md`, `AGENTS.md`): read its contents and extract all referenced file paths. These index files typically list project conventions with paths — extract every referenced path and include it in the registry table alongside the index file itself.
3. For standalone convention files, record the file directly.
4. For `runtime_config_file`, inspect only known safe workflow markers needed by this registry. Do not include the whole runtime config as a Project Convention, and do not read or extract `mcp`, provider, auth, token, secret, or credential sections unless the user explicitly asks for runtime/MCP/security analysis.
5. The final table should include the index file AND all paths it references — zero extra hops for sub-agents.

### Step 3: Build the Registry

Build the registry markdown:

```markdown
# Skill Registry

**Delegator use only.** Any agent that launches sub-agents reads this registry to resolve compact rules, then injects them directly into sub-agent prompts. Sub-agents do not read this registry or individual SKILL.md files.

See `_shared/skill-resolver.md` for the full resolution protocol.

## Skills

| Trigger | Skill | Path |
|---------|-------|------|
| {trigger from frontmatter} | {skill name} | {full path to SKILL.md} |
| ... | ... | ... |

## Compact Rules

Pre-digested rules per skill. Delegators copy matching blocks into sub-agent prompts as `## Project Standards (auto-resolved)`.

### {skill-name-1}
- Rule 1
- Rule 2
- ...

### {skill-name-2}
- Rule 1
- Rule 2
- ...

{repeat for each skill}

## Project Conventions

| File | Path | Notes |
|------|------|-------|
| {index file} | {path} | Index — references files below |
| {referenced file} | {extracted path} | Referenced by {index file} |
| {standalone file} | {path} | |

Read the convention files listed above for project-specific patterns and rules. All referenced paths have been extracted — no need to read index files to discover more.
```

### Step 4: Persist the Registry

**This step is MANDATORY — do NOT skip it.**

#### A. Prefer Engram (default when available):

```
mem_save(
  title: "skill-registry",
  topic_key: "skill-registry",
  type: "config",
  scope: "project",
  content: "{registry markdown from Step 3}"
)
```

`topic_key` ensures upserts — running again updates the same observation.

#### B. Optional local cache:

Write the `skill_registry_cache` route only when one of these is true:
- The user explicitly asked for a local registry file
- A local registry cache already exists and you are refreshing it
- Engram is unavailable and you want a local fallback cache

If none of those apply, skip the file write.

The local registry cache is OPTIONAL. It must never be required for SDD correctness and must never define persistence mode semantics.

### Step 5: Return Summary

```markdown
## Skill Registry Updated

**Project**: {project name}
**Engram**: {saved / not available}
**Local Cache**: {skill_registry_cache updated / skipped / not available}

### Skills Found
| Skill | Trigger |
|-------|---------|
| {name} | {trigger} |
| ... | ... |

### Project Conventions Found
| File | Path |
|------|------|
| {file} | {path} |

### Next Steps
The orchestrator reads this registry once per session and passes pre-resolved compact rules to sub-agents via their launch prompts.
To update after installing/removing skills, run this again.
```

## Rules

- Prefer saving to Engram whenever the `mem_save` tool is available
- Resolve skill/config paths from `RUNTIME_PATHS.md` before scanning; do not invent fallback paths beyond the listed route contract
- Write the `skill_registry_cache` route only as an optional local cache
- SKIP `sdd-*`, `_shared`, and `skill-registry` directories when scanning
- Read SKILL.md files (respecting the 200-line guard in Step 1) to generate accurate compact rules — this is a build-time cost, not a runtime cost
- Compact rules MUST be 5-15 lines per skill — concise, actionable, no fluff
- Include ALL convention index files found (not just the first)
- If no skills or conventions are found, write an empty registry (so sub-agents don't waste time searching)
- Add the resolved local cache directory to the project's `.gitignore` only if you actually wrote the local cache and it is not already listed
- NEVER make `skill_registry_cache` mandatory for SDD correctness or persistence selection

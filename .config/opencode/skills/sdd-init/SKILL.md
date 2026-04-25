---
name: sdd-init
description: >
  Initialize Spec-Driven Development context in any project. Detects stack, conventions, testing capabilities, and bootstraps the active persistence backend.
  Trigger: When user wants to initialize SDD in a project, or says "sdd init", "iniciar sdd", "openspec init".
license: MIT
metadata:
  author: gentleman-programming
  version: "3.0"
---

## Purpose

You are a sub-agent responsible for initializing the Spec-Driven Development (SDD) context in a project. You detect the project stack, conventions, and testing capabilities, then bootstrap the active persistence backend.

You are an EXECUTOR for this phase, not the orchestrator. Do the initialization work yourself. Do NOT launch sub-agents, do NOT call `delegate` or `task`, and do NOT hand execution back unless you hit a real blocker that must be reported upstream.

## Execution and Persistence Contract

- Standard orchestrated SDD policy:
  - If mode is `engram`: do NOT create `openspec/` directory.
  - If mode is `openspec`: read and follow `skills/_shared/openspec-convention.md`. Run full bootstrap.
  - `openspec` is the fallback when Engram is unavailable.

- Legacy compatibility modes:
  - If mode is `hybrid`: read and follow BOTH convention files. Run openspec bootstrap AND persist context to Engram.
  - If mode is `none`: return detected context without writing project files.

- If mode is `engram`:

  **Save project context**:
  ```
  mem_save(
    title: "sdd-init/{project-name}",
    topic_key: "sdd-init/{project-name}",
    type: "architecture",
    scope: "project",
    content: "{detected project context markdown}"
  )
  ```
  `topic_key` enables upserts — re-running init updates the existing context, not duplicates.

  (See `skills/_shared/engram-convention.md` for full naming conventions.)

## What to Do

### Step 1: Detect Project Context

Read the project to understand:
- Tech stack (check package.json, go.mod, pyproject.toml, etc.)
- Existing conventions (linters, test frameworks, CI)
- Architecture patterns in use

### Step 2: Detect Testing Capabilities

Scan the project for ALL testing infrastructure. This determines what testing modes are available.

```
Detect testing capabilities:
├── Test Runner
│   ├── package.json → devDependencies: vitest, jest, mocha, ava
│   ├── package.json → scripts.test (what command it runs)
│   ├── pyproject.toml / pytest.ini / setup.cfg → pytest
│   ├── go.mod → go test (built-in)
│   ├── Cargo.toml → cargo test (built-in)
│   ├── Makefile → make test
│   └── Result: {framework name, command} or NOT FOUND
│
├── Test Layers
│   ├── Unit: test runner exists → AVAILABLE
│   ├── Integration:
│   │   ├── JS/TS: @testing-library/* in dependencies
│   │   ├── Python: pytest + httpx/requests-mock/factory-boy
│   │   ├── Go: net/http/httptest (built-in)
│   │   ├── .NET: xUnit/NUnit + WebApplicationFactory
│   │   └── Result: AVAILABLE or NOT INSTALLED
│   ├── E2E:
│   │   ├── playwright, cypress, selenium in dependencies
│   │   ├── Python: playwright, selenium
│   │   ├── Go: chromedp
│   │   └── Result: AVAILABLE or NOT INSTALLED
│   └── Each layer → record tool name
│
├── Coverage Tool
│   ├── JS/TS: vitest --coverage, jest --coverage, c8, istanbul/nyc
│   ├── Python: coverage.py, pytest-cov
│   ├── Go: go test -cover (built-in)
│   ├── .NET: coverlet
│   └── Result: {command} or NOT AVAILABLE
│
└── Quality Tools
    ├── Linter: eslint, pylint, ruff, golangci-lint, clippy
    ├── Type checker: tsc --noEmit, mypy, pyright, go vet
    ├── Formatter: prettier, black, gofmt, rustfmt
    └── Each: {command} or NOT AVAILABLE
```

### Step 3: Resolve STRICT TDD MODE

Determine whether Strict TDD Mode should be enabled. The resolution follows a priority chain — first match wins:

`sdd-init` is the primary resolver/persister of Strict TDD state for the standard SDD flow. Downstream phases (`sdd-apply`, `sdd-verify`) consume the persisted result via the orchestrator; they do not silently re-resolve mode as the normal path.

```
1. Read from system prompt / agent config (highest priority):
   ├── Search for "strict-tdd-mode" marker in the configured agent prompt/runtime config
   │   (e.g., `AGENTS.md`, `agents.md`, or the `runtime_config_file` route from `RUNTIME_PATHS.md`)
   ├── If found and says "enabled" → strict_tdd: true
   ├── If found and says "disabled" → strict_tdd: false
   └── This is the preference set by the user in the gentle-ai TUI

2. If no marker found, check openspec config:
   ├── Read openspec/config.yaml → strict_tdd field
   └── If found → use that value

3. If nothing found AND test runner was detected in Step 2:
   ├── Default: strict_tdd: true (enable if the project CAN do TDD)
   └── This ensures TDD is active even without gentle-ai TUI setup

4. If no test runner detected:
   ├── strict_tdd: false (cannot enable without test runner)
   └── Include NOTE in summary: "Strict TDD Mode unavailable — no test runner detected"
```

**Do NOT ask the user interactively.** The preference is resolved from existing config. If the user wants to change it, they run `gentle-ai sync` with the TUI or set `strict_tdd` in `openspec/config.yaml`.

### Step 4: Initialize Persistence Backend

If mode resolves to `openspec`, create this directory structure:

```
openspec/
├── config.yaml              ← Project-specific SDD config
├── specs/                   ← Source of truth (empty initially)
└── changes/                 ← Active changes
    └── archive/             ← Completed changes
```

### Step 5: Generate Config (openspec mode)

Based on what you detected, create the config when in `openspec` mode:

```yaml
# openspec/config.yaml
schema: spec-driven

context: |
  Tech stack: {detected stack}
  Architecture: {detected patterns}
  Testing: {detected test framework}
  Style: {detected linting/formatting}

strict_tdd: {true/false}

testing:
  test_runner:
    command: "{detected test command or ''}"
    framework: "{detected framework or ''}"
  layers:
    unit: {true/false}
    integration: {true/false}
    e2e: {true/false}
  quality_tools:
    coverage_command: "{detected coverage command or ''}"
    linter_command: "{detected linter command or ''}"
    typecheck_command: "{detected type checker command or ''}"
    formatter_command: "{detected formatter command or ''}"

rules:
  proposal:
    - Include rollback plan for risky changes
    - Identify affected modules/packages
  specs:
    - Use Given/When/Then format for scenarios
    - Use RFC 2119 keywords (MUST, SHALL, SHOULD, MAY)
  design:
    - Include sequence diagrams for complex flows
    - Document architecture decisions with rationale
  tasks:
    - Group tasks by phase (infrastructure, implementation, testing)
    - Use hierarchical numbering (1.1, 1.2, etc.)
    - Keep tasks small enough to complete in one session
  apply:
    - Follow existing code patterns and conventions
    - Load relevant coding skills for the project stack
  verify:
    - Run tests if test infrastructure exists
    - Compare implementation against every spec scenario
  archive:
    - Warn before merging destructive deltas (large removals)
```

### Step 6: Persist Testing Capabilities

**This step is MANDATORY — do NOT skip it.**

Persist detected testing capabilities as a separate Engram observation (or section in config.yaml for openspec). This is the canonical persisted source the orchestrator reads and forwards into `sdd-apply` / `sdd-verify`.

If mode is `engram` or `hybrid`:
```
mem_save(
  title: "sdd/{project-name}/testing-capabilities",
  topic_key: "sdd/{project-name}/testing-capabilities",
  type: "config",
  scope: "project",
  content: "{testing capabilities markdown — see format below}"
)
```

**Testing Capabilities format**:

```markdown
## Testing Capabilities

**Strict TDD Mode**: {enabled/disabled}
**Detected**: {date}

### Test Runner
- Command: `{command}`
- Framework: {name}

### Test Layers
| Layer | Available | Tool |
|-------|-----------|------|
| Unit | ✅ / ❌ | {tool or —} |
| Integration | ✅ / ❌ | {tool or —} |
| E2E | ✅ / ❌ | {tool or —} |

### Coverage
- Available: ✅ / ❌
- Command: `{command or —}`

### Quality Tools
| Tool | Available | Command |
|------|-----------|---------|
| Linter | ✅ / ❌ | {command or —} |
| Type checker | ✅ / ❌ | {command or —} |
| Formatter | ✅ / ❌ | {command or —} |
```

If mode is `openspec` or `hybrid`, also write this as a section in `openspec/config.yaml` under `testing:`.

### Step 7: Build Skill Registry

Follow the same logic as the `skill-registry` skill (`skills/skill-registry/SKILL.md`):

Resolve configured paths from `RUNTIME_PATHS.md` in the runtime config workspace before scanning:
- Skill roots: `general_skills_root`, `runtime_skills_root`, `current_skill_collection_root`, `project_skills_root`, and `project_runtime_skills_root`.
- Agent instruction/config routes: `agent_instructions_primary`, `agent_instructions_secondary`, and `runtime_config_file`.

1. Scan resolved skill roots and collect `*/SKILL.md`. Skip missing optional paths and scan duplicate absolute paths only once. Skip `sdd-*`, `_shared`, and `skill-registry`. Deduplicate by name using the specificity order in `RUNTIME_PATHS.md`; otherwise keep the first match. Read frontmatter triggers.
2. Scan resolved convention/config routes. If an index file is found (e.g., `agents.md`), READ it and extract all referenced file paths — include both the index and its referenced files in the registry.
3. For `runtime_config_file`, inspect only known safe workflow markers needed by SDD init. Do not include the whole runtime config as a Project Convention, and do not read or extract `mcp`, provider, auth, token, secret, or credential sections unless the user explicitly asks for runtime/MCP/security analysis.
4. Prefer Engram for registry persistence when available: `mem_save(title: "skill-registry", topic_key: "skill-registry", type: "config", scope: "project", content: "{registry markdown}")`
5. Write the `skill_registry_cache` route ONLY as an optional local cache when requested, when refreshing an existing cache, or when Engram is unavailable and a local fallback is desired.

The registry is optional. SDD init must still succeed if no local registry cache is written.

See `skills/skill-registry/SKILL.md` for the full registry format and scanning details.

### Step 8: Persist Project Context

**This step is MANDATORY — do NOT skip it.**

If mode is `engram`:
```
mem_save(
  title: "sdd-init/{project-name}",
  topic_key: "sdd-init/{project-name}",
  type: "architecture",
  scope: "project",
  content: "{your detected project context from Steps 1-7}"
)
```

If mode is `openspec` or `hybrid`: the config was already written in Step 5.

If mode is `hybrid`: also call `mem_save` as above (write to BOTH backends).

### Step 9: Return Summary

Return a structured summary adapted to the resolved mode:

#### If mode is `engram`:

Persist project context following `skills/_shared/engram-convention.md` with title and topic_key `sdd-init/{project-name}`.

Return:
```
## SDD Initialized

**Project**: {project name}
**Stack**: {detected stack}
**Persistence**: engram
**Strict TDD Mode**: {enabled ✅ / disabled ❌ / unavailable (no test runner)}

### Testing Capabilities
| Capability | Status |
|------------|--------|
| Test Runner | {tool} ✅ / ❌ Not found |
| Unit Tests | ✅ / ❌ |
| Integration Tests | {tool} ✅ / ❌ Not installed |
| E2E Tests | {tool} ✅ / ❌ Not installed |
| Coverage | ✅ / ❌ |
| Linter | {tool} ✅ / ❌ |
| Type Checker | {tool} ✅ / ❌ |

### Context Saved
Project context persisted to Engram.
- **Engram ID**: #{observation-id}
- **Topic key**: sdd-init/{project-name}
- **Capabilities ID**: #{capabilities-observation-id}
- **Capabilities key**: sdd/{project-name}/testing-capabilities

No project files created.

### ⚠️ Engram Mode Limitations
Engram mode is ideal for **solo developers** doing fast iteration. Be aware:
- **No iteration history**: re-running a phase (e.g., `sdd-spec`) overwrites the previous version. Only the latest artifact is retained.
- **Not shareable**: engram is a local database — team members cannot see your SDD artifacts.
- **Partial audit trail**: the archive phase saves a summary report, but not the full artifact folder.

For **team projects** or work that needs a full audit trail, use `openspec` (file-based, git-friendly).

### Next Steps
Ready for /sdd-explore <topic> or /sdd-new <change-name>.
```

#### If mode is `openspec`:
```
## SDD Initialized

**Project**: {project name}
**Stack**: {detected stack}
**Persistence**: openspec
**Strict TDD Mode**: {enabled ✅ / disabled ❌ / unavailable (no test runner)}

### Testing Capabilities
{same table as above}

### Structure Created
- openspec/config.yaml ← Project config with detected context + testing capabilities
- openspec/specs/      ← Ready for specifications
- openspec/changes/    ← Ready for change proposals

### Next Steps
Ready for /sdd-explore <topic> or /sdd-new <change-name>.
```

#### If mode is `none`:
```
## SDD Initialized

**Project**: {project name}
**Stack**: {detected stack}
**Persistence**: none (ephemeral)
**Strict TDD Mode**: {enabled ✅ / disabled ❌ / unavailable (no test runner)}

### Testing Capabilities
{same table as above}

### Context Detected
{summary of detected stack and conventions}

### Recommendation
Enable `engram` or `openspec` for artifact persistence across sessions. Without persistence, all SDD artifacts will be lost when the conversation ends.

### Next Steps
Ready for /sdd-explore <topic> or /sdd-new <change-name>.
```

## Rules

- NEVER create placeholder spec files - specs are created via sdd-spec during a change
- ALWAYS detect the real tech stack, don't guess
- NEVER behave like the orchestrator from this phase - execute directly and return results
- Resolve skill/config paths from `RUNTIME_PATHS.md` before building the skill registry
- If the project already has an `openspec/` directory, report what exists and ask the orchestrator if it should be updated
- Keep config.yaml context CONCISE - no more than 10 lines
- ALWAYS detect testing capabilities — this is not optional
- ALWAYS persist testing capabilities as a separate observation/section — downstream phases depend on it
- If Strict TDD Mode is requested but no test runner exists, set strict_tdd: false and explain why
- Return envelope per **Section D** from `skills/_shared/sdd-phase-common.md`.

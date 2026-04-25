---
description: Implement SDD tasks — writes code following specs and design
agent: sdd-orchestrator
subtask: true
---

You are `sdd-orchestrator` handling the direct `/sdd-apply` command.

Route this command through the orchestrator first, then launch the `sdd-apply` executor skill. Do NOT perform apply work inline from this wrapper.

If Strict TDD Mode is active for this project/change, the skill defines the required RED-GREEN-REFACTOR workflow. Follow the skill's TDD rules exactly.

CONTEXT:
- Working directory: !`echo -n "$(pwd)"`
- Current project: !`echo -n "$(basename $(pwd))"`

TASK:
Implement the remaining incomplete tasks for the target SDD change.

CHANGE TARGETING:
- If `$ARGUMENTS` is non-empty, treat it as the change name to apply.
- Otherwise, resolve the active change from persisted SDD state using the orchestrator's normal fallback rules.
- If no target change can be resolved, return `blocked` with the missing-target reason instead of guessing.

IMPORTANT:
- Direct SDD commands ALWAYS go through `sdd-orchestrator` first.
- Resolve the standard SDD persistence policy before launching the skill: use `engram` when available, otherwise `openspec`.
- The skill is the source of truth for artifact retrieval, apply-progress continuity, task updates, Strict TDD handling, and persistence.
- Do NOT re-implement retrieval or merge logic from this wrapper.

Pass this execution intent to the `sdd-apply` executor:
1. Read the relevant spec scenarios (acceptance criteria)
2. Read the design decisions (technical approach)
3. Read existing code patterns in the project
4. Implement the tasks (if TDD is enabled, the executor follows the TDD workflow)
5. Mark completed tasks as `[x]`

Return the full structured envelope defined by `skills/_shared/sdd-phase-common.md`: `status`, `executive_summary`, `detailed_report`, `artifacts`, `next_recommended`, `risks`, and `skill_resolution`.

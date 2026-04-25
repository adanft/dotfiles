---
description: Validate implementation matches specs, design, and tasks
agent: sdd-orchestrator
subtask: true
---

You are `sdd-orchestrator` handling the direct `/sdd-verify` command.

Route this command through the orchestrator first, then launch the `sdd-verify` executor skill. Do NOT perform verify work inline from this wrapper.

CONTEXT:
- Working directory: !`echo -n "$(pwd)"`
- Current project: !`echo -n "$(basename $(pwd))"`

TASK:
Ask the `sdd-verify` executor to verify the target SDD change using the proposal, specs, design, tasks artifacts, and `apply-progress` if it exists.

CHANGE TARGETING:
- If `$ARGUMENTS` is non-empty, treat it as the change name to verify.
- Otherwise, resolve the active change from persisted SDD state using the orchestrator's normal fallback rules.
- If no target change can be resolved, return `blocked` with the missing-target reason instead of guessing.

IMPORTANT:
- Direct SDD commands ALWAYS go through `sdd-orchestrator` first.
- Resolve the standard SDD persistence policy before launching the skill: use `engram` when available, otherwise `openspec`.
- The skill is the source of truth for artifact retrieval, optional `apply-progress` handling, execution validation, compliance checks, and persistence.
- Do NOT duplicate retrieval or verify-report persistence rules in this wrapper.

Pass this verification intent to the `sdd-verify` executor:
1. Check completeness — are all tasks done?
2. Check correctness — does code match specs?
3. Check coherence — were design decisions followed?
4. Run tests and the minimum necessary compile validation (type-check first, build only when required)
5. Build the spec compliance matrix

Return the full structured envelope defined by `skills/_shared/sdd-phase-common.md`: `status`, `executive_summary`, `detailed_report`, `artifacts`, `next_recommended`, `risks`, and `skill_resolution`.

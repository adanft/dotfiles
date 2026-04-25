---
description: Archive a completed SDD change — syncs specs and closes the cycle
agent: sdd-orchestrator
subtask: true
---

You are `sdd-orchestrator` handling the direct `/sdd-archive` command.

Route this command through the orchestrator first, then launch the `sdd-archive` executor skill. Do NOT perform archive work inline from this wrapper.

CONTEXT:
- Working directory: !`echo -n "$(pwd)"`
- Current project: !`echo -n "$(basename $(pwd))"`

TASK:
Ask the `sdd-archive` executor to archive the target SDD change after reading the verification report and confirming the change is ready.

CHANGE TARGETING:
- If `$ARGUMENTS` is non-empty, treat it as the change name to archive.
- Otherwise, resolve the active change from persisted SDD state using the orchestrator's normal fallback rules.
- If no target change can be resolved, return `blocked` with the missing-target reason instead of guessing.

IMPORTANT:
- Direct SDD commands ALWAYS go through `sdd-orchestrator` first.
- Resolve the standard SDD persistence policy before launching the skill: use `engram` when available, otherwise `openspec`.
- The skill is the source of truth for readiness checks, artifact retrieval, archive persistence, and traceability requirements.
- Do NOT duplicate retrieval or persistence rules in this wrapper.

Pass this archive intent to the `sdd-archive` executor:
1. Sync delta specs into main specs (source of truth)
2. Move the change folder to archive with date prefix
3. Verify the archive is complete

Return the full structured envelope defined by `skills/_shared/sdd-phase-common.md`: `status`, `executive_summary`, `detailed_report`, `artifacts`, `next_recommended`, `risks`, and `skill_resolution`.

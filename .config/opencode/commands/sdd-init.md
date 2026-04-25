---
description: Initialize SDD context — detects project stack and bootstraps persistence backend
agent: sdd-orchestrator
subtask: true
---

You are `sdd-orchestrator` handling the direct `/sdd-init` command.

Route this command through the orchestrator first, then launch the `sdd-init` executor skill. Do NOT perform init work inline from this wrapper.

CONTEXT:
- Working directory: !`echo -n "$(pwd)"`
- Current project: !`echo -n "$(basename $(pwd))"`

TASK:
Initialize Spec-Driven Development in this project. Detect the tech stack, existing conventions, and architecture patterns. Bootstrap the active persistence backend according to the resolved artifact store mode.

IMPORTANT:
- Direct SDD commands ALWAYS go through `sdd-orchestrator` first.
- Resolve the standard SDD persistence policy before launching the skill: use `engram` when available, otherwise use/create `openspec`.
- The skill is the source of truth for project-context detection, optional registry generation, and artifact writing.
- Do NOT implement phase logic inline from this wrapper.

Return the full structured envelope defined by `skills/_shared/sdd-phase-common.md`: `status`, `executive_summary`, `detailed_report`, `artifacts`, `next_recommended`, `risks`, and `skill_resolution`.

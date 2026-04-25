---
description: Guided SDD walkthrough — onboard a user through the full SDD cycle using their real codebase
agent: sdd-orchestrator
subtask: true
---

You are `sdd-orchestrator` handling the direct `/sdd-onboard` command.

Route this command through the orchestrator first, then launch the `sdd-onboard` executor skill. Do NOT perform onboarding work inline from this wrapper.

CONTEXT:
- Working directory: !`echo -n "$(pwd)"`
- Current project: !`echo -n "$(basename $(pwd))"`

TASK:
Guide the user through a complete SDD cycle using their actual codebase. This is a real change with real artifacts, not a toy example. The goal is to teach by doing — walk through exploration, proposal, spec, design, tasks, apply, verify, and archive.

IMPORTANT:
- Direct SDD commands ALWAYS go through `sdd-orchestrator` first.
- Resolve the standard SDD persistence policy before launching the skill: use `engram` when available, otherwise use/create `openspec`.
- The skill is the source of truth for onboarding flow, persistence, and artifact-store behavior.
- Do NOT hardcode persistence behavior from this wrapper.

Return the full structured envelope defined by `skills/_shared/sdd-phase-common.md`: `status`, `executive_summary`, `detailed_report`, `artifacts`, `next_recommended`, `risks`, and `skill_resolution`.

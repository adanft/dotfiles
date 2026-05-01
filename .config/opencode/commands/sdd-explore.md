---
description: Explore and investigate an idea or feature — reads codebase and compares approaches
agent: sdd-orchestrator
subtask: true
---

You are `sdd-orchestrator` handling the direct `/sdd-explore` command.

Route this command through the orchestrator first, then launch the `sdd-explore` executor skill. Do NOT perform explore work inline from this wrapper.

CONTEXT:
- Working directory: !`echo -n "$(pwd)"`
- Current project: !`echo -n "$(basename $(pwd))"`
- Topic to explore: $ARGUMENTS

TASK:
Explore the topic "$ARGUMENTS" in this codebase. Investigate the current state, identify affected areas, compare approaches, and provide a recommendation.

IMPORTANT:
- Direct SDD commands ALWAYS go through `sdd-orchestrator` first.
- Resolve the standard SDD persistence policy before launching the skill: use `engram` when available, otherwise `openspec`.
- The skill is the source of truth for context retrieval, persistence, and artifact handling.
- This wrapper passes the topic only. Do NOT duplicate persistence logic here.

This is an exploration only — do NOT modify code or project implementation files. If tied to a named SDD change, the executor may persist the exploration artifact according to the active artifact store.

Return the full structured envelope defined by `skills/_shared/sdd-phase-common.md`: `status`, `executive_summary`, `detailed_report`, `artifacts`, `next_recommended`, `risks`, and `skill_resolution`.

---
description: Continue the next SDD phase in the dependency chain
agent: sdd-orchestrator
---

Follow the SDD orchestrator workflow to continue the target SDD change.

WORKFLOW:
1. Check which artifacts already exist for the target change (proposal, specs, design, tasks)
2. Determine the next phase needed based on the dependency graph:
   proposal → [specs ∥ design] → tasks → apply → verify → archive
3. Launch the appropriate sub-agent(s) for the next phase
4. Present the result and ask the user to proceed

CONTEXT:
- Working directory: !`echo -n "$(pwd)"`
- Current project: !`echo -n "$(basename $(pwd))"`
- Change name: $ARGUMENTS

IMPORTANT:
- If `$ARGUMENTS` is non-empty, treat it as the change name to continue.
- Otherwise, resolve the active change from persisted SDD state using the orchestrator's normal fallback rules.
- If no target change can be resolved, return `blocked` with the missing-target reason instead of guessing.
- The orchestrator prompt is the source of truth for dependency resolution, execution mode, artifact-store mode, and persistence strategy.
- Phase sub-agents handle their own artifact retrieval and persistence.

Read the orchestrator instructions to coordinate this workflow. Do NOT execute phase work inline — delegate to sub-agents.

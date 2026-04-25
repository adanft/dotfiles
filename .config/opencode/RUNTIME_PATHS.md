# Runtime Paths

Central route contract for this runtime config workspace. Agent-facing instructions should reference route names or sections from this file instead of duplicating filesystem details.

## Resolution Rules

- Resolve relative paths from the route contract root, which is the directory containing this file.
- For prompts loaded from a runtime config file reference, resolve `RUNTIME_PATHS.md` next to that config file, not from the caller project's current working directory.
- Expand `~` to the current user's home directory.
- Scan only listed paths that exist.
- If two entries resolve to the same absolute path, scan that path once.
- If an optional route is missing, skip it instead of searching broadly.
- A path with `#section` means “read that file and use that config section/key”, not a standalone file.
- Do not invent fallback paths outside this contract. Update this file first when a runtime stores skills/config somewhere else.
- Sensitive config sections (`mcp`, providers, auth, tokens, secrets, credentials) are never scanned by default. Read them only when the user explicitly requests runtime/MCP/security analysis.

## Specificity Rules

When the same skill exists in multiple roots, keep the first match by this priority:

1. `project_runtime_skills_root`
2. `project_skills_root`
3. `runtime_skills_root`
4. `current_skill_collection_root`
5. `general_skills_root`

## Consumer Map

| Consumer | Sections to resolve |
|----------|---------------------|
| `skill-registry` | Skill Roots, Agent Instructions, Runtime Config, Generated / Cache |
| `sdd-init` | Skill Roots, Agent Instructions, Runtime Config, Generated / Cache |
| SDD executor prompts | Skill Roots |
| Delegation/runtime plugins | Runtime Directories, Agent Definition Roots, MCP Config Sources |

## Runtime Directories

| Route | Path | Required | Purpose |
|-------|------|----------|---------|
| `route_contract_root` | `.` | yes | Base directory for this route contract. |
| `runtime_user_config_dir` | `~/.config/opencode/` | yes | User-level configuration directory for the active runtime. |
| `runtime_project_config_dir` | `.opencode/` | no | Optional project-local configuration directory for the active runtime. |
| `project_config_dir` | `.agents/` | no | Optional neutral project-local configuration directory. |

## Runtime Config

| Route | Path | Required | Purpose |
|-------|------|----------|---------|
| `runtime_config_file` | `opencode.json` | yes | Local runtime configuration. Inspect only safe workflow markers by default; sensitive sections require explicit user request. |
| `tui_config_file` | `tui.json` | no | Local TUI configuration. |

## Agent Instructions

| Route | Path | Required | Purpose |
|-------|------|----------|---------|
| `agent_instructions_primary` | `AGENTS.md` | yes | Primary workspace instructions. |
| `agent_instructions_secondary` | `agents.md` | no | Optional secondary instruction index. |

## Skill Roots

| Route | Path | Required | Purpose |
|-------|------|----------|---------|
| `general_skills_root` | `skills/` | yes | General shared skills bundled with this workspace. |
| `runtime_skills_root` | `~/.config/opencode/skills/` | yes | Skills installed for the active runtime. |
| `current_skill_collection_root` | `skills/` | yes | Parent directory containing sibling skill directories for this collection. |
| `project_skills_root` | `.agents/skills/` | no | Optional neutral project-local skills. |
| `project_runtime_skills_root` | `.opencode/skills/` | no | Optional runtime-specific project-local skills. |

## Agent Definition Roots

| Route | Path | Required | Purpose |
|-------|------|----------|---------|
| `runtime_agent_definitions_root` | `agents/` | yes | Agent/subagent definitions bundled with this workspace. |
| `project_agent_definitions_root` | `.agents/agents/` | no | Optional neutral project-local agent definitions. |
| `project_runtime_agent_definitions_root` | `.opencode/agents/` | no | Optional runtime-specific project-local agent definitions. |

## Rule Files

| Route | Path | Required | Purpose |
|-------|------|----------|---------|
| `project_rule_files` | `.agents/rules/` | no | Optional project-local rule files. |
| `project_runtime_rule_files` | `.opencode/rules/` | no | Optional runtime-specific project rule files. |

## Prompt / Workflow Roots

| Route | Path | Required | Purpose |
|-------|------|----------|---------|
| `prompt_roots` | `prompts/` | no | Prompt templates or workflow prompts bundled with this workspace. |
| `project_prompt_roots` | `.agents/prompts/` | no | Optional neutral project-local prompts or workflows. |
| `project_runtime_prompt_roots` | `.opencode/prompts/` | no | Optional runtime-specific project-local prompts or workflows. |

## MCP Config Sources

| Route | Path | Required | Purpose |
|-------|------|----------|---------|
| `mcp_config_primary` | `opencode.json#mcp` | no | Primary MCP/tool server config source in the runtime config. |
| `mcp_config_project` | `.mcp.json` | no | Optional project MCP/tool server config file. |
| `mcp_auth_state` | `~/.local/share/opencode/mcp-auth.json` | no | Sensitive auth state. Documented for completeness; do not scan by default. |

## Memory Sources

| Route | Path | Required | Purpose |
|-------|------|----------|---------|
| `project_memory_dir` | `.atl/` | no | Optional local generated memory/cache artifacts. |
| `runtime_delegation_store` | `~/.local/share/opencode/delegations/` | no | Persisted background delegation outputs. Do not scan broadly unless explicitly needed. |

## Generated / Cache Files

| Route | Path | Required | Purpose |
|-------|------|----------|---------|
| `skill_registry_cache` | `.atl/skill-registry.md` | no | Optional local cache for the generated skill registry. |

## Update Rule

When a runtime/client stores skills or config somewhere else, update this file first. Then keep the skill registry, SDD instructions, and plugins using route names instead of duplicating paths.

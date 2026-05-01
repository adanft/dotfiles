# Runtime Paths

Minimal route contract for the OpenCode paths consumed by this config. Do not use this file as a complete OpenCode path catalog.

## Resolution Rules

- Resolve relative paths from the route contract root, which is the directory containing this file.
- For prompts loaded from a runtime config file reference, resolve `RUNTIME_PATHS.md` next to that config file, not from the caller project's current working directory.
- Expand `~` to the current user's home directory.
- Expand `{project_root}` to the current project/workspace root.
- Scan only listed paths that exist.
- If two entries resolve to the same absolute path, scan that path once.
- If an optional route is missing, skip it instead of searching broadly.
- A path with `#section` means “read that file and use that config section/key”, not a standalone file.
- Do not invent fallback paths outside this contract. Update this file first when this config starts consuming a new route.
- Sensitive config sections (`mcp`, providers, auth, tokens, secrets, credentials) are never scanned by default. Read them only when the user explicitly requests runtime/MCP/security analysis.

## Specificity Rules

When the same skill exists in multiple roots, keep the first match by this priority:

1. `project_opencode_skills_root`
2. `project_agents_skills_root`
3. `runtime_skills_root`

## Consumer Map

| Consumer | Sections to resolve |
|----------|---------------------|
| `skill-registry` | Skill Roots, Agent Instructions, Runtime Config, Generated / Cache |
| `sdd-init` | Skill Roots, Agent Instructions, Runtime Config, Generated / Cache |
| SDD executor prompts | Skill Roots |

## Runtime Config

| Route | Path | Required | Purpose |
|-------|------|----------|---------|
| `runtime_config_file` | `~/.config/opencode/opencode.json` | yes | Global OpenCode runtime configuration. Inspect only safe workflow markers by default; sensitive sections require explicit user request. |
| `project_config_file` | `{project_root}/opencode.json` | no | Project OpenCode runtime configuration. |

## Agent Instructions

| Route | Path | Required | Purpose |
|-------|------|----------|---------|
| `project_agent_instructions` | `{project_root}/AGENTS.md` | no | Project-specific OpenCode instructions. |
| `runtime_agent_instructions` | `~/.config/opencode/AGENTS.md` | no | Global OpenCode instructions. |

## Skill Roots

| Route | Path | Required | Purpose |
|-------|------|----------|---------|
| `project_opencode_skills_root` | `{project_root}/.opencode/skills/` | no | Project OpenCode-native skills. |
| `project_agents_skills_root` | `{project_root}/.agents/skills/` | no | Project agent-compatible skills supported by OpenCode. |
| `runtime_skills_root` | `~/.config/opencode/skills/` | yes | Global OpenCode-native skills. |

## Generated / Cache Files

| Route | Path | Required | Purpose |
|-------|------|----------|---------|
| `skill_registry_cache` | `{project_root}/.atl/skill-registry.md` | no | Optional project-local cache for the generated skill registry. |

## Update Rule

When this config starts consuming a new OpenCode route, update this file first. Then keep the skill registry, SDD instructions, and prompts using route names instead of duplicating paths.

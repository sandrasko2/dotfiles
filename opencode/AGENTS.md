# OpenCode Global Instructions

## Built-in Agents

OpenCode provides these built-in agents - use them directly:
- **@explore** — Fast, read-only codebase exploration
- **@general** — Multi-step research and parallel execution
- **plan** (Tab key) — Read-only analysis without making changes
- **build** (Tab key) — Default development agent with all tools

## Preferences

- **Code style**: Follow existing conventions in each codebase
- **Testing**: Run lint/typecheck after making changes when available
- **Global configs**: Keep user preferences in ~/.config/opencode/, project configs in repo root
- **Skills over custom agents**: Prefer using skills (via /skill-name) over creating new agents

## Project AGENTS.md

Each project may have its own AGENTS.md or CLAUDE.md. These take precedence over this global file.

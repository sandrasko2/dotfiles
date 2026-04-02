# Dotfiles Workflow

Global Claude Code config (skills, agents, commands, rules) lives in `/vault/dotfiles/claude/` and is symlinked to `~/.claude/` via `install.sh`.

- When asked to add or modify global config: edit files in `/vault/dotfiles/claude/`, not `~/.claude/`
- When adding project-specific config: edit in the project's `.claude/` directory
- After global config changes: remind the user to run `/vault/dotfiles/install.sh` and commit to dotfiles repo
- Never put secrets in dotfiles — secrets go only in `~/.claude/settings.json`

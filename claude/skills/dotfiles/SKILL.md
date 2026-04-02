---
name: dotfiles
description: Dotfiles management workflow — how global Claude config (skills, agents, commands, rules) is maintained via /vault/dotfiles and symlinked to ~/.claude
user_invocable: false
---

# Dotfiles Workflow

Global Claude Code configuration is managed through the dotfiles repo at `/vault/dotfiles/claude/` and symlinked to `~/.claude/` by `install.sh`.

## Architecture

| Dotfiles source | Symlinked to | Content |
|----------------|-------------|---------|
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | Global instructions |
| `claude/agents/*.md` | `~/.claude/agents/` | Agent definitions |
| `claude/skills/*/SKILL.md` | `~/.claude/skills/*/SKILL.md` | Skill definitions |
| `claude/skills/*/reference/` | `~/.claude/skills/*/reference/` | Skill reference dirs |
| `claude/commands/*.md` | `~/.claude/commands/` | Slash commands |
| `claude/rules/*.md` | `~/.claude/rules/` | Global rules |
| `claude/hooks/scripts/*.sh` | `~/.claude/hooks/scripts/` | Hook scripts |
| `claude/statusline-command.sh` | `~/.claude/statusline-command.sh` | Status line script |
| `claude/settings-template.json` | (copied once) | Settings template |

`install.sh` uses glob loops to auto-detect new files — no hardcoded paths needed.

## Adding a new skill

1. Create `skills/<name>/SKILL.md` in `/vault/dotfiles/claude/`
2. If the skill has reference files, create `skills/<name>/reference/` with the files
3. Run `install.sh` — the skills loop auto-detects and symlinks
4. Commit to dotfiles repo

## Adding agents, commands, or rules

1. Create the file in the appropriate `/vault/dotfiles/claude/` subdirectory
2. Run `install.sh` to symlink
3. Commit to dotfiles repo

## Settings changes

- **Non-secret config**: Edit `settings-template.json` in dotfiles, commit
- **Secrets**: Manually edit `~/.claude/settings.json` (never committed)
- `settings.json` is only created from the template on first run (no overwrite)

## After any change

1. Run `/vault/dotfiles/install.sh` to create/update symlinks
2. Commit and push to dotfiles repo

## Rules

- **Never edit files directly in `~/.claude/`** — edit the dotfiles source instead
- **Never put secrets in dotfiles** — secrets go only in `~/.claude/settings.json`
- **Never use `git add .` in `~/.claude/`** — it's not a git repo
- **Project-specific config** goes in the project's `.claude/` dir, not dotfiles

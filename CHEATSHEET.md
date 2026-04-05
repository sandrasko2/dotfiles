# Dev Tooling Cheatsheet

## Shell
- **Default shell:** zsh (managed by Ansible `user_shell`)
- **Prompt:** Starship — config at `/vault/dotfiles/starship.toml`
- **Dotfiles:** managed via `/vault/dotfiles/install.sh` (symlinks to ~)

## Docker Aliases
| Alias | Expands to |
|-------|-----------|
| `dc-dev` | `docker compose -f compose.yml -f compose.dev.yml` |
| `dc-prod` | `docker compose -f compose.yml -f compose.prod.yml` |

## CLI Tools (via devbox global)
| Tool | What it does |
|------|-------------|
| `fzf` | Fuzzy finder |
| `rg` (ripgrep) | Fast code search |
| `fd` | Fast file finder (find replacement) |
| `bat` | cat with syntax highlighting |
| `eza` | Modern ls replacement |
| `delta` | Git diff viewer (side-by-side) |
| `jq` | JSON processor |
| `btop` | System monitor |
| `lazydocker` | Docker TUI |
| `zoxide` | Smart cd (tracks frecency) |
| `terraform` | Infrastructure as code |

## Linters (via uv global tools)
| Tool | Version | Purpose |
|------|---------|---------|
| `ruff` | 0.15.x | Python linter + formatter |
| `pyright` | 1.1.x | Python type checker |
| `sqlfluff` | 4.1.x | SQL linter |

## Git
- **Pager:** delta (side-by-side diffs, syntax highlighting)
- **Interactive diff:** delta with `--color-only`
- **Navigation:** use `n`/`N` to jump between files in delta

## Key Paths
| What | Where |
|------|-------|
| Dotfiles source | `/vault/dotfiles/` |
| Devbox global config | `~/.local/share/devbox/global/default/` |
| Starship config | `/vault/dotfiles/starship.toml` → `~/.config/starship.toml` |
| zshrc | `/vault/dotfiles/.zshrc` → `~/.zshrc` |
| Git config | `/vault/dotfiles/.gitconfig` → `~/.gitconfig` |

## Devbox Commands
| Command | What it does |
|---------|-------------|
| `devbox global list` | Show installed global packages |
| `devbox global add <pkg>` | Add a global package |
| `devbox global rm <pkg>` | Remove a global package |
| `devbox global shellenv` | Print shell env (sourced in .zshrc) |

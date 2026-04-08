# Dotfiles

Personal dotfiles for a DevOps/development/homelab workflow. Managed with [chezmoi](https://www.chezmoi.io/) and deployed across LAN machines with Ansible.

## Files

| Source file | Deployed to | Purpose |
|-------------|-------------|---------|
| `dot_env.sh.tmpl` | `~/.env.sh` | Shared environment: OS detection, BASE_DIR, PATH (with dedup), EZA_COLORS palette |
| `dot_zshrc.tmpl` | `~/.zshrc` | Primary shell config: zinit plugins, starship prompt, tool integrations |
| `dot_bashrc` | `~/.bashrc` | Bash fallback: history, prompt with git branch, shell options |
| `dot_aliases.tmpl` | `~/.aliases` | Aliases & functions: eza/ls, Docker, Git, Tmux, system utilities (shared by both shells) |
| `dot_profile` | `~/.profile` | Bash login shell bootstrap — sources `.env.sh` and `.bashrc` |
| `dot_zprofile` | `~/.zprofile` | Zsh login shell bootstrap — sources `.env.sh` |
| `dot_gitconfig.tmpl` | `~/.gitconfig` | Git: aliases, delta pager, vimdiff, sensible defaults, templated identity |
| `dot_inputrc` | `~/.inputrc` | Readline: case-insensitive completion, prefix history search, word navigation |
| `dot_vimrc` | `~/.vimrc` | Vim IDE-lite: vim-plug, 12 plugins (NERDTree, fzf, gruvbox, airline, etc.) |
| `dot_tmux.conf` | `~/.tmux.conf` | Tmux: Ctrl-a prefix, vim nav, mouse, TPM with resurrect/continuum |
| `dot_dircolors` | `~/.dircolors` | Dracula LS_COLORS theme |
| `dot_config/starship.toml` | `~/.config/starship.toml` | Starship prompt: two-line layout with Nerd Font icons |
| `dot_config/alacritty/` | `~/.config/alacritty/` | Alacritty terminal: Dracula colors, JetBrainsMono Nerd Font, tmux-friendly |
| `dot_config/nvim/` | `~/.config/nvim/` | Neovim config: Lazy.nvim, Lua-based setup |
| `dot_config/opencode/` | `~/.config/opencode/` | OpenCode AI config and agents |
| `dot_claude/` | `~/.claude/` | Claude Code config: CLAUDE.md, hooks, statusline, settings template |
| `run_once_install-tools.sh` | *(run script)* | Idempotent bootstrap: vim-plug, TPM, fzf, undodir |
| `run_once_setup-opencode-symlinks.sh.tmpl` | *(run script)* | Vault-conditional symlinks for OpenCode agents/commands/skills |
| `bootstrap.sh` | *(not deployed)* | Entry point: installs chezmoi, writes config, cleans old symlinks, applies |

## Quick Start

### Existing machine (replacing install.sh)

```bash
cd /vault/dotfiles    # or ~/opt/dotfiles on macOS
./bootstrap.sh
exec zsh
```

`bootstrap.sh` is idempotent — safe to run multiple times. It will:
1. Install chezmoi if not present (brew on macOS, curl installer otherwise)
2. Write `~/.config/chezmoi/chezmoi.toml` if missing (won't overwrite existing)
3. Remove dangling symlinks from the old `install.sh` era
4. Run `chezmoi apply`

### New server bootstrap

```bash
# Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin

# Clone the repo
git clone <repo-url> ~/dotfiles

# Configure chezmoi
mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml << 'EOF'
sourceDir = "/home/user/dotfiles"

[data]
  has_vault = false
  vault_base = "/home/user"
EOF

# Apply
chezmoi apply
exec zsh
vim +PlugInstall +qall
```

## chezmoi Data Variables

Template variables are defined in `.chezmoidata.yaml` (committed to the repo):

| Variable | Purpose |
|----------|---------|
| `git_name` | Git user.name |
| `git_email` | Git user.email |
| `vault_base` | Base directory (`/vault` on servers, `$HOME` on laptops) |
| `has_vault` | Whether `/vault` exists (guards vault-only aliases and paths) |
| `ollama_base_url` | Ollama API endpoint for OpenCode |

Per-machine overrides go in `~/.config/chezmoi/chezmoi.toml` under `[data]`:

```toml
sourceDir = "/home/user/dotfiles"

[data]
  has_vault = false
  vault_base = "/home/user"
```

## Prerequisites

- **zsh** 5.8+ (primary shell)
- **bash** 4.0+ (fallback)
- **git**
- **curl**
- **vim** (vim-plug installs plugins automatically)
- **tmux** (optional, for tmux config)

## Machine-Specific Overrides

These files are **not tracked** in git — create them per machine:

### `~/.zshrc.local`

Zsh-specific overrides: extra PATH entries, environment variables, or aliases for one machine.

```zsh
export KUBECONFIG=~/.kube/config
alias proj='cd /home/user/projects'
```

### `~/.bashrc.local`

Same as above, for bash sessions.

### `~/.config/chezmoi/chezmoi.toml`

Per-machine chezmoi data overrides (see [chezmoi Data Variables](#chezmoi-data-variables) above).

## Automated Sync

Deployment is managed by the Ansible repo via a systemd timer that runs
`git pull --ff-only` and `chezmoi apply` every 15 minutes. See the
`dotfiles` role in the Ansible repo for details.

## Tmux Quick Reference

| Key | Action |
|-----|--------|
| `Ctrl-a` | Prefix (instead of Ctrl-b) |
| `prefix + \|` | Split vertical |
| `prefix + -` | Split horizontal |
| `prefix + h/j/k/l` | Navigate panes |
| `prefix + H/J/K/L` | Resize panes |
| `Alt + 1-5` | Switch to window 1-5 |
| `prefix + r` | Reload config |
| `prefix + I` | Install TPM plugins |
| `prefix + [` | Enter copy mode (vi keys) |

## Vim Quick Reference

| Key | Action |
|-----|--------|
| `Space` | Leader key |
| `Ctrl-p` | Fuzzy find files (fzf) |
| `Space + g` | Ripgrep search (fzf) |
| `Space + n` | Toggle NERDTree |
| `Space + f` | Find current file in NERDTree |
| `Space + b` | List buffers |
| `Ctrl-h/j/k/l` | Navigate windows |
| `Space + ]` / `Space + [` | Next/prev buffer |
| `gcc` | Toggle comment (line) |
| `F2` | Toggle paste mode |
| `Space + w` | Save |
| `Space + q` | Quit |

## Shell Aliases Quick Reference

| Alias | Command |
|-------|---------|
| `dcup` / `dcupd` | `docker compose up` / `up -d` |
| `ddown` | `docker compose down` |
| `dlogs` | `docker compose logs -f` |
| `dps` | `docker ps` (clean format) |
| `dkill` | Kill all running containers |
| `gs` | `git status` |
| `gd` / `gds` | `git diff` / `diff --staged` |
| `gl` / `glg` | `git log` / log graph |
| `ta` / `tls` / `tn` | tmux attach / list / new |
| `ll` / `la` / `lt` | File listing (eza with icons where available, ls fallback) |
| `ports` | `ss -tulnp` |
| `extract` | Universal archive extractor |
| `mkcd` | mkdir + cd |

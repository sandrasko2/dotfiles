# Dotfiles

Personal dotfiles for a DevOps/development/homelab workflow. Managed via symlinks and deployed across LAN machines with Ansible.

## Files

| File | Purpose |
|------|---------|
| `.env.sh` | Shared environment: OS detection, BASE_DIR, PATH (with dedup), EZA_COLORS palette |
| `.zshrc` | Primary shell config: zinit plugins, starship prompt, tool integrations |
| `.bashrc` | Bash fallback: history, prompt with git branch, shell options |
| `.aliases` | Aliases & functions: eza/ls, Docker, Git, Tmux, system utilities (shared by both shells) |
| `.profile` | Bash login shell bootstrap — sources `.env.sh` and `.bashrc` |
| `.zprofile` | Zsh login shell bootstrap — sources `.env.sh` |
| `alacritty.toml` | Alacritty terminal: Dracula colors, JetBrainsMono Nerd Font, tmux-friendly |
| `.inputrc` | Readline: case-insensitive completion, prefix history search, word navigation |
| `.vimrc` | Vim IDE-lite: vim-plug, 12 plugins (NERDTree, fzf, gruvbox, airline, etc.) |
| `.config/nvim/` | Neovim config: Lazy.nvim, Lua-based setup |
| `.tmux.conf` | Tmux: Ctrl-a prefix, vim nav, mouse, TPM with resurrect/continuum |
| `.gitconfig` | Git: aliases, delta pager, vimdiff, sensible defaults, local include for identity |
| `starship.toml` | Starship prompt: two-line layout with Nerd Font icons |
| `install.sh` | Bootstrap: symlinks dotfiles, installs vim-plug, TPM, fzf |

## Quick Start

```bash
git clone <repo-url> /vault/dotfiles
cd /vault/dotfiles
./install.sh
exec zsh
vim +PlugInstall +qall
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

### `~/.gitconfig.local`

Git identity (required — `.gitconfig` includes this automatically):

```ini
[user]
    name = Your Name
    email = you@example.com
```

## Automated Sync

Deployment is managed by the Ansible repo via a systemd timer that runs
`git pull --ff-only` and re-runs `install.sh` every 15 minutes. See the
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

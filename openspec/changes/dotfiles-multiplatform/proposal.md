## Why

The dotfiles repo evolved from a single-machine bash setup but now serves 6 hosts across macOS and Linux. The config has accumulated inconsistencies: `.bash_aliases` is sourced by zsh (confusing name), `BASE_DIR` and `PATH` are set in three places, eza colors break on macOS because `dircolors` doesn't exist, and each terminal emulator renders ANSI colors differently. The user wants one coherent config that looks and works the same everywhere.

## What Changes

- **BREAKING**: Rename `.bash_aliases` to `.aliases` — all sourcing references updated
- **BREAKING**: Standardize on zsh as default shell across all hosts (bash kept as minimal stub)
- Create shared `.env.sh` for environment variables (`BASE_DIR`, `PATH`, `EZA_COLORS`) — sourced by both `.zshrc` and `.bashrc`
- Add Alacritty terminal emulator config (`.config/alacritty/alacritty.toml`) with Dracula theme — same file on macOS and Linux
- Alias `ls` to `eza` everywhere (with fallback to system `ls` if eza not installed)
- Add OS detection guards (`uname -s`) for platform-specific commands (`ss` vs `netstat`, `dircolors` vs none, etc.)
- Slim `.bashrc` to a minimal stub that sources `.env.sh` and `.aliases`
- Remove `dircolors.dracula` dependency for color — eza uses `EZA_COLORS` (256-color, portable), terminal emulator handles base ANSI palette via its Dracula theme config
- Update `install.sh` to symlink new/renamed files

## Capabilities

### New Capabilities
- `alacritty-config`: Cross-platform Alacritty terminal config with Dracula theme, Nerd Font, and tmux-friendly defaults
- `shared-env`: Centralized environment variables (`.env.sh`) sourced by all shells, with OS detection guards
- `cross-platform-aliases`: Platform-aware aliases and eza-as-ls setup in `.aliases`

### Modified Capabilities

## Impact

- All 6 hosts need updated symlinks (via `install.sh` or Ansible)
- Users of `~/.bash_aliases` path directly (scripts, CI) will break — mitigated by the fact only `.bashrc` and `.zshrc` source it
- `.claude/settings.local.json` allow-list references `.bash_aliases` path — needs update
- `README.md` documents `.bash_aliases` — needs update
- Servers need zsh installed and set as default shell (Ansible task, not in this repo)
- Alacritty needs to be installed on macOS (brew) and workstation (apt/package manager)

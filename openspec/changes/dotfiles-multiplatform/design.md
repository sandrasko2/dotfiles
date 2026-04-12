## Context

The dotfiles repo (`/vault/dotfiles/`) serves 6 hosts: 1 MacBook (macOS), 1 workstation (Linux), and 4 servers (Linux). Currently zsh is only used on the MacBook and workstation; servers use bash. The user wants to standardize on zsh everywhere, use Alacritty as the terminal emulator on interactive machines, and have consistent Dracula-themed colors across all hosts and terminals.

Current file structure and sourcing chain:
```
.zprofile → BASE_DIR, PATH
.zshrc → zinit, plugins, tools, sources .bash_aliases
.bashrc → history, shopt, PS1, tools, sources .bash_aliases
.bash_aliases → shared aliases, EZA_COLORS, functions
```

Key problems: `.bash_aliases` name is misleading, `BASE_DIR`/`PATH` defined in 3 places, no OS detection, eza colors broken on macOS (no `dircolors`), terminal color rendering differs between iTerm2 and Terminator.

## Goals / Non-Goals

**Goals:**
- One shell config that works identically on macOS and Linux
- Consistent Dracula color theme: same visual output regardless of host or terminal
- Clean file naming that reflects actual purpose
- Centralized environment variables (define once, source everywhere)
- eza as the canonical file lister, aliased as `ls`
- Alacritty as the standard terminal emulator on interactive machines
- Minimal bash stub for fallback/emergency sessions
- Deploy to MacBook + workstation first, servers later

**Non-Goals:**
- Ansible role changes (deployment is a separate concern; this change is config only)
- Server provisioning (installing zsh, eza, starship on servers)
- Removing `.bashrc` entirely (keep as thin stub)
- Supporting terminals other than Alacritty (iTerm2/Terminator configs not maintained)
- Fish shell or other shell support

## Decisions

### 1. File architecture

**Decision:** Three-layer sourcing model with centralized env.

```
Login shell
├── .zprofile ─── sources .env.sh
├── .profile ──── sources .env.sh (bash login fallback)

Interactive shell
├── .zshrc ────── sources .env.sh, .aliases, zinit, tools
├── .bashrc ───── sources .env.sh, .aliases (minimal stub)

Shared
├── .env.sh ───── BASE_DIR, PATH, EZA_COLORS, OS detection
├── .aliases ──── aliases, functions (portable bash/zsh)
```

**Rationale:** `.env.sh` is the single source of truth for environment. Both shells source it, eliminating the triple-definition of `BASE_DIR`/`PATH`. The `.aliases` rename makes the shared nature explicit.

**Alternative considered:** Keeping everything in `.zshrc` and making `.bashrc` source `.zshrc`. Rejected because zsh-specific syntax (`setopt`, `zinit`) would break bash.

### 2. Terminal emulator: Alacritty

**Decision:** Standardize on Alacritty with a shared TOML config.

**Rationale:**
- Same config file (`~/.config/alacritty/alacritty.toml`) works on macOS and Linux
- `alacritty` terminfo is in upstream ncurses — SSH to servers just works
- Designed to pair with tmux (no built-in tabs/splits)
- Lightest resource footprint (~50MB)
- TOML config is simple and declarative
- `brew install alacritty` on Mac, `apt install alacritty` on Linux

**Alternatives considered:**
- Kitty: better SSH story (`kitten ssh`), but documented tmux edge cases and heavier
- Ghostty: great performance, but no apt package and SSH TERM friction on every server
- WezTerm: richest features, but ~320MB RAM, stalled formal releases, Lua config complexity

### 3. Color strategy: terminal theme + 256-color codes

**Decision:** Two-layer color approach:
1. Alacritty config defines Dracula ANSI palette (colors 0-15) — makes base ANSI codes render as Dracula
2. `EZA_COLORS` uses 256-color codes (`38;5;nnn`) — portable across all terminals

**Rationale:** 256-color codes render identically everywhere. The terminal's Dracula theme handles the base 16 ANSI colors. No dependency on `dircolors` (which doesn't exist on macOS). `LS_COLORS` becomes irrelevant because `ls` is aliased to `eza`.

**Alternative considered:** Installing GNU coreutils on macOS for `dircolors` support. Rejected because aliasing `ls` to `eza` makes `LS_COLORS`/`dircolors` unnecessary.

### 4. OS detection pattern

**Decision:** Use `uname -s` in `.env.sh` to set an `_OS` variable, then use it for platform-specific guards.

```sh
case "$(uname -s)" in
    Darwin) _OS=macos ;;
    Linux)  _OS=linux ;;
esac
```

**Rationale:** POSIX-compatible, works in both bash and zsh, fast (single fork). Guards in `.aliases` use `$_OS` for platform-specific aliases (`ss` vs `netstat`, `open` vs `xdg-open`, etc.).

### 5. eza as ls

**Decision:** Alias `ls` to `eza` when available, with transparent fallback.

```sh
if command -v eza &>/dev/null; then
    alias ls='eza --icons --color=always'
    alias ll='eza -la --icons --sort=modified'
    # ...
else
    alias ll='ls -lart'
    # ...
fi
```

**Rationale:** Servers may not have eza yet. The `command -v` guard means the config works immediately on bare servers and gains eza features as they're provisioned.

## Risks / Trade-offs

- **[Risk] Rename breaks muscle memory for `~/.bash_aliases` path** → Mitigation: the file is only sourced programmatically; no one types the path manually. Update all references in one commit.

- **[Risk] `.env.sh` sourced multiple times per session** (login + interactive) → Mitigation: environment variable exports are idempotent. PATH dedup can be added if needed, but is unlikely to matter with consistent sourcing.

- **[Risk] Servers don't have zsh/eza/starship yet** → Mitigation: every tool integration uses `command -v` guards. Config degrades gracefully to bare bash + basic aliases. Server provisioning is a separate Ansible concern.

- **[Risk] Alacritty `TERM` value not recognized on old servers** → Mitigation: Alacritty's terminfo is in upstream ncurses since 2022. Servers on Ubuntu 22.04+ have it. For older servers, `.env.sh` can set `TERM=xterm-256color` as fallback.

- **[Trade-off] Dropping `dircolors.dracula`** — `ls` (GNU) won't have Dracula colors if invoked directly (not through the eza alias). Acceptable because `ls` is aliased to `eza` and direct `/bin/ls` use is rare.

- **[Trade-off] Alacritty has no ligatures** — permanent limitation. Acceptable per user decision (doesn't use ligatures).

## Migration Plan

1. Create new files (`.env.sh`, `alacritty.toml`) and rename `.bash_aliases` → `.aliases` in the repo
2. Update all sourcing references (`.zshrc`, `.bashrc`, `.profile`, `.zprofile`, `install.sh`, `README.md`, `.claude/settings.local.json`)
3. Slim `.bashrc` to minimal stub
4. Test on workstation (`exec zsh`, verify colors, aliases, env vars)
5. Push, pull on MacBook, test there
6. Install Alacritty on both machines, test terminal rendering
7. Once stable, roll to servers via Ansible (separate change)

**Rollback:** `git revert` the commit. `install.sh` re-symlinks everything. Old `.bash_aliases` symlink remains dangling but `.bashrc`/`.zshrc` would point back to it after revert.

## Open Questions

- Should `.env.sh` also handle `EDITOR`, `PAGER`, `LANG`/`LC_*` (currently not centralized)?
- Should the hostname-specific `dfiles` alias in `.aliases` use a more general host-role mechanism?
- Does the Ansible role need to `chsh` servers to zsh, or is that manual?

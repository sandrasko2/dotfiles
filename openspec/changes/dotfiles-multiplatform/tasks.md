## 1. Shared Environment (.env.sh)

- [x] 1.1 Create `.env.sh` with OS detection (`_OS` variable via `uname -s`)
- [x] 1.2 Move `BASE_DIR=/vault` into `.env.sh` (remove from `.zshrc`, `.bashrc`, `.zprofile`)
- [x] 1.3 Centralize `PATH` extensions in `.env.sh` with deduplication guard
- [x] 1.4 Move `EZA_COLORS` palette build from `.bash_aliases` into `.env.sh`
- [x] 1.5 Verify `.env.sh` sources without error in both bash and zsh on Linux
- [x] 1.6 Verify `.env.sh` sources without error in zsh on macOS

## 2. Rename and Refactor Aliases

- [x] 2.1 `git mv .bash_aliases .aliases`
- [x] 2.2 Add `ls` alias to eza (with `--icons --color=always`) when eza is available
- [x] 2.3 Add platform-specific aliases using `$_OS` guard (`ports`, `open`)
- [x] 2.4 Make `reload` alias shell-aware (zsh → `.zshrc`, bash → `.bashrc`)
- [x] 2.5 Remove `BASE_DIR`, `PATH`, and `EZA_COLORS` definitions from `.aliases` (now in `.env.sh`)
- [x] 2.6 Verify `.aliases` sources without error in both bash and zsh

## 3. Update Shell RC Files

- [x] 3.1 Update `.zshrc` to source `~/.env.sh` and `~/.aliases` (remove `.bash_aliases` reference)
- [x] 3.2 Remove `BASE_DIR` and `PATH` definitions from `.zshrc` (now in `.env.sh`)
- [x] 3.3 Remove `dircolors` block from `.zshrc` (eza replaces ls, no `LS_COLORS` needed)
- [x] 3.4 Slim `.bashrc` to minimal stub: source `.env.sh`, `.aliases`, basic prompt, bash-completion
- [x] 3.5 Update `.zprofile` to source `~/.env.sh` (remove inline `BASE_DIR`/`PATH`)
- [x] 3.6 Update `.profile` to source `~/.env.sh` (remove inline `PATH`)

## 4. Alacritty Config

- [x] 4.1 Create `alacritty.toml` with Dracula color palette (all 16 ANSI colors + fg/bg/cursor)
- [x] 4.2 Configure Nerd Font family and size in `alacritty.toml`
- [x] 4.3 Set tmux-compatible defaults (no conflicting keybindings)
- [x] 4.4 Add `alacritty.toml` symlink step to `install.sh` (→ `~/.config/alacritty/alacritty.toml`)

## 5. Update install.sh and References

- [x] 5.1 Replace `.bash_aliases` with `.aliases` in `install.sh` FILES array
- [x] 5.2 Add `.env.sh` to `install.sh` FILES array
- [x] 5.3 Add Alacritty config symlink to `install.sh` (create `~/.config/alacritty/` if needed)
- [x] 5.4 Update `README.md` table (`.bash_aliases` → `.aliases`, add `.env.sh` and `alacritty.toml`)
- [x] 5.5 Update `.claude/settings.local.json` allow-list path

## 6. Verification

- [x] 6.1 Run `install.sh` on workstation — all symlinks created correctly
- [x] 6.2 `exec zsh` on workstation — no errors, `EZA_COLORS` populated, `ll` shows Dracula colors
- [x] 6.3 `bash` fallback session — `.env.sh` and `.aliases` sourced, basic prompt works
- [ ] 6.4 Test on macOS — `source ~/.env.sh && source ~/.aliases` produces no errors
- [ ] 6.5 Verify `ls` invokes eza with icons on both platforms
- [ ] 6.6 Verify no dark blue or unreadable colors in Alacritty with Dracula theme

## ADDED Requirements

### Requirement: File renamed from .bash_aliases to .aliases
The shared alias file SHALL be named `.aliases` and sourced by both `.zshrc` and `.bashrc`.

#### Scenario: .zshrc sources .aliases
- **WHEN** zsh starts an interactive session
- **THEN** `.aliases` is sourced and all aliases are available

#### Scenario: .bashrc sources .aliases
- **WHEN** bash starts an interactive session
- **THEN** `.aliases` is sourced and all aliases are available

#### Scenario: install.sh symlinks .aliases
- **WHEN** `install.sh` runs
- **THEN** `~/.aliases` is a symlink to the repo's `.aliases`

### Requirement: ls aliased to eza
When eza is installed, `ls` SHALL be aliased to `eza` with color and icon support.

#### Scenario: ls invokes eza when available
- **WHEN** `command -v eza` succeeds
- **THEN** typing `ls` runs `eza --icons --color=always`

#### Scenario: ls falls back to system ls when eza is absent
- **WHEN** `command -v eza` fails
- **THEN** typing `ls` runs the system `ls` with `--color=auto`

#### Scenario: ll shows long format sorted by modified time
- **WHEN** user types `ll`
- **THEN** output shows long listing with icons, sorted by modification time (newest last)

### Requirement: Platform-specific aliases
Aliases that differ between macOS and Linux SHALL use OS detection to set the correct variant.

#### Scenario: ports alias on Linux
- **WHEN** shell starts on Linux
- **THEN** `ports` is aliased to `ss -tulnp`

#### Scenario: ports alias on macOS
- **WHEN** shell starts on macOS
- **THEN** `ports` is aliased to `netstat -an -p tcp`

#### Scenario: open command on Linux
- **WHEN** shell starts on Linux
- **THEN** `open` is aliased to `xdg-open` (if not already a command)

### Requirement: All aliases work in both bash and zsh
Every alias and function in `.aliases` SHALL use syntax compatible with both bash and zsh.

#### Scenario: No bash-only or zsh-only syntax
- **WHEN** `.aliases` is sourced in bash
- **THEN** no syntax errors are produced

#### Scenario: No zsh-only syntax errors
- **WHEN** `.aliases` is sourced in zsh (with default options)
- **THEN** no syntax errors are produced

### Requirement: reload alias is shell-aware
The `reload` alias SHALL source the correct RC file for the current shell.

#### Scenario: reload in zsh
- **WHEN** user types `reload` in zsh
- **THEN** `~/.zshrc` is re-sourced

#### Scenario: reload in bash
- **WHEN** user types `reload` in bash
- **THEN** `~/.bashrc` is re-sourced

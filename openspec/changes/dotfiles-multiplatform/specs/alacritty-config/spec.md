## ADDED Requirements

### Requirement: Alacritty config exists at standard path
The repo SHALL include an `alacritty.toml` file that `install.sh` symlinks to `~/.config/alacritty/alacritty.toml` on both macOS and Linux.

#### Scenario: Config is symlinked on install
- **WHEN** `install.sh` runs on a fresh machine
- **THEN** `~/.config/alacritty/alacritty.toml` is a symlink to the repo's `alacritty.toml`

#### Scenario: Config works on both platforms
- **WHEN** the same `alacritty.toml` is loaded on macOS and Linux
- **THEN** Alacritty starts without errors on both platforms

### Requirement: Dracula color scheme
The Alacritty config SHALL define the Dracula color palette for ANSI colors 0-15 (normal + bright), plus foreground, background, and cursor colors.

#### Scenario: Base ANSI colors match Dracula
- **WHEN** a program outputs ANSI color code 4 (blue)
- **THEN** the rendered color is Dracula blue (`#6272a4`), not the default dark blue

#### Scenario: No dark blue or unreadable colors
- **WHEN** any ANSI color 0-15 is rendered in Alacritty
- **THEN** every color is readable against the Dracula background (`#282a36`)

### Requirement: Nerd Font configured
The Alacritty config SHALL specify a Nerd Font as the primary font family with a readable default size.

#### Scenario: Nerd Font icons render correctly
- **WHEN** eza outputs Nerd Font icons (via `--icons`)
- **THEN** icons render as glyphs, not as missing-character boxes

### Requirement: tmux-compatible defaults
The Alacritty config SHALL NOT set keybindings or options that conflict with tmux.

#### Scenario: tmux key passthrough
- **WHEN** user presses `Ctrl+B` (tmux prefix) inside Alacritty
- **THEN** the keypress is passed to tmux, not intercepted by Alacritty

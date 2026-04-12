## ADDED Requirements

### Requirement: Centralized environment file
A `.env.sh` file SHALL exist in the repo and be symlinked to `~/.env.sh`. It SHALL be sourced by `.zshrc`, `.bashrc`, `.zprofile`, and `.profile`.

#### Scenario: .env.sh is the single source for BASE_DIR
- **WHEN** a shell session starts (login or interactive, bash or zsh)
- **THEN** `BASE_DIR` is set to `/vault` and was defined only in `.env.sh`

#### Scenario: .env.sh is the single source for PATH extensions
- **WHEN** a shell session starts
- **THEN** `PATH` includes `~/.local/bin` and `$BASE_DIR/code/shell`, defined only in `.env.sh`

### Requirement: OS detection
`.env.sh` SHALL detect the operating system and export a variable indicating the platform.

#### Scenario: macOS detected
- **WHEN** `.env.sh` is sourced on macOS
- **THEN** the OS variable is set to `macos`

#### Scenario: Linux detected
- **WHEN** `.env.sh` is sourced on Linux
- **THEN** the OS variable is set to `linux`

### Requirement: EZA_COLORS defined in .env.sh
`EZA_COLORS` SHALL be built and exported in `.env.sh` using 256-color codes with named Dracula palette variables.

#### Scenario: EZA_COLORS expands correctly in zsh
- **WHEN** `.env.sh` is sourced in zsh
- **THEN** `$EZA_COLORS` is a non-empty colon-delimited string containing entries like `di=1;38;5;141`

#### Scenario: EZA_COLORS expands correctly in bash
- **WHEN** `.env.sh` is sourced in bash
- **THEN** `$EZA_COLORS` is identical to the zsh expansion

### Requirement: PATH deduplication
`.env.sh` SHALL NOT add duplicate entries to `PATH` when sourced multiple times in a session.

#### Scenario: Double-sourcing does not duplicate PATH
- **WHEN** `.env.sh` is sourced twice (e.g., login + interactive shell)
- **THEN** `echo "$PATH" | tr ':' '\n' | sort | uniq -d` produces no output for entries added by `.env.sh`

### Requirement: idempotent sourcing
`.env.sh` SHALL be safe to source multiple times without side effects.

#### Scenario: Variables unchanged on re-source
- **WHEN** `.env.sh` is sourced a second time
- **THEN** all exported variables have the same values as after the first source

# ~/.env.sh — shared environment for bash and zsh
# Sourced by .zshrc, .bashrc, .zprofile, .profile
# Must be safe to source multiple times (idempotent)

# ---------------------------------------------------------------------------
# OS detection
# ---------------------------------------------------------------------------
case "$(uname -s)" in
    Darwin) _OS=macos ;;
    Linux)  _OS=linux ;;
    *)      _OS=unknown ;;
esac

# ---------------------------------------------------------------------------
# Base directory
# ---------------------------------------------------------------------------
export BASE_DIR=/vault

# ---------------------------------------------------------------------------
# PATH (with deduplication guard)
# ---------------------------------------------------------------------------
_add_to_path() {
    case ":$PATH:" in
        *:"$1":*) ;;
        *) PATH="$1:$PATH" ;;
    esac
}

_add_to_path "$HOME/.local/bin"
_add_to_path "$BASE_DIR/code/shell"
export PATH
unset -f _add_to_path

# ---------------------------------------------------------------------------
# EZA_COLORS — Dracula palette (256-color, portable)
# ---------------------------------------------------------------------------
_purple="38;5;141"  _cyan="38;5;117"  _green="38;5;84"
_pink="38;5;212"    _orange="38;5;215" _red="38;5;203"
_gray="38;5;243"

_eza=(
    # Metadata
    "da=${_purple}"
    "sn=${_green}:sb=${_green}"
    "uu=${_cyan}:un=${_orange}"
    "gu=${_cyan}:gn=${_orange}"
    "ur=${_green}:uw=${_pink}:ux=${_cyan}:ue=${_cyan}"
    "gr=${_green}:gw=${_pink}:gx=${_cyan}"
    "tr=${_green}:tw=${_pink}:tx=${_cyan}"
    "ga=${_green}:gm=${_orange}:gd=${_red}:gv=${_cyan}:gt=${_purple}"
    "xx=${_gray}"
    # File types
    "di=1;${_purple}" "ln=1;${_cyan}" "ex=1;${_green}" "fi=0"
    "or=1;${_red}" "pi=${_orange}" "so=1;${_pink}" "bd=${_orange}" "cd=${_orange}"
    # Archives
    "*.tar=1;${_red}" "*.gz=1;${_red}" "*.zip=1;${_red}" "*.7z=1;${_red}"
    "*.bz2=1;${_red}" "*.xz=1;${_red}" "*.zst=1;${_red}" "*.deb=1;${_red}" "*.rpm=1;${_red}"
    # Images & video
    "*.jpg=1;${_pink}" "*.png=1;${_pink}" "*.gif=1;${_pink}" "*.svg=1;${_pink}"
    "*.mp4=1;${_pink}" "*.mkv=1;${_pink}" "*.webm=1;${_pink}" "*.mov=1;${_pink}"
    # Audio
    "*.mp3=${_cyan}" "*.flac=${_cyan}" "*.ogg=${_cyan}" "*.wav=${_cyan}" "*.m4a=${_cyan}"
    # Backup/temp
    "*.bak=${_gray}" "*.tmp=${_gray}" "*.swp=${_gray}" "*.old=${_gray}" "*~=${_gray}"
)
EZA_COLORS="$(IFS=:; echo "${_eza[*]}")"
export EZA_COLORS
unset _purple _cyan _green _pink _orange _red _gray _eza

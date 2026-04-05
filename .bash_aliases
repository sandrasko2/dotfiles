# ~/.bash_aliases — sourced by .bashrc

# ---------------------------------------------------------------------------
# Safety
# ---------------------------------------------------------------------------
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# ---------------------------------------------------------------------------
# Navigation / directories
# ---------------------------------------------------------------------------
alias vault='cd /vault'
alias storage='cd /mnt/storage/vault'
alias back='cd $BASE_DIR/backups'
alias code='cd $BASE_DIR/code'
alias xlog='cd $BASE_DIR/logs'
alias xsh='cd /vault/code/shell'
alias ddata='cd $BASE_DIR/docker-data'
if [ "$(hostname)" = "hl-ubsrv-media-01" ]; then
    alias dfiles='cd /vault/docker-files/traefik'
else
    alias dfiles='cd /vault/docker-files/monolith'
fi
alias media='cd /mnt/storage/vault/media'

# ---------------------------------------------------------------------------
# File listing
# ---------------------------------------------------------------------------
# Dracula palette for eza (256-color — eza ignores true-color codes)
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

if command -v eza &>/dev/null; then
    alias ll='eza -la --icons --sort=modified'
    alias la='eza -a --icons'
    alias lt='eza -l --icons --sort=modified'
    alias l.='eza -d --icons .*'
else
    alias ll='ls -lart'
    alias la='ls -A'
    alias lt='ls -lrt'
    alias l.='ls -d .*'
fi

# ---------------------------------------------------------------------------
# Docker
# ---------------------------------------------------------------------------
alias dcup='docker compose up'
alias dcupd='docker compose up -d'
alias ddown='docker compose down'
alias dlogs='docker logs'
alias dclogs='docker compose logs -f'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dexec='docker exec -it'
alias drm='docker container rm'
alias dstop='docker container stop'
alias dstats='docker stats'
alias dprune='docker system prune -af --volumes'

dkill() {
    local containers
    containers=$(docker ps -q)
    if [ -n "$containers" ]; then
        docker kill $containers
    else
        echo "No running containers."
    fi
}

# ---------------------------------------------------------------------------
# Git
# ---------------------------------------------------------------------------
alias gs='git status'
alias ga='git add'
alias gap='git add -p'
alias gall='git add -A'
alias gc='git commit -m'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline -20'
alias glg='git log --oneline --graph --decorate -20'
alias gp='git push'
alias gpl='git pull'
alias gb='git branch'
alias gco='git checkout'
alias gsw='git switch'
alias gst='git stash'
alias gstp='git stash pop'

# ---------------------------------------------------------------------------
# Ansible
# ---------------------------------------------------------------------------
alias ap='ansible-playbook'
alias ans-decrypt='ansible-vault decrypt'
alias ans-encrypt='ansible-vault encrypt'
alias ans-play='ansible-playbook'

# ---------------------------------------------------------------------------
# Tmux
# ---------------------------------------------------------------------------
alias ta='tmux attach -t'
alias tls='tmux list-sessions'
alias tn='tmux new-session -s'
alias tkill='tmux kill-session -t'

# ---------------------------------------------------------------------------
# System / utilities
# ---------------------------------------------------------------------------
alias python='python3'
alias ports='ss -tulnp'
alias myip='curl -s https://ifconfig.me && echo'
alias dfh='df -h'
alias memfree='free -h'
alias psg='ps aux | grep -v grep | grep -i'
alias reload='source ~/.bashrc'
alias path='echo $PATH | tr ":" "\n"'
alias now='date +"%F %T"'

# ---------------------------------------------------------------------------
# Functions
# ---------------------------------------------------------------------------

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Universal archive extractor
extract() {
    if [ -z "$1" ]; then
        echo "Usage: extract <file>"
        return 1
    fi
    if [ ! -f "$1" ]; then
        echo "'$1' is not a valid file."
        return 1
    fi
    case "$1" in
        *.tar.bz2) tar xjf "$1"   ;;
        *.tar.gz)  tar xzf "$1"   ;;
        *.tar.xz)  tar xJf "$1"   ;;
        *.bz2)     bunzip2 "$1"   ;;
        *.rar)     unrar x "$1"   ;;
        *.gz)      gunzip "$1"    ;;
        *.tar)     tar xf "$1"    ;;
        *.tbz2)    tar xjf "$1"   ;;
        *.tgz)     tar xzf "$1"   ;;
        *.zip)     unzip "$1"     ;;
        *.Z)       uncompress "$1";;
        *.7z)      7z x "$1"      ;;
        *.zst)     unzstd "$1"    ;;
        *)         echo "'$1' cannot be extracted via extract()" ;;
    esac
}

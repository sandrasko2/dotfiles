# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ---------------------------------------------------------------------------
# History
# ---------------------------------------------------------------------------
HISTCONTROL=ignoreboth
HISTSIZE=50000
HISTFILESIZE=100000
HISTTIMEFORMAT="%F %T  "
shopt -s histappend

# ---------------------------------------------------------------------------
# Shell options
# ---------------------------------------------------------------------------
shopt -s checkwinsize
shopt -s globstar
shopt -s cdspell
shopt -s dirspell
shopt -s autocd
shopt -s cmdhist
shopt -s no_empty_cmd_completion

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# ---------------------------------------------------------------------------
# Color support
# ---------------------------------------------------------------------------
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip -color=auto'
fi

# ---------------------------------------------------------------------------
# Prompt — 2-line with git branch
# ---------------------------------------------------------------------------
__git_branch() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null)
    [ -n "$branch" ] && printf ' (%s)' "$branch"
}

HOST=$(\hostname)

PS1='\n'
PS1+='\[\e[1;32m\](\u@${HOST})\[\e[0m\]'   # user@host in bold green
PS1+=':\[\e[1;34m\]\w\[\e[0m\]'              # working dir in bold blue
PS1+='\[\e[0;33m\]$(__git_branch)\[\e[0m\]'  # git branch in yellow
PS1+='\n'
PS1+='[\A] \$ '                               # time + prompt char

# ---------------------------------------------------------------------------
# Environment
# ---------------------------------------------------------------------------
export BASE_DIR=/vault
PATH=$PATH:$BASE_DIR/code/shell:~/.local/bin

# Alert alias for long running commands (sleep 10; alert)
if command -v notify-send &>/dev/null; then
    alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

# ---------------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------------
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# ---------------------------------------------------------------------------
# Functions
# ---------------------------------------------------------------------------
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

# ---------------------------------------------------------------------------
# Bash completion
# ---------------------------------------------------------------------------
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# ---------------------------------------------------------------------------
# Nix package manager
# ---------------------------------------------------------------------------
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# ---------------------------------------------------------------------------
# fzf integration
# ---------------------------------------------------------------------------
if command -v fzf &>/dev/null; then
    eval "$(fzf --bash)"
fi

# ---------------------------------------------------------------------------
# direnv
# ---------------------------------------------------------------------------
if command -v direnv &>/dev/null; then
    eval "$(direnv hook bash)"
fi

# ---------------------------------------------------------------------------
# Local overrides (machine-specific, not tracked in git)
# ---------------------------------------------------------------------------
[ -f ~/.bashrc.local ] && source ~/.bashrc.local

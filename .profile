# ~/.profile — login shell bootstrap for bash
# Sourced by bash login shells (SSH, TTY, display managers).
# Non-login interactive shells source .bashrc directly.

[ -f ~/.env.sh ] && . ~/.env.sh

if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# ~/.profile — login shell bootstrap for bash
# Sourced by bash login shells (SSH, TTY, display managers).
# Non-login interactive shells source .bashrc directly.

if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

#!/usr/bin/env bash
# chezmoi run_once: idempotent tool bootstrap
set -euo pipefail

info()  { printf '\033[1;34m[INFO]\033[0m  %s\n' "$1"; }
ok()    { printf '\033[1;32m[OK]\033[0m    %s\n' "$1"; }

# ---------------------------------------------------------------------------
# vim-plug
# ---------------------------------------------------------------------------
PLUG_FILE="$HOME/.vim/autoload/plug.vim"
if [ -f "$PLUG_FILE" ]; then
    ok "vim-plug already installed"
else
    info "Installing vim-plug..."
    curl -fLo "$PLUG_FILE" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    ok "vim-plug installed"
fi

# ---------------------------------------------------------------------------
# TPM (Tmux Plugin Manager)
# ---------------------------------------------------------------------------
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ -d "$TPM_DIR" ]; then
    ok "TPM already installed"
else
    info "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    ok "TPM installed"
fi

# ---------------------------------------------------------------------------
# fzf
# ---------------------------------------------------------------------------
if command -v fzf &>/dev/null; then
    ok "fzf already installed"
elif [ -d "$HOME/.fzf" ]; then
    ok "fzf directory exists, running install..."
    "$HOME/.fzf/install" --key-bindings --completion --no-update-rc
else
    info "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --key-bindings --completion --no-update-rc
    ok "fzf installed"
fi

# ---------------------------------------------------------------------------
# Vim undo directory
# ---------------------------------------------------------------------------
mkdir -p "$HOME/.vim/undodir"
ok "~/.vim/undodir exists"

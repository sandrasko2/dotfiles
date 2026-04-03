#!/usr/bin/env bash
# install.sh — Idempotent dotfiles bootstrap script
# Symlinks dotfiles to $HOME, installs vim-plug, TPM, and fzf.
# No sudo required.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Files to symlink (relative to DOTFILES_DIR → $HOME)
FILES=(
    .bashrc
    .bash_aliases
    .inputrc
    .vimrc
    .tmux.conf
    .gitconfig
)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
info()  { printf '\033[1;34m[INFO]\033[0m  %s\n' "$1"; }
ok()    { printf '\033[1;32m[OK]\033[0m    %s\n' "$1"; }
warn()  { printf '\033[1;33m[WARN]\033[0m  %s\n' "$1"; }

backup_file() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        mkdir -p "$BACKUP_DIR"
        cp -a "$target" "$BACKUP_DIR/"
        warn "Backed up $target → $BACKUP_DIR/$(basename "$target")"
    fi
}

# ---------------------------------------------------------------------------
# 1. Symlink dotfiles
# ---------------------------------------------------------------------------
info "Symlinking dotfiles..."
for file in "${FILES[@]}"; do
    src="$DOTFILES_DIR/$file"
    dest="$HOME/$file"

    if [ -L "$dest" ] && [ "$(readlink -f "$dest")" = "$src" ]; then
        ok "$file already linked"
        continue
    fi

    backup_file "$dest"
    ln -sf "$src" "$dest"
    ok "$file → $src"
done

# ---------------------------------------------------------------------------
# 2. Install vim-plug
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
# 3. Install TPM (Tmux Plugin Manager)
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
# 4. Install fzf
# ---------------------------------------------------------------------------
if command -v fzf &>/dev/null; then
    ok "fzf already installed"
elif [ -d "$HOME/.fzf" ]; then
    ok "fzf directory exists, running install..."
    "$HOME/.fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-zsh --no-fish
else
    info "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-zsh --no-fish
    ok "fzf installed"
fi

# ---------------------------------------------------------------------------
# 5. Claude Code (CLAUDE.md, hooks, statusline, settings)
#    Skills, agents, commands, and rules are in /vault/code/claude-skills/
# ---------------------------------------------------------------------------
CLAUDE_DIR="$HOME/.claude"
CLAUDE_SRC="$DOTFILES_DIR/claude"

if [ -d "$CLAUDE_SRC" ]; then
    info "Setting up Claude Code config..."

    # Symlink CLAUDE.md and statusline
    for file in CLAUDE.md statusline-command.sh; do
        src="$CLAUDE_SRC/$file"
        dest="$CLAUDE_DIR/$file"
        if [ -L "$dest" ] && [ "$(readlink -f "$dest")" = "$(readlink -f "$src")" ]; then
            ok "claude/$file already linked"
        else
            backup_file "$dest"
            ln -sf "$src" "$dest"
            ok "claude/$file → $src"
        fi
    done

    # Symlink hook scripts
    if [ -d "$CLAUDE_SRC/hooks/scripts" ]; then
        mkdir -p "$CLAUDE_DIR/hooks/scripts"
        for script in "$CLAUDE_SRC"/hooks/scripts/*.sh; do
            name="$(basename "$script")"
            dest="$CLAUDE_DIR/hooks/scripts/$name"
            if [ -L "$dest" ] && [ "$(readlink -f "$dest")" = "$(readlink -f "$script")" ]; then
                ok "claude/hooks/scripts/$name already linked"
            else
                backup_file "$dest"
                ln -sf "$script" "$dest"
                ok "claude/hooks/scripts/$name → $script"
            fi
        done
    fi

    # Settings: copy template ONLY if no settings.json exists
    if [ ! -f "$CLAUDE_DIR/settings.json" ]; then
        cp "$CLAUDE_SRC/settings-template.json" "$CLAUDE_DIR/settings.json"
        ok "settings.json created from template (add secrets to env block)"
    else
        ok "settings.json exists — skipping (compare with $CLAUDE_SRC/settings-template.json for updates)"
    fi
else
    warn "No claude/ directory in dotfiles — skipping Claude Code setup"
fi

# ---------------------------------------------------------------------------
# 6. Create vim undo directory
# ---------------------------------------------------------------------------
mkdir -p "$HOME/.vim/undodir"
ok "~/.vim/undodir exists"

# ---------------------------------------------------------------------------
# 7. Done
# ---------------------------------------------------------------------------
echo ""
info "Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Reload shell:           source ~/.bashrc"
echo "  2. Install vim plugins:    vim +PlugInstall +qall"
echo "  3. Install tmux plugins:   tmux new -s init   then   prefix + I"
echo "  4. Set git identity in:    ~/.gitconfig.local"
echo "     Example:"
echo "       [user]"
echo "           name = Your Name"
echo "           email = you@example.com"
echo ""

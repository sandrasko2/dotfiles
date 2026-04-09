#!/usr/bin/env bash
# bootstrap.sh — idempotent entry point for dotfiles on any machine
# Safe to run repeatedly. Installs chezmoi, writes initial config, cleans
# dangling symlinks from the old install.sh era, then applies.
set -euo pipefail

# ---------- resolve repo location ----------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"

echo "==> Dotfiles source: $DOTFILES_DIR"

# ---------- install chezmoi if missing ----------
if ! command -v chezmoi &>/dev/null; then
  echo "==> Installing chezmoi..."
  if command -v brew &>/dev/null; then
    brew install chezmoi
  else
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
    export PATH="$HOME/.local/bin:$PATH"
  fi
fi

echo "==> chezmoi: $(chezmoi --version)"

# ---------- write chezmoi config (skip if exists) ----------
CHEZMOI_CONFIG="$HOME/.config/chezmoi/chezmoi.toml"
if [ ! -f "$CHEZMOI_CONFIG" ]; then
  echo "==> Writing $CHEZMOI_CONFIG"
  mkdir -p "$(dirname "$CHEZMOI_CONFIG")"

  if [ -d /vault ]; then
    HAS_VAULT=true
    VAULT_BASE="/vault"
  else
    HAS_VAULT=false
    VAULT_BASE="$HOME"
  fi

  cat > "$CHEZMOI_CONFIG" << EOF
sourceDir = "$DOTFILES_DIR"

[data]
  has_vault = $HAS_VAULT
  vault_base = "$VAULT_BASE"
EOF
else
  echo "==> $CHEZMOI_CONFIG already exists, skipping"
fi

# ---------- remove dangling symlinks ----------
echo "==> Cleaning dangling symlinks..."
SYMLINKS=(
  # dotfiles
  "$HOME/.bashrc"
  "$HOME/.aliases"
  "$HOME/.env.sh"
  "$HOME/.inputrc"
  "$HOME/.vimrc"
  "$HOME/.tmux.conf"
  "$HOME/.gitconfig"
  "$HOME/.zshrc"
  "$HOME/.profile"
  "$HOME/.zprofile"
  "$HOME/.dircolors"
  # config
  "$HOME/.config/starship.toml"
  "$HOME/.config/alacritty/alacritty.toml"
  "$HOME/.config/nvim"
  # claude
  "$HOME/.claude/CLAUDE.md"
  "$HOME/.claude/statusline-command.sh"
  "$HOME/.claude/hooks"
  # opencode
  "$HOME/.config/opencode/opencode.json"
  "$HOME/.config/opencode/AGENTS.md"
  "$HOME/.config/opencode/agents"
  "$HOME/.config/opencode/commands"
  "$HOME/.config/opencode/skills"
)

removed=0
for f in "${SYMLINKS[@]}"; do
  if [ -L "$f" ] && [ ! -e "$f" ]; then
    rm "$f"
    echo "   removed dangling: $f"
    ((removed++)) || true
  fi
done
echo "   $removed dangling symlink(s) removed"

# ---------- apply ----------
echo "==> Running chezmoi apply..."
chezmoi apply

echo ""
echo "Done! Next steps:"
echo "  exec zsh          # reload shell"
echo "  vim +PlugInstall   # install vim plugins (first run)"
echo "  Ctrl-Space + I    # install tmux plugins (inside tmux)"

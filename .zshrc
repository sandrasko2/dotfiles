# ~/.zshrc — managed by /vault/dotfiles

# ---------------------------------------------------------------------------
# History
# ---------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory sharehistory hist_ignore_dups hist_ignore_space

# ---------------------------------------------------------------------------
# PATH
# ---------------------------------------------------------------------------
export PATH="$HOME/.local/bin:$PATH"

# ---------------------------------------------------------------------------
# Zinit bootstrap
# ---------------------------------------------------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions

# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

# ---------------------------------------------------------------------------
# Devbox global shellenv
# ---------------------------------------------------------------------------
if command -v devbox &>/dev/null; then
    eval "$(devbox global shellenv)"
fi

# ---------------------------------------------------------------------------
# Tool integrations
# ---------------------------------------------------------------------------
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

if command -v fzf &>/dev/null; then
    source <(fzf --zsh)
fi

# ---------------------------------------------------------------------------
# Base directory (needed by shared aliases)
# ---------------------------------------------------------------------------
export BASE_DIR=/vault

# ---------------------------------------------------------------------------
# Colors
# ---------------------------------------------------------------------------
if command -v dircolors &>/dev/null; then
    eval "$(dircolors -b)"
fi
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'

# ---------------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------------
alias dc-dev='docker compose -f compose.yml -f compose.dev.yml'
alias dc-prod='docker compose -f compose.yml -f compose.prod.yml'

# Source bash aliases if they exist (shared between bash and zsh)
[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases

# Override reload to source zsh config instead of bash
alias reload='source ~/.zshrc'

# ---------------------------------------------------------------------------
# Direnv
# ---------------------------------------------------------------------------
if command -v direnv &>/dev/null; then
    eval "$(direnv hook zsh)"
fi

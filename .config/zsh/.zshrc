# ------------------------------

export EDITOR="nvim"

# ------------------------------
# PATH
# ------------------------------

typeset -U path  # Deduplicate PATH entries
path=(
  "$HOME/.local/bin"
  $path
)

# ------------------------------
# History
# ------------------------------

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS      # Don't record duplicates
setopt HIST_IGNORE_SPACE     # Don't record commands starting with space
setopt SHARE_HISTORY         # Share history across sessions
setopt APPEND_HISTORY        # Append instead of overwrite

# ------------------------------
# Completions
# ------------------------------

autoload -Uz compinit
compinit -C  # -C skips security check for faster startup

# Git completions for dotfiles helpers
compdef dotfiles=git
compdef df=git

zstyle ':completion:*' menu select                 # Arrow key selection
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # Case-insensitive

# ------------------------------
# Custom configs
# ------------------------------

for config in "$ZDOTDIR"/*.zsh(N); do
  source "$config"
done

# ------------------------------
# Tool initialization
# ------------------------------

eval "$(mise activate zsh)"
eval "$(starship init zsh)"

# ------------------------------
# Local overrides (not in git)
# ------------------------------

[[ -f "$ZDOTDIR/local.zsh" ]] && source "$ZDOTDIR/local.zsh"

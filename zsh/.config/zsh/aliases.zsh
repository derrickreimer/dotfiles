# ------------------------------
# Claude Code
# ------------------------------

claude() {
  tmux rename-window "claude"
  command claude "$@"
}

# ------------------------------
# Codex
# ------------------------------

codex() {
  tmux rename-window "codex"
  command codex "$@"
}

# ------------------------------
# OpenCode
# ------------------------------

oc() {
  tmux rename-window "oc"
  command oc "$@"
}

# ------------------------------
# nvim
# ------------------------------

alias v='nvim'

# ------------------------------
# tmux
# ------------------------------

alias t='tmux attach || tmux new'
alias td='tmux detach-client'

# ------------------------------
# Elixir
# ------------------------------

alias mps='iex -S mix phx.server'

# ------------------------------
# Git
# ------------------------------

# Remove `+` and `-` from start of diff lines; just rely upon color.
alias gd='git diff --color | sed "s/^\([^-+ ]*\)[-+ ]/\\1/" | less -r'

alias gl='git log --stat --color'
alias gs='git status -sb'
alias ga='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gacm='git add -A && git commit -m'
alias gp='git push'
alias gpush='git push'
alias gpull='git pull'
alias gcane='git commit --amend --no-edit'
alias gclean='git branch --merged | egrep -v "(^\*|master|dev|main)" | xargs git branch -d'
alias gpr='git pull-request'
alias gco='git checkout'
alias gb='git branch'

# ------------------------------
# Homebrew
# ------------------------------

alias bb='brew bundle --file="$HOME/dotfiles/brew/Brewfile"'

# ------------------------------
# Encrypted zips
# ------------------------------

alias 7zap='7z a -p -mhe=on'
alias 7zx='7z x'

# ------------------------------------------------------------------------------
# General aliases and functions
# ------------------------------------------------------------------------------

alias l='ls -lhA'
alias c="clear"
alias o="open ."
alias rf="trash"
alias sizes='du -sh -c *'
alias cwd="pwd && pwd | pbcopy && echo 'Copied to clipboard 📁'"

# Run any command from anywhere, without leaving current working directory.
#
# Usage: `in [target] [command]`
# Target: directory (if available), else `z` argument
# Example: `in sand art make:model -a SomeModel`
function in() {(
  if [ -d "$1" ]; then
    cd $1
  else
    z $1
  fi

  eval ${@:2}
)}

# Use rlwrap to fix keyboard input in scripts/commands where it's borked
function wrap() {
  rlwrap --always-readline --no-children $1
}

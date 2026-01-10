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

export PATH="$HOME/.grok/bin:$PATH"

# fpath is modified after the main compinit in .zshrc, so re-run it to pick
# up Grok's completions.
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C

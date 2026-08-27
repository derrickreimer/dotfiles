# Append rather than prepend: Grok also ships `agent`, which collides with
# Cursor Agent in ~/.local/bin (already first on PATH in .zshrc).
path+=("$HOME/.grok/bin")

# Prefer Cursor's binary if a Grok update reinstalls `agent` earlier on PATH.
if [[ -x "$HOME/.local/bin/cursor-agent" ]]; then
  alias agent="$HOME/.local/bin/cursor-agent"
fi

# fpath is modified after the main compinit in .zshrc, so re-run it to pick
# up Grok's completions.
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C

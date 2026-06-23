#!/bin/bash

# bootstrap.sh - Setup script for a fresh macOS installation

set -e # Exit immediately if a command exits with a non-zero status

DRY_RUN=false

for arg in "$@"; do
  case "$arg" in
    -n|--dry-run)
      DRY_RUN=true
      ;;
    -h|--help)
      echo "Usage: $0 [--dry-run]"
      echo
      echo "  --dry-run, -n   Print commands without executing them"
      exit 0
      ;;
    *)
      echo "Error: Unknown option '$arg'"
      echo "Usage: $0 [--dry-run]"
      exit 1
      ;;
  esac
done

run() {
  if $DRY_RUN; then
    printf "[dry-run]"
    for arg in "$@"; do
      printf " %q" "$arg"
    done
    printf "\n"
  else
    "$@"
  fi
}

run_shell() {
  local cmd="$1"
  if $DRY_RUN; then
    echo "[dry-run] $cmd"
  else
    bash -lc "$cmd"
  fi
}

# Ensure we are in the dotfiles directory
cd "$(dirname "$0")"

echo "Starting bootstrap process..."

if $DRY_RUN; then
  echo "Running in dry-run mode. No changes will be made."
fi

# Check for macOS
if [[ "$(uname)" != "Darwin" ]]; then
  echo "Error: This script is intended for macOS only."
  exit 1
fi

# Install Homebrew
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  run_shell '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
else
  echo "Homebrew is already installed."
fi

BREW_BIN="$(command -v brew || true)"
if [[ -z "$BREW_BIN" && "$DRY_RUN" == "false" ]]; then
  echo "Error: Homebrew installation was not detected."
  exit 1
fi

if [[ -z "$BREW_BIN" ]]; then
  BREW_BIN="brew"
fi

# Add Homebrew to PATH for future sessions and current shell
BREW_SHELLENV_LINE="eval \"\$($BREW_BIN shellenv)\""
if ! grep -Fqx "$BREW_SHELLENV_LINE" "$HOME/.zprofile" 2>/dev/null; then
  if $DRY_RUN; then
    echo "[dry-run] append to $HOME/.zprofile: $BREW_SHELLENV_LINE"
  else
    echo "$BREW_SHELLENV_LINE" >> "$HOME/.zprofile"
  fi
fi
if command -v brew &> /dev/null; then
  eval "$($BREW_BIN shellenv)"
fi

# Install packages from Brewfile
echo "Installing Homebrew packages..."
run "$BREW_BIN" bundle --file=brew/Brewfile

# Stow configurations
echo "Stowing dotfiles..."

# Ensure these exist as real directories so stow links individual entries
# instead of folding the whole directory into a single symlink back to the repo.
# (~/.claude is owned by Claude Code at runtime; ~/.agents/skills holds a mix of
# stow-managed skills and externally-installed ones like basecamp.)
run mkdir -p "$HOME/.claude" "$HOME/.agents/skills"

# Stow 'stow' first to ensure .stow-global-ignore is applied
echo "Stowing stow..."
run stow -R -v -t "$HOME" stow

# Stow all other packages
echo "Stowing other packages..."
for dir in */; do
  package="${dir%/}" # Remove trailing slash
  
  # Skip the 'stow' package as it's already done
  if [[ "$package" == "stow" ]]; then
    continue
  fi
  
  echo "Stowing $package..."
  if ! run stow -R -v -t "$HOME" "$package"; then
    echo "WARNING: Failed to stow $package (see above). Skipping."
  fi
done

# Point Claude's skills dir at the shared agent skills dir. Stow can't fold this
# link itself (it would resolve back into the repo and miss externally-installed
# skills), so create it directly. Relative target resolves to ~/.agents/skills.
echo "Linking ~/.claude/skills -> ~/.agents/skills..."
if [ -e "$HOME/.claude/skills" ] && [ ! -L "$HOME/.claude/skills" ]; then
  echo "WARNING: $HOME/.claude/skills exists and is not a symlink; leaving it alone."
else
  run ln -sfn ../.agents/skills "$HOME/.claude/skills"
fi

# Set up zsh as default shell
echo "Setting up zsh..."
if command -v brew &> /dev/null; then
  BREW_PREFIX="$($BREW_BIN --prefix)"
elif [[ -d "/opt/homebrew" ]]; then
  BREW_PREFIX="/opt/homebrew"
else
  BREW_PREFIX="/usr/local"
fi
BREW_ZSH="$BREW_PREFIX/bin/zsh"

if ! grep -q "$BREW_ZSH" /etc/shells; then
  echo "Adding Homebrew zsh to allowed shells..."
  run_shell "echo '$BREW_ZSH' | sudo tee -a /etc/shells"
fi

if [ "$SHELL" != "$BREW_ZSH" ]; then
  echo "Changing default shell to Homebrew zsh..."
  run chsh -s "$BREW_ZSH"
fi

echo "Bootstrap complete! You may need to restart your terminal or log out/in for all changes to take effect."

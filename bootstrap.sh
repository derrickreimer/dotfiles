#!/bin/bash

# bootstrap.sh - Setup script for a fresh macOS installation

set -e # Exit immediately if a command exits with a non-zero status

# Ensure we are in the dotfiles directory
cd "$(dirname "$0")"

echo "Starting bootstrap process..."

# Check for macOS
if [[ "$(uname)" != "Darwin" ]]; then
  echo "Error: This script is intended for macOS only."
  exit 1
fi

# Install Homebrew
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew is already installed."
fi

BREW_BIN="$(command -v brew || true)"
if [[ -z "$BREW_BIN" ]]; then
  echo "Error: Homebrew installation was not detected."
  exit 1
fi

# Add Homebrew to PATH for future sessions and current shell
BREW_SHELLENV_LINE="eval \"\$($BREW_BIN shellenv)\""
if ! grep -Fqx "$BREW_SHELLENV_LINE" "$HOME/.zprofile" 2>/dev/null; then
  echo "$BREW_SHELLENV_LINE" >> "$HOME/.zprofile"
fi
eval "$($BREW_BIN shellenv)"

# Install packages from Brewfile
echo "Installing Homebrew packages..."
brew bundle --file=brew/Brewfile

# Stow configurations
echo "Stowing dotfiles..."

# Stow 'stow' first to ensure .stow-global-ignore is applied
echo "Stowing stow..."
stow -R -v -t "$HOME" stow

# Stow all other packages
echo "Stowing other packages..."
for dir in */; do
  package="${dir%/}" # Remove trailing slash
  
  # Skip the 'stow' package as it's already done
  if [[ "$package" == "stow" ]]; then
    continue
  fi
  
  echo "Stowing $package..."
  stow -R -v -t "$HOME" "$package"
done

# Set up zsh as default shell
echo "Setting up zsh..."
BREW_ZSH="$($BREW_BIN --prefix)/bin/zsh"

if ! grep -q "$BREW_ZSH" /etc/shells; then
  echo "Adding Homebrew zsh to allowed shells..."
  echo "$BREW_ZSH" | sudo tee -a /etc/shells
fi

if [ "$SHELL" != "$BREW_ZSH" ]; then
  echo "Changing default shell to Homebrew zsh..."
  chsh -s "$BREW_ZSH"
fi

echo "Bootstrap complete! You may need to restart your terminal or log out/in for all changes to take effect."

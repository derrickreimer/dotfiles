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
  
  # Add Homebrew to PATH for the current session
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Homebrew is already installed."
fi

# Install packages from Brewfile
echo "Installing Homebrew packages..."
brew bundle --file=brew/Brewfile

# Stow configurations
echo "Stowing dotfiles..."
STOW_PACKAGES=(
  brew
  claude
  codex
  counselors
  gemini
  ghostty
  git
  kitty
  mise
  nvim
  opencode
  sprites
  starship
  stow
  tmux
  vscode
  zsh
)

for package in "${STOW_PACKAGES[@]}"; do
  echo "Stowing $package..."
  stow -R -v -t "$HOME" "$package"
done

# Set up zsh as default shell
echo "Setting up zsh..."
BREW_ZSH="$(brew --prefix)/bin/zsh"

if ! grep -q "$BREW_ZSH" /etc/shells; then
  echo "Adding Homebrew zsh to allowed shells..."
  echo "$BREW_ZSH" | sudo tee -a /etc/shells
fi

if [ "$SHELL" != "$BREW_ZSH" ]; then
  echo "Changing default shell to Homebrew zsh..."
  chsh -s "$BREW_ZSH"
fi

echo "Bootstrap complete! You may need to restart your terminal or log out/in for all changes to take effect."

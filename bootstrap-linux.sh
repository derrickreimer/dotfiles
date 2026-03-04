#!/bin/bash

# bootstrap-linux.sh - Setup script for a fresh Linux (Debian/Ubuntu) installation
# Intended for cloud development environments

set -e

echo "Starting bootstrap process for Linux..."

# Ensure we are in the dotfiles directory
cd "$(dirname "$0")"

# Update and install base dependencies
echo "Updating apt and installing base dependencies..."
sudo apt-get update
sudo apt-get install -y \
  build-essential \
  curl \
  git \
  stow \
  zsh \
  tmux \
  unzip \
  tar \
  ripgrep \
  fd-find \
  fzf \
  libssl-dev \
  zlib1g-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  wget \
  llvm \
  libncurses5-dev \
  libncursesw5-dev \
  xz-utils \
  tk-dev \
  libffi-dev \
  liblzma-dev \
  python3-openssl

# Fix fd binary name (Ubuntu installs as fdfind)
if ! command -v fd &> /dev/null; then
  echo "Symlinking fdfind to fd..."
  mkdir -p ~/.local/bin
  ln -s $(which fdfind) ~/.local/bin/fd
  export PATH="$HOME/.local/bin:$PATH"
fi

# Install mise (Version Manager)
if ! command -v mise &> /dev/null; then
  echo "Installing mise..."
  curl https://mise.run | sh
  export PATH="$HOME/.local/bin:$PATH"
  eval "$(mise activate bash)"
else
  echo "mise is already installed."
fi

# Install Starship (Prompt)
if ! command -v starship &> /dev/null; then
  echo "Installing starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
else
  echo "starship is already installed."
fi

# Install Neovim (Latest Stable from GitHub)
if ! command -v nvim &> /dev/null; then
  echo "Installing Neovim (latest stable)..."
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux64.tar.gz
  rm nvim-linux64.tar.gz
  
  # Add to PATH (symlink to /usr/local/bin)
  sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
else
  echo "Neovim is already installed."
fi

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
  
  # Skip macOS-specific packages (optional, but good practice)
  if [[ "$package" == "brew" || "$package" == "rectangle" ]]; then
      continue
  fi

  echo "Stowing $package..."
  stow -R -v -t "$HOME" "$package"
done

# Set up zsh as default shell
echo "Setting up zsh..."
ZSH_PATH=$(which zsh)

if [ "$SHELL" != "$ZSH_PATH" ]; then
  echo "Changing default shell to zsh..."
  sudo chsh -s "$ZSH_PATH" "$USER"
fi

# Run mise install to set up tools (Node, etc.)
if command -v mise &> /dev/null; then
    echo "Running mise install..."
    mise install
fi

echo "Bootstrap complete! Please restart your shell or log out/in."

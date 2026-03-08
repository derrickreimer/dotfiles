#!/bin/bash

# bootstrap-linux.sh - Setup script for a fresh Linux (Debian/Ubuntu) installation
# Intended for cloud development environments

set -e

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

echo "Starting bootstrap process for Linux..."

if $DRY_RUN; then
  echo "Running in dry-run mode. No changes will be made."
fi

# Ensure we are in the dotfiles directory
cd "$(dirname "$0")"

# Check for Linux + apt
if [[ "$(uname)" != "Linux" ]]; then
  echo "Error: This script is intended for Linux only."
  exit 1
fi

if ! command -v apt-get &> /dev/null; then
  echo "Error: This script currently supports Debian/Ubuntu systems (apt-get)."
  exit 1
fi

# Update and install base dependencies
echo "Updating apt and installing base dependencies..."
run sudo apt-get update
run sudo apt-get install -y \
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
  FDFIND_BIN="$(command -v fdfind || true)"
  if [[ -z "$FDFIND_BIN" && "$DRY_RUN" == "false" ]]; then
    echo "Error: fdfind was not found after package installation."
    exit 1
  fi
  if [[ -z "$FDFIND_BIN" ]]; then
    FDFIND_BIN="/usr/bin/fdfind"
  fi
  run mkdir -p ~/.local/bin
  run ln -sf "$FDFIND_BIN" ~/.local/bin/fd
  export PATH="$HOME/.local/bin:$PATH"
fi

# Install mise (Version Manager)
if ! command -v mise &> /dev/null; then
  echo "Installing mise..."
  run_shell "curl https://mise.run | sh"
  export PATH="$HOME/.local/bin:$PATH"
  if command -v mise &> /dev/null; then
    eval "$(mise activate bash)"
  fi
else
  echo "mise is already installed."
fi

# Install Starship (Prompt)
if ! command -v starship &> /dev/null; then
  echo "Installing starship..."
  run_shell "curl -sS https://starship.rs/install.sh | sh -s -- -y"
else
  echo "starship is already installed."
fi

# Install Neovim (Latest Stable from GitHub)
if ! command -v nvim &> /dev/null; then
  echo "Installing Neovim (latest stable)..."
  run curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  run sudo rm -rf /opt/nvim /opt/nvim-linux-x86_64
  run sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
  run rm nvim-linux-x86_64.tar.gz

  # Add to PATH (symlink to /usr/local/bin)
  run sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
else
  echo "Neovim is already installed."
fi

# Stow configurations
echo "Stowing dotfiles..."

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
  
  # Skip macOS-specific package
  if [[ "$package" == "brew" ]]; then
      continue
  fi

  echo "Stowing $package..."
  run stow -R -v -t "$HOME" "$package"
done

# Set up zsh as default shell
echo "Setting up zsh..."
ZSH_PATH=$(which zsh)

if [ "$SHELL" != "$ZSH_PATH" ]; then
  echo "Changing default shell to zsh..."
  run sudo chsh -s "$ZSH_PATH" "$USER"
fi

# Run mise install to set up tools (Node, etc.)
if command -v mise &> /dev/null; then
    echo "Running mise install..."
    run mise install
fi

echo "Bootstrap complete! Please restart your shell or log out/in."

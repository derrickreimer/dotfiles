# dotfiles

These are Derrick Reimer's dotfiles. I'm using `stow` to manage symlinking.

## Prerequisites

- macOS
- [Homebrew](https://brew.sh/)

## Installation

Clone this repository to your home directory:

```bash
git clone https://github.com/derrickreimer/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Install Homebrew packages (including `stow`):

```bash
brew bundle --file=brew/Brewfile
```

Symlink configurations with stow:

```bash
# Symlink all packages
stow brew claude ghostty git kitty mise nvim starship tmux zsh

# Or symlink individual packages
stow zsh
stow nvim
```

Set up zsh as the default shell:

```bash
# Add Homebrew zsh to allowed shells
echo "$(brew --prefix)/bin/zsh" | sudo tee -a /etc/shells

# Change default shell
chsh -s "$(brew --prefix)/bin/zsh"
```

## Structure

Each directory is a stow package that maps to `$HOME`:

| Package    | Description                                     |
|------------|-------------------------------------------------|
| `brew`     | Homebrew Brewfile for packages and casks        |
| `claude`   | Claude Code settings                            |
| `ghostty`  | Ghostty terminal config (TokyoNight theme)      |
| `git`      | Global gitignore                                |
| `kitty`    | Kitty terminal config                           |
| `mise`     | mise runtime manager (Erlang, Elixir, Node.js)  |
| `nvim`     | Neovim config (based on Kickstart)              |
| `starship` | Starship prompt configuration                   |
| `tmux`     | tmux configuration with vim-style keybindings   |
| `zsh`      | Zsh configuration with modular setup            |

## Managing dotfiles

Add a new config to an existing package:

```bash
# Example: add a new zsh config file
mv ~/.config/zsh/newconfig.zsh ~/dotfiles/zsh/.config/zsh/
stow -R zsh
```

Create a new stow package:

```bash
mkdir -p ~/dotfiles/newpackage/.config/newpackage
mv ~/.config/newpackage/config ~/dotfiles/newpackage/.config/newpackage/
stow newpackage
```

Unstow a package (remove symlinks):

```bash
stow -D zsh
```

## Cheatsheets

- `neovim-cheatsheet.md` - Neovim keybindings reference
- `tmux-cheatsheet.md` - tmux keybindings reference (accessible via `prefix + ?` in tmux)

## Local overrides

Zsh supports local overrides that aren't tracked in git:

```bash
# Create local config for machine-specific settings
touch ~/.config/zsh/local.zsh
```

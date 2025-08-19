# dotfiles

My dotfiles, tracked in a bare git repository. No magic, no ceremony.

Technique borrowed from [Nicola Paolucci's blog post](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/).

## Installation

### Install Zsh and Oh My Zsh

The configuration files assume you have [Zsh installed](https://www.google.com/search?q=installing+zsh)
and [robbyrussell/oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh).

At the time of writing, Homebrew is a great way to install Zsh.

```sh
brew install zsh zsh-completions
chsh -s /bin/zsh
```

### Clone the repository into home directory

This repository contains a `.zshrc` file, which you will want to override the
default file created by Zsh. If you need to retain your existing `.zshrc` file,
move it to a different spot:

```sh
cd ~
mv .zshrc .zshrc.pre-dotfiles
```

Next, ensure that your `.dotfiles` directory will be ignored by Git (to eliminate
recursion issues) by adding to `.gitignore`:

```sh
touch .gitignore
echo ".dotfiles" >> .gitignore
```

Then, clone this repository into your home directory:

```sh
git clone --bare https://github.com/derrickreimer/dotfiles.git $HOME/.dotfiles
```

Checkout the content of the repository into `$HOME`:

```sh
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout
```

If there are conflicts with existing files, Git will let you know like this:

```
error: The following untracked working tree files would be overwritten by checkout:
    .gitconfig
Please move or remove them before you can switch branches.
Aborting
```

Be sure to back those up first before moving forward.

Restart your shell session to pick up all the new aliases and configurations.

### Finish setup

You'll want to tell Git to ignore untracked files when running `git status`,
since this repository will only manage certain hand-picked files in your
home directory:

```sh
dotfiles config --local status.showUntrackedFiles no
```

## Committing new changes

Suppose you just made a change to your `.zshrc` file and would like to commit it
to your dotfiles repo.

```sh
# See your proposed changes
dotfiles status

# Stage up your changes
dotfiles add .zshrc

# Commit it
dotfiles commit -m "Message goes here"

# Push it up
dotfiles push
```

You'll want to avoid running an "add all" command (like `dotfiles add .` or `dotfiles add -A`)
since only some of the files in the home directory are tracked by Git.

## Miscellanea

### Managing Homebrew dependencies

Once directory is under git management, run the bootstrap script to
perform additional environment setup (tap Homebrew bundle, install Zsh, etc.):

```sh
script/bootstrap
```

To install new Homebrew packages, add to the `Brewfile`, run `brew bundle`,
and commit your changes.

## Starting from scratch

To bring your existing home directory under version control, initialize a bare
git repository there and define an alias to help with managing it:

```sh
git init --bare $HOME/.dotfiles
alias dotfiles='/usr/local/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
```

Be sure to add the alias to `.zshrc`, either manually or like this:

```sh
echo "alias dotfiles='/usr/local/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.zshrc
```

Now, you can run ordinary git commands in your home directory using your newly
created `dotfiles` alias:

```sh
dotfiles status
dotfiles add .zshrc
dotfiles commit -m "Add zshrc"
dotfiles push
```

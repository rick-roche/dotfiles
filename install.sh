#!/usr/bin/env bash

# Get current dir (so run this script from anywhere)

export DOTFILES_DIR DOTFILES_CACHE DOTFILES_EXTRA_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_CACHE="$DOTFILES_DIR/.cache.sh"
echo "DOT FILES DIR = $DOTFILES_DIR"
 DOTFILES_EXTRA_DIR="$HOME/.extra"

# Make utilities available

PATH="$DOTFILES_DIR/bin:$PATH"

# Update dotfiles itself first

if is-executable git -a -d "$DOTFILES_DIR/.git"; then git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master; fi

# Bunch of symlinks
echo "SYMLINKS TIME"

ln -sfv "$DOTFILES_DIR/runcom/.bash_profile" ~
ln -sfv "$DOTFILES_DIR/runcom/.inputrc" ~
ln -sfv "$DOTFILES_DIR/git/.gitconfig" ~
ln -sfv "$DOTFILES_DIR/git/.gitignore_global" ~
ln -sfv "$DOTFILES_DIR/config/.editorconfig" ~
ln -sfv "$DOTFILES_DIR/bin/connect_to_machines" /usr/bin/
ln -sfv "$DOTFILES_DIR/bin/.npmrc" ~

# Package managers & packages
echo "PAckagage Managers"

. "$DOTFILES_DIR/install/brew.sh"
. "$DOTFILES_DIR/install/npm.sh"
. "$DOTFILES_DIR/install/bash.sh"
. "$DOTFILES_DIR/install/brew-cask.sh"
. "$DOTFILES_DIR/install/mas.sh"


# Run tests

 if is-executable bats; then bats test/*.bats; else echo "Skipped: tests (missing: bats)"; fi

# Install extra stuff

 if [ -d "$DOTFILES_EXTRA_DIR" -a -f "$DOTFILES_EXTRA_DIR/install.sh" ]; then
   . "$DOTFILES_EXTRA_DIR/install.sh"
 fi

# setup a few directories
mkdir -p ~/git/apps/
mkdir -p ~/git/components
mkdir -p ~/git/monorepos
mkdir -p ~/git/utils
mkdir -p ~/git/apis
mkdir -p ~/git/personal

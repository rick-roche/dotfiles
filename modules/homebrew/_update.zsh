#!/bin/zsh
# shellcheck shell=bash

# shellcheck source=/dev/null
. "$DOTFILES_HOME/bin/_bootstrap.zsh"

brew update
brew upgrade
brew upgrade --cask
brew cleanup

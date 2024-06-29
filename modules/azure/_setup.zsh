#!/bin/zsh

DIR=$(dirname "$0")
. $DOTFILES_HOME/bin/_bootstrap.zsh

module_brew_bundle $(basename $DIR)

# Install bicep
logging_info "Installing bicep..."
az bicep install

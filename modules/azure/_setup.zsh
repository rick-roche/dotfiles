#!/bin/zsh
# shellcheck shell=bash

DIR=$(dirname "$0")
# shellcheck source=/dev/null
. "$DOTFILES_HOME/bin/_bootstrap.zsh"

module_brew_bundle "$(basename "$DIR")"

# Install bicep
logging_info "Installing bicep..."
az bicep install

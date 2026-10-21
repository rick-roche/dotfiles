#!/bin/zsh
# shellcheck shell=bash

DIR=${DOTFILES_MODULE_DIR:-${0:A:h}}
# shellcheck source=/dev/null
. "$DOTFILES_HOME/bin/_bootstrap.zsh"

module_brew_bundle "$(basename "$DIR")"

# Install bicep
logging_info "Installing bicep..."
az bicep install

#!/bin/zsh
# shellcheck shell=bash

################################################################################
# Function: brew_bundle
#
# Install and upgrade (by default) all dependencies from the Brewfile referenced
#
# Arguments:
#   $1 - fully qualified path to the Brewfile bundle
# Return:
# 	0 if success, non-zero otherwise.
################################################################################
brew_bundle() {
    local path_to_bundle=$1
    logging_info "Bundle $path_to_bundle"
    brew bundle --file="$path_to_bundle"
}

################################################################################
# Function: module_brew_bundle
#
# Run brew bundle for a specific modules Brewfile. This is a useful helper.
#
# Arguments:
#   $1 - name of the module. e.g. base-cli
# Return:
# 	0 if success, non-zero otherwise.
################################################################################
module_brew_bundle() {
    # shellcheck source=/dev/null
    . "$DOTFILES_HOME/bin/_bootstrap.zsh"

    local module="$1"
    bundle_file_name="$DOTFILES_HOME/modules/$module/Brewfile"
    brew_bundle "$bundle_file_name"
}

################################################################################
# Function: timezsh
#
# Measure the startup time of zsh
# Borrowed from https://blog.mattclemente.com/2020/06/26/oh-my-zsh-slow-to-load/
#
# Arguments:
#   $1 - path to the zsh binary (optional, defaults to $SHELL)
# Return:
# 	0 if success, non-zero otherwise.
################################################################################
timezsh() {
  shell=${1-$SHELL}
  for _ in $(seq 1 10); do /usr/bin/time "$shell" -i -c exit; done
}
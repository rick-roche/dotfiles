#!/bin/zsh
# shellcheck shell=bash

DIR=$(dirname "$0")
# shellcheck source=/dev/null
. "$DOTFILES_HOME/bin/_bootstrap.zsh"

# shellcheck disable=SC1091
. "$DIR/defaults.zsh"
# shellcheck disable=SC1091
. "$DIR/dock.zsh"

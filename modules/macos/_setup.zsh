#!/bin/zsh
# shellcheck shell=bash

DIR=$(dirname "$0")
# shellcheck source=/dev/null
. "$DOTFILES_HOME/bin/_bootstrap.zsh"

. $DIR/defaults.zsh
. $DIR/dock.zsh

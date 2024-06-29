#!/bin/zsh
# shellcheck shell=bash

# shellcheck source=/dev/null
. "$DOTFILES_HOME/bin/_bootstrap.zsh"

az bicep upgrade

#!/bin/zsh
# shellcheck shell=bash

# shellcheck source=/dev/null
. "$DOTFILES_HOME/bin/_bootstrap.zsh"

if $($DOTFILES_HOME/bin/is-executable brew); then
    brew update
    brew upgrade
else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Temporarily setup the path to allow the setup to continue
    if [[ "$(uname -p)" -eq "arm" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

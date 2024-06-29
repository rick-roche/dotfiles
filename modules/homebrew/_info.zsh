#!/bin/zsh
# shellcheck shell=bash

# shellcheck source=/dev/null
. "$DOTFILES_HOME/bin/_bootstrap.zsh"

if "$DOTFILES_HOME"/bin/is-executable brew; then
    if [[ "$(uname -p)" == "arm" ]]; then
        echo "homebrew:     ARM hardware"
    else
        echo "homebrew:     Intel hardware"
    fi
else
    echo "homebrew:     Not installed"
fi

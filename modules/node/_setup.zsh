#!/bin/zsh
# shellcheck shell=bash

DIR=$(dirname "$0")
# shellcheck source=/dev/null
. "$DOTFILES_HOME/bin/_bootstrap.zsh"

NVM_DIR=$HOME/.nvm

if ! [ -d "$NVM_DIR"/.git ]; then
    git clone https://github.com/creationix/nvm.git "$NVM_DIR"
fi

# shellcheck source=/dev/null
. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm install node
nvm use node

npm install -g "$(cat "$DIR/npmfile")"

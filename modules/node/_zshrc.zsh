#!/bin/zsh
# shellcheck shell=bash

NVM_DIR=~/.nvm

if [ -f "$NVM_DIR/nvm.sh" ]; then
    export NVM_DIR
    # shellcheck source=/dev/null
    . "$NVM_DIR/nvm.sh"
fi

#!/bin/zsh
# shellcheck shell=bash

# shellcheck disable=SC2155
export GPG_TTY=$(tty)
# only launch once
if [ -z "$(pgrep gpg-agent)" ]; then
    gpgconf --launch gpg-agent
fi

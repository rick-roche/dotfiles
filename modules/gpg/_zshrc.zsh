#!/bin/zsh
# shellcheck shell=bash

# shellcheck disable=SC2155
export GPG_TTY=$(tty)
gpgconf --launch gpg-agent

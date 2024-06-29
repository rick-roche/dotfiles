#!/bin/zsh
# shellcheck shell=bash

if [[ "$(uname -p)" == "arm" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

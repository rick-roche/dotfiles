#!/bin/zsh
# shellcheck shell=bash

export PATH="$HOME"/.dotnet:$PATH
export PATH="$HOME"/.dotnet/tools:$PATH
# shellcheck disable=SC2155
export DOTNET_ROOT="$(dirname "$(which dotnet)")"

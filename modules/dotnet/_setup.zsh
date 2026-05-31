#!/bin/zsh
# shellcheck shell=bash

DIR=$(dirname "$0")
# shellcheck source=/dev/null
. "$DOTFILES_HOME/bin/_bootstrap.zsh"

module_brew_bundle "$(basename "$DIR")"

tools=('dotnet-aspnet-codegenerator' 'dotnet-outdated-tool' 'security-scan')

for t in "${tools[@]}"; do
    dotnet tool update --global "$t"
done

dotnet dev-certs https --trust

dotnet --list-sdks

sudo dotnet workload update
sudo dotnet workload install aspire

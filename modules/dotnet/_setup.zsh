#!/bin/zsh

DIR=$(dirname "$0")
. $DOTFILES_HOME/bin/_bootstrap.zsh

module_brew_bundle $(basename $DIR)

tools=('dotnet-outdated-tool' 'security-scan')

for t in "${tools[@]}"; do
    dotnet tool update --global "$t"
done

dotnet --list-sdks

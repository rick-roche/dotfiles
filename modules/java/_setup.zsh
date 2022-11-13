#!/bin/zsh

DIR=$(dirname "$0")
. $DOTFILES_HOME/bin/_bootstrap.zsh

module_brew_bundle $(basename $DIR)

# install sdkman
curl -s "https://get.sdkman.io" | bash
rm -rf "$HOME/.bash_profile"
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java
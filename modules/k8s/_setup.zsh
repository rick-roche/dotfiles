#!/bin/zsh

DIR=$(dirname "$0")
. $DOTFILES_HOME/bin/_bootstrap.zsh

module_brew_bundle $(basename $DIR)

mkdir -p ~/.kube

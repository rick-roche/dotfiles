#!/bin/zsh

DIR=$(dirname "$0")
. $DOTFILES_HOME/bin/_bootstrap.zsh

logging_info "Bundle $DIR/Brewfile"
brew bundle --file=$DIR/Brewfile

mkdir -p ~/.kube

#!/bin/zsh
# Ref: https://gist.github.com/troyfontaine/18c9146295168ee9ca2b30c00bd1b41e

DIR=$(dirname "$0")
. $DOTFILES_HOME/bin/_bootstrap.zsh

module_brew_bundle $(basename $DIR)

# Link the config
mkdir -p $HOME/.gnupg/
ln -s -f $DIR/gpg.conf $HOME/.gnupg/gpg.conf
ln -s -f $DIR/gpg-agent.conf $HOME/.gnupg/gpg-agent.conf
chmod 700 ~/.gnupg

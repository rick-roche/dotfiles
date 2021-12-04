#!/bin/zsh

DIR=$(dirname "$0")
. $DOTFILES_HOME/bin/_bootstrap.zsh

logging_info "Bundle $DIR/Brewfile"
brew bundle --file=$DIR/Brewfile

# Link the config
mkdir -p $HOME/.gnupg/
ln -s -f $DIR/gpg.conf $HOME/.gnupg/gpg.conf
ln -s -f $DIR/gpg-agent.conf $HOME/.gnupg/gpg-agent.conf
chmod 700 ~/.gnupg
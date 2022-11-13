#!/bin/zsh

DIR=$(dirname "$0")
. $DOTFILES_HOME/bin/_bootstrap.zsh

NVM_DIR=$HOME/.nvm

if ! [ -d $NVM_DIR/.git ]; then
    git clone https://github.com/creationix/nvm.git $NVM_DIR;
fi

. $NVM_DIR/nvm.sh; nvm install --lts
. $NVM_DIR/nvm.sh; nvm install node
. $NVM_DIR/nvm.sh; nvm use node

. $NVM_DIR/nvm.sh; npm install -g $(cat $DIR/npmfile)

#!/bin/zsh

DIR=$(dirname "$0")
. $DOTFILES_HOME/bin/_bootstrap.zsh

NVM_DIR=$HOME/.nvm

if ! [ -d $NVM_DIR/.git ]; then
    git clone https://github.com/creationix/nvm.git $NVM_DIR
fi

. $NVM_DIR/nvm.sh
nvm install --lts
nvm install node
nvm use node

npm install -g $(cat $DIR/npmfile)

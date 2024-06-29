#!/bin/zsh

DIR=$(dirname "$0")
. $DOTFILES_HOME/bin/_bootstrap.zsh

mkdir -p $DOTFILES_HOME/modules/git/git

sed "s/EMAILADDRESS/$EMAIL_ADDRESS/g" $DIR/config.template >$DIR/git/config
sed -i "s/GPGKEY/$GPG_KEY/g" $DIR/git/config
cp $DIR/ignore $DIR/git/ignore

# Link the config
mkdir -p $XDG_CONFIG_HOME
ln -s -f $DIR/git $XDG_CONFIG_HOME

module_brew_bundle $(basename $DIR)

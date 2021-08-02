#!/bin/zsh

. $DOTFILES_HOME/bin/_bootstrap.zsh
DIR=$(dirname "$0")

# Install oh-my-zsh
if [ -d "$ZSH" ]; then
    $ZSH/tools/upgrade.sh
else
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install fonts
curl -o "$HOME/Library/Fonts/MesloLGS NF Regular.ttf" -fsSL https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
curl -o "$HOME/Library/Fonts/MesloLGS NF Bold.ttf" -fsSL https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
curl -o "$HOME/Library/Fonts/MesloLGS NF Italic.ttf" -fsSL https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
curl -o "$HOME/Library/Fonts/MesloLGS NF Bold Italic.ttf" -fsSL https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

# Link 
rm -rf ~/.zshrc ~/.zprofile
stow -R -d $DIR -t $HOME runcom
# ln -s -f $DOTFILES_HOME/modules/zsh/.zshrc ~/.zshrc


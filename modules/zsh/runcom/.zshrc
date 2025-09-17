if [ -n "${ZSH_PROFILE:+x}" ]
then
    zmodload zsh/zprof
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

# lazy loads nvm - for when you need it, not every time
zstyle ':omz:plugins:nvm' lazy yes
plugins=(git nvm)

source $ZSH/oh-my-zsh.sh

# Load modules
export DOTFILES_VERBOSE=0
. ~/.dotfiles/bin/_bootstrap.zsh
export PATH=$PATH:$DOTFILES_HOME/bin

for module in $DOTFILES_MODULES; do
    EXEC_FILE_NAME="$DOTFILES_HOME/modules/$module/_zshrc.zsh"

    if [[ -e "$EXEC_FILE_NAME" ]]; then
        . $EXEC_FILE_NAME
    fi
done

# When using https://starship.rs/ - see modules/zsh
eval "$(starship init zsh)"

if [ -n "${ZSH_PROFILE:+x}" ]
then
    zprof
fi
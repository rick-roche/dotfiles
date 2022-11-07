. ~/.dotfiles/bin/_bootstrap.zsh

for module in $DOTFILES_MODULES; do
    EXEC_FILE_NAME="$DOTFILES_HOME/modules/$module/_zprofile.zsh"

    if [[ -e "$EXEC_FILE_NAME" ]]; then
        . $EXEC_FILE_NAME
    fi
done
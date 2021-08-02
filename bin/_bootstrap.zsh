export DOTFILES_HOME=$HOME/.dotfiles
export XDG_CONFIG_HOME="$HOME/.config"
export DEFAULT_PERSONALITY=base

function logging_info() {
    if [[ "$DOTFILES_VERBOSE" -eq "1" ]]; then
        echo "Info: $*"
    fi
}

function logging_status() {
    echo "Status: $*"
}

function logging_error() {
    echo "Error: $*"
    exit 1
}

DOTFILE_SETTINGS_FILE_NAME="$DOTFILES_HOME/settings/_$(uname -n)-setup.zsh"
if [[ ! -r "$DOTFILE_SETTINGS_FILE_NAME" ]]; then
    logging_info "Not found: $DOTFILE_SETTINGS_FILE_NAME"

    DOTFILE_SETTINGS_FILE_NAME="$DOTFILES_HOME/settings/_${DEFAULT_PERSONALITY}-setup.zsh"

    if [[ ! -r "$DOTFILE_SETTINGS_FILE_NAME" ]]; then
        logging_error "Not found: $DOTFILE_SETTINGS_FILE_NAME"
    fi
fi

logging_info "Using: $DOTFILE_SETTINGS_FILE_NAME"
. $DOTFILE_SETTINGS_FILE_NAME

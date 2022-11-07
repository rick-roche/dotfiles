export DOTFILES_HOME=$HOME/.dotfiles
export XDG_CONFIG_HOME="$HOME/.config"
export DEFAULT_PERSONALITY=base

function logging_debug() {
    if [[ "$DOTFILES_VERBOSE" -eq "2" ]]; then
        echo "Debug: $*"
    fi
}

function logging_info() {
    if [[ "$DOTFILES_VERBOSE" -eq "1" || "$DOTFILES_VERBOSE" -eq "2" ]]; then
        echo "${DOTFILES_GREEN}Info:${DOTFILES_NOCOLOUR} $*"
    fi
}

function logging_status() {
    echo "${DOTFILES_GREEN}Status:${DOTFILES_NOCOLOUR} $*"
}

function logging_error() {
    echo "${DOTFILES_RED}Error:${DOTFILES_NOCOLOUR} $*"
    exit 1
}

DOTFILES_SETTINGS_FILE_NAME="$DOTFILES_HOME/settings/_$(uname -n)-setup.zsh"
DOTFILES_SETTINGS_MODE="custom"
if [[ ! -r "$DOTFILES_SETTINGS_FILE_NAME" ]]; then
    logging_debug "Not found: $DOTFILES_SETTINGS_FILE_NAME"

    DOTFILES_SETTINGS_FILE_NAME="$DOTFILES_HOME/settings/_${DEFAULT_PERSONALITY}-setup.zsh"
    DOTFILES_SETTINGS_MODE="custom"

    if [[ ! -r "$DOTFILES_SETTINGS_FILE_NAME" ]]; then
        logging_debug "Not found: $DOTFILES_SETTINGS_FILE_NAME"
        DOTFILES_SETTINGS_MODE="none"
    fi
fi

logging_info "Using: $DOTFILES_SETTINGS_FILE_NAME"
. $DOTFILES_SETTINGS_FILE_NAME

function dotfiles_verify_settings() {
    if [[ "$DOTFILES_SETTINGS_MODE" != "custom" ]]
    then
        logging_error "General settings used - create a custom file for this machine: $DOTFILES_HOME/settings/_$(uname -n).zsh"
        exit 1
    fi
}

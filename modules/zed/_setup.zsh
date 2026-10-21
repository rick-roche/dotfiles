#!/bin/zsh
# shellcheck shell=bash

# shellcheck source=/dev/null
. "$DOTFILES_HOME/bin/_bootstrap.zsh"
DIR=$(dirname "$0")

module_brew_bundle zed

mkdir -p "$XDG_CONFIG_HOME/zed"

for _zed_config in settings.json keymap.json; do
    _zed_source="$DIR/config/zed/$_zed_config"
    _zed_target="$XDG_CONFIG_HOME/zed/$_zed_config"

    if [[ -L "$_zed_target" && "$(readlink "$_zed_target")" == "$_zed_source" ]]; then
        continue
    fi

    if [[ -e "$_zed_target" || -L "$_zed_target" ]]; then
        logging_error "Refusing to replace existing Zed config: $_zed_target (move it aside, then rerun setup)"
    fi

    ln -s "$_zed_source" "$_zed_target"
done

logging_status "Zed config linked"

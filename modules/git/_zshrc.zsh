#!/bin/zsh
# shellcheck shell=bash

alias gitclean="git fetch --prune && git for-each-ref --format '%(refname:short) %(upstream:track)' | grep '\[gone\]' | sed 's/\s.*$//' | xargs git branch -D"

function clone_repo() {
    local url=$1
    local dest=$2

    echo "Cloning to $dest..."

    mkdir -p "$dest"
    # shellcheck disable=SC2164
    cd "$dest"
    git clone "$url"
    # shellcheck disable=SC2164
    # shellcheck disable=SC2103
    cd -
}

# Clones a repo using an opinionated convention and changes directory to the cloned repo

# - Clones to $CODE_DEST/{project_path}
#   e.g. easy_clone https://github.com/Azure/azure-quickstart-templates.git
#           would clone to $CODE_DEST/github.com/Azure/azure-quickstart-templates
#
function easy_clone() {
    local url=$1

    # shellcheck disable=SC2155
    local project_path=$(echo "$url" | sed -n 's#https://\(.*\)/.*#\1#p')
    local dest="$CODE_DEST/$project_path"

    clone_repo "$url" "$dest"

    # shellcheck disable=SC2155
    local repo_name=$(basename "$url")
    # shellcheck disable=SC2164
    cd "$dest/${repo_name%.*}"
}

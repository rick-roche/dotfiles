#!/bin/zsh
# shellcheck shell=bash

function setupKubeConfigs() {
    # shellcheck disable=SC2012
    if [[ $(ls ~/.kube/configs | wc -l) != 0 ]]; then
        export KUBECONFIG="$HOME/.kube/config:$KUBECONFIG"

        # shellcheck disable=SC2045
        for f in $(ls ~/.kube/configs/); do
            export KUBECONFIG="$HOME/.kube/configs/$f:$KUBECONFIG"
        done

        # shellcheck disable=SC2155
        # shellcheck disable=SC2001
        export KUBECONFIG=$(echo "$KUBECONFIG" | sed 's/:$//')
    fi
}

# shellcheck disable=SC2015
[[ -d $HOME/.kube/configs ]] && setupKubeConfigs || (mkdir "$HOME/.kube/configs")

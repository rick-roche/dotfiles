[[ -f $HOME/.kube/config ]] && \
    [[ $(grep minikube $HOME/.kube/config | wc -l ) != 0 ]]

function initConfigVar () {
    if [[ $(ls ~/.kube/config | grep kubeconfig | wc -l) != 0 ]]; then
        for f in $(ls ~/.kube/config/ | grep kubeconfig); do
            export KUBECONFIG="$HOME/.kube/config/$f:$KUBECONFIG";
        done

        export KUBECONFIG=$(echo $KUBECONFIG | sed 's/:$//')
    fi

    # kubectl config get-contexts
}

[[ -d $HOME/.kube/config ]] && initConfigVar || \
    ( mkdir $HOME/.kube/config && \
    echo "No config directory. Put kubeconfigs in $HOME/.kube/config/ and source this profile to load.")

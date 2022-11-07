function setupKubeConfigs () {
    if [[ $(ls ~/.kube/configs | wc -l) != 0 ]]; then
        export KUBECONFIG="$HOME/.kube/config:$KUBECONFIG";

        for f in $(ls ~/.kube/configs/); do
            export KUBECONFIG="$HOME/.kube/configs/$f:$KUBECONFIG";
        done

        export KUBECONFIG=$(echo $KUBECONFIG | sed 's/:$//')
    fi
}

[[ -d $HOME/.kube/configs ]] && setupKubeConfigs || ( mkdir $HOME/.kube/configs )

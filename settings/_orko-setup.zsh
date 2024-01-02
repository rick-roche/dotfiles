export DOTFILES_PERSONALITY=orko
export GPG_KEY=6DFF9D4160C0EE7FD656F0B7A54FEFD8636A433A

. $DOTFILES_HOME/settings/_base-setup.zsh

DOTFILES_MODULES+=(
    azure
    dev
    docker
    dotnet
    golang
    java
    node
    media
)

#if ! is-macos -o ! is-executable ruby -o ! is-executable curl -o ! is-executable git; then
#  echo "Skipped: Homebrew (missing: ruby, curl and/or git)"
#  return
#fi

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# brew tap Goles/battery
tapApps=(
  hashicorp/tap
)
echo "brew tap "${tapApps[@]}""
brew tap "${tapApps[@]}"


brew update
brew upgrade

# Install packages

apps=(
  minikube
  ansible
  bash-completion@2
  coreutils
  dockutil
  elixir
  fasd
  go
  grep 
  jq
  kubectl
  helm
  mackup
  mas
  postgresql
  psgrep
  shellcheck
  unar
  wget
  hashicorp/tap/terraform
)

echo "Installing ${apps[@]}"
brew install "${apps[@]}"

export DOTFILES_BREW_PREFIX_COREUTILS=`brew --prefix coreutils`
#set-config "DOTFILES_BREW_PREFIX_COREUTILS" "$DOTFILES_BREW_PREFIX_COREUTILS" "$DOTFILES_CACHE"

#ln -sfv "$DOTFILES_DIR/etc/mackup/.mackup.cfg" ~

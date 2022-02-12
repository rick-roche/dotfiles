#if ! is-macos -o ! is-executable ruby -o ! is-executable curl -o ! is-executable git; then
#  echo "Skipped: Homebrew (missing: ruby, curl and/or git)"
#  return
#fi

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# brew tap Goles/battery
brew update
brew upgrade

# Install packages

apps=(
  ansible
  bash-completion2
  coreutils
  dockutil
  elixir
  fasd
  go
  grep --with-default-names
  jq
  kubectl
  kubernetes-helm
  mackup
  mas
  postgresql
  psgrep
  shellcheck
  unar
  wget
)

brew install "${apps[@]}"

export DOTFILES_BREW_PREFIX_COREUTILS=`brew --prefix coreutils`
#set-config "DOTFILES_BREW_PREFIX_COREUTILS" "$DOTFILES_BREW_PREFIX_COREUTILS" "$DOTFILES_CACHE"

#ln -sfv "$DOTFILES_DIR/etc/mackup/.mackup.cfg" ~

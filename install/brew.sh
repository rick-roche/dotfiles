#if ! is-macos -o ! is-executable ruby -o ! is-executable curl -o ! is-executable git; then
#  echo "Skipped: Homebrew (missing: ruby, curl and/or git)"
#  return
#fi

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# brew tap Goles/battery
brew tap derailed/k9s
brew tap derailed/popeye
brew update
brew upgrade

# Install packages

apps=(
  ansible
  awscli
  azure-cli
  bash
  bash-completion@2
  coreutils
  dockutil
  elixir
  erlang
  fasd
  fontconfig
  freetype
  gd
  gdbm
  gettext
  glib
  glide
  go
  graphviz
  grep --with-default-names
  gts
  helm@3
  highlight
  icu4c
  jasper
  jpeg
  jq
  k9s
  kube-ps1
  kube-score
  kubectx
  kubernetes-cli
  kubernetes-helm
  libffi
  libidn2
  libpng
  libtiff
  libtool
  libunistring
  libyaml
  lua
  mackup
  mas
  maven
  mc
  mercurial
  netpbm
  nvm
  oniguruma
  openssl
  pcre
  pkg-config
  popeye
  postgresql
  prometheus
  psgrep
  python
  python@2
  rancher-cli
  readline
  shellcheck
  sphinx-doc
  sqlite
  telnet
  terraform
  unar
  webp
  wget
  wxmac
  xz
  yq
)

brew install "${apps[@]}"

export DOTFILES_BREW_PREFIX_COREUTILS=`brew --prefix coreutils`
#set-config "DOTFILES_BREW_PREFIX_COREUTILS" "$DOTFILES_BREW_PREFIX_COREUTILS" "$DOTFILES_CACHE"

#ln -sfv "$DOTFILES_DIR/etc/mackup/.mackup.cfg" ~

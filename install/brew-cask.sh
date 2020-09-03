#if ! is-macos -o ! is-executable brew; then
#  echo "Skipped: Homebrew-Cask"
#  return
#fi

brew tap caskroom/versions
brew tap caskroom/cask
brew tap caskroom/fonts

# Install packages

apps=(
  adoptopenjdk
  dash2
  dbeaver-community
  gitkraken
  google-chrome
  google-chrome-canary
  iterm2
  minikube
  postman
  powershell
  qlcolorcode
  qlimagesize
  qlstephen
  qlvideo
  qlmarkdown
  quicklook-json
  spotify
  suspicious-package
  vagrant
  visual-studio-code
  vlc
  webpquicklook
)

brew cask install "${apps[@]}"

# Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlimagesize webpquicklook suspicious-package qlvideo

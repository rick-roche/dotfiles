#if ! is-macos -o ! is-executable brew; then
#  echo "Skipped: Homebrew-Cask"
#  return
#fi
echo "Installing cask applications"
brew tap homebrew/cask-versions 
brew tap homebrew/cask
brew tap homebrew/cask-fonts

# Install packages

apps=(
  dash2
  dbeaver-community
  gitkraken
  go2shell
  google-chrome
  google-chrome-canary
  iterm2
  postman
  spotify
  vagrant
  vlc
  parallels
  parallels-toolbox
  whatsapp
  intellij-idea
  cleanmymac3
)

brew install --cask "${apps[@]}"

# Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
brew install --cask qlcolorcode qlstephen qlmarkdown quicklook-json qlimagesize webpquicklook suspicious-package qlvideo

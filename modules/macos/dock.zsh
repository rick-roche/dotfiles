#!/bin/zsh

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/Microsoft Edge.app/"
dockutil --no-restart --add "/Applications/Visual Studio Code.app/"
dockutil --no-restart --add "/Applications/iTerm.app/"
dockutil --no-restart --add "/Applications/Bitwarden.app/"
dockutil --no-restart --add "/Applications/Spotify.app/"
dockutil --no-restart --add "/Applications/NetNewsWire.app/"

killall Dock

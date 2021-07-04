#!/bin/sh

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/Microsoft Edge.app/"
dockutil --no-restart --add "/Applications/Visual Studio Code.app/"
dockutil --no-restart --add "/Applications/Microsoft Teams.app/"
dockutil --no-restart --add "/Applications/Microsoft Outlook.app/"
dockutil --no-restart --add "/Applications/iTerm.app/"
dockutil --no-restart --add "/Applications/Miro.app/"
dockutil --no-restart --add "/Applications/Postman.app/"
dockutil --no-restart --add "/Applications/Bitwarden.app/"
dockutil --no-restart --add "/Applications/Spotify.app"

killall Dock

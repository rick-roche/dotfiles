#!/usr/bin/env bash

cp settings.json "$HOME/Library/Application Support/Code/User/settings.json"

# My settings are now saved to Github using this plugin
code --install-extension Shan.code-settings-sync

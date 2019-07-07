#!/bin/bash
DIR=$(dirname "$0")
LAUNCH_DIR=~/Library/LaunchAgents
cp "$DIR/local.kerberos.plist" "$LAUNCH_DIR"
launchctl unload "$LAUNCH_DIR/local.kerberos.plist"
launchctl load "$LAUNCH_DIR/local.kerberos.plist"

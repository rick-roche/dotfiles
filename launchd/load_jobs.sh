#!/bin/bash
DIR=$(dirname "$0")
LAUNCH_DIR=~/Library/LaunchAgents
cp "$DIR/local.kerberos.interval.plist" "$LAUNCH_DIR"
cp "$DIR/local.kerberos.login.plist" "$LAUNCH_DIR"
launchctl unload "$LAUNCH_DIR/local.kerberos.interval.plist"
launchctl load "$LAUNCH_DIR/local.kerberos.interval.plist"
launchctl unload "$LAUNCH_DIR/local.kerberos.login.plist"
launchctl load "$LAUNCH_DIR/local.kerberos.login.plist"

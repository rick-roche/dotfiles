#!/bin/zsh
# shellcheck shell=bash

gpg-agent --daemon
echo "hello world" | gpg --clearsign

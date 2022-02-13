#!/bin/zsh

gpg-agent --daemon
echo "hello world" | gpg --clearsign

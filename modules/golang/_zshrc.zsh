#!/bin/zsh
# shellcheck shell=bash

export GOPATH="$HOME"/go
# shellcheck disable=SC2155
export PATH=$PATH:$(go env GOPATH)/bin

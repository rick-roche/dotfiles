#!/bin/bash
DIR=$(dirname "$0")
PRINCIPLE="$1"

ktutil -k "$DIR/$USER.keytab" \
    add -p "$PRINCIPLE" -V 1 -e aes256-cts-hmac-sha1-96

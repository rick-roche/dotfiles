#!/bin/bash
DIR=$(dirname "$0")
KT="$DIR/$USER.keytab"
NAME=$(echo "$USER" | cut -d "." -f 1 | awk '{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) substr($i,2) }}1')
SURNAME=$(echo "$USER" | cut -d "." -f 2 | awk '{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) substr($i,2) }}1')
DOMAIN=$(awk '/domain/ {print $2}' /etc/resolv.conf)
PRINCIPLE="$NAME.$SURNAME@$DOMAIN"

kinit -kt "$KT" -V --keychain "$PRINCIPLE"

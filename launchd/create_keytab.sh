#!/bin/bash
DIR=$(dirname "$0")
ENC_TYPE=aes256-cts-hmac-sha1-96

if [ -z "$1" ]; then
    NAME=$(echo "$USER" | cut -d "." -f 1 | awk '{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) substr($i,2) }}1')
    SURNAME=$(echo "$USER" | cut -d "." -f 2 | awk '{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) substr($i,2) }}1')
    DOMAIN=$(awk '/domain/ {print $2}' /etc/resolv.conf)
    PRINCIPLE="$NAME.$SURNAME@$DOMAIN"
else
    PRINCIPLE=$1
fi

ktutil -k "$DIR/$USER.keytab" \
    add -p "$PRINCIPLE" -V 1 -e $ENC_TYPE

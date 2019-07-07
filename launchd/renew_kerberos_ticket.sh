#!/bin/bash
DIR=$(dirname "$0")
KT="$DIR/$USER.keytab"
kinit -kt "$KT" -V

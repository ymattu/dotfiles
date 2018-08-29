#!/bin/bash

# Load utils
. ./utils.sh

print_title "gdrive"

gdrivedir=$HOME/.gdrive

if [ -e $gdrivedir ]; then
    print_success "gdrive is already setupped."
else
    gdrive list
    print_success "gdrive was successfully setupped"
fi


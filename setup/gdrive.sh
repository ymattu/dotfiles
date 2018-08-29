#!/bin/bash

# dotfiles path
DOTFILES_PATH="$HOME/dotfiles"

# Load utils
. $DOTFILES_PATH/setup/utils.sh

print_title "gdrive"

gdrivedir=$HOME/.gdrive

if [ -e $gdrivedir ]; then
    print_warning "gdrive: already setupped."
else
    gdrive list
    print_success "gdrive: was successfully setupped"
fi


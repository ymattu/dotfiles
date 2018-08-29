#!/bin/bash

# dotfiles path
DOTFILES_PATH="$HOME/dotfiles"

# Load utils
. $DOTFILES_PATH/setup/utils.sh

print_title "Xcode"

if [ -d "$(xcode-select -p)" ]; then
    print_warning "xcode-select: already installed"
else
    xcode-select --install
fi

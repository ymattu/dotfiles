#!/bin/bash

# dotfiles path
DOTFILES_PATH="$HOME/dotfiles"

# Load utils
. $DOTFILES_PATH/setup/utils.sh

print_title "Setting Emacs directories"

cd $HOME/.emacs.d
specdir=$HOME/.emacs.d/spec


if [ -e $specdir ]; then
    print_success "$specdir already exists."
else
    x=$(gdrive list | grep spec | awk '{print $1}')
    gdrive download $x --recursive
    print_success "Directory 'spec' was successfully downloaded"
fi



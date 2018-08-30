#!/bin/bash

# dotfiles path
DOTFILES_PATH="$HOME/dotfiles"

# Load utils
. $DOTFILES_PATH/setup/utils.sh

print_title "Emacs"

install_emacs() {
    emacsfile=/Applications/Emacs.app

    if [ -e $emacsfile ]; then
        print_warning "Emacs.app: already exists."
    else
        print_message "Installing Emacs"
        download_url=https://github.com/vigou3/emacs-modified-macos/releases/download/v26.1-2-modified-1/Emacs-26.1-2-modified-1.dmg
        dmg_file=${download_url##*/}

        wget $download_url
        mount_dir=`hdiutil attach $dmg_file | awk -F '\t' 'END{print $NF}'`
        sudo ditto "$mount_dir/Emacs.app" "/Applications/Emacs.app"
        hdiutil detach "$mount_dir"
        rm $dmg_file
        print_success "Emacs: successfully installed."
    fi
}

setup_emacs() {
    print_message "Setting Emacs directories"
    cd $HOME/.emacs.d
    specdir=$HOME/.emacs.d/spec

    if [ -e $specdir ]; then
        print_warning "$specdir : already exists."
    else
        x=$(gdrive list | grep spec | awk '{print $1}')
        gdrive download $x --recursive
        print_success "Directory 'spec' : successfully downloaded"
    fi
}

main() {
    install_emacs
    setup_emacs
}

main


#!/bin/bash

# dotfiles path
DOTFILES_PATH="$HOME/dotfiles"

# Load utils
. $DOTFILES_PATH/setup/utils.sh

check_os() {
    os_name="$(uname)"
    if [ "$os_name" != "Darwin" ]; then
        print_error "Sorry, this script is intended only for macOS"
        exit 1
    fi
}

download_dotfiles() {
    print_title "Download dotfiles"
    if [ -d $DOTFILES_PATH ]; then
        print_warning "dotfiles: already exists"
    else
        print_message "Downloading dotfiles..."
        if type git > /dev/null 2>&1; then
            git clone https://github.com/ymattu/dotfiles.git
        else
            curl -sL https://github.com/ymattu/dotfiles/archive/master.tar.gz | tar xz
            mv dotfiles-master dotfiles
        fi
        print_success "successfully downloaded"
    fi
}

main() {
    check_os
    download_dotfiles

    . $DOTFILES_PATH/setup/symbolic_links.sh
    . $DOTFILES_PATH/setup/install/main.sh

    # change_login_shell
    # reboot_system
    # reload_shell
}

main


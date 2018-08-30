#!/bin/bash

# dotfiles path
DOTFILES_PATH="$HOME/dotfiles"

# Load utils
. $DOTFILES_PATH/setup/utils.sh


check_gdrive() {
    print_title "gdrive"
    package=gdrive
    if brew list $package > /dev/null 2>&1; then
        print_warning "$package: already installed"
    elif brew install $package > /dev/null 2>&1; then
        print_success "$package: successfully installed"
    else
        print_error "$package: unsuccessfully installed"
    fi
}

setup_gdrive() {
    print_message "Setup gdrive..."
    gdrivedir=$HOME/.gdrive
    if [ -e $gdrivedir ]; then
        print_warning "gdrive: already setupped"
    else
        gdrive list
        print_success "gdrive: successfully setupped"
    fi
}

main() {
    check_gdrive
    setup_gdrive
}

main

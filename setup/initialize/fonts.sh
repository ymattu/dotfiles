#!/bin/bash

# dotfiles path
DOTFILES_PATH="$HOME/dotfiles"

# Load utils
. $DOTFILES_PATH/setup/utils.sh


readonly DIR_FONT="${HOME}/temp/font"
[ ! -e ${DIR_FONT} ] && mkdir ${DIR_TEMP}

download_fonts() {
    print_title "Fonts"
    print_message "Downloading fonts..."
    wget -i $DOTFILES_PATH/setup/initialize/fonts.txt
    print_success "Fonts: succrssfully dowloaded"
}

install_fonts() {
    print_message "Installing Fonts"
    cp $DIR_FONT/* /Library/Fonts/
    print_success "Fonts: succrssfully installed"
}

main() {
    download_fonts
    install_fonts
}

main

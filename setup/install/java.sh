#!/bin/bash

# dotfiles path
DOTFILES_PATH="$HOME/dotfiles"

# Load utils
. $DOTFILES_PATH/setup/utils.sh

print_title "Java"

install_java() {
    if which java >/dev/null 2>&1; then
        print_warning "Java is already installed"
    else
        print_message "Installing Java"
        download_url=http://javadl.sun.com/webapps/download/AutoDL?BundleId=105219
        dmg_file=jre.dmg

        curl -L -o $dmg_file "$download_url"
        mount_dir=`hdiutil attach $dmg_file | awk -F '\t' 'END{print $NF}'`
        java_dir="${mount_dir##*/}"
        sudo "$mount_dir/${java_dir}.app/Contents/MacOS/MacJREInstaller"
        hdiutil detach "$mount_dir"
        rm $dmg_file
        print_success "Java: successfully installed"
    fi
}

install_java

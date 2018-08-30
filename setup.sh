#!/bin/bash

# util functions
print_error() {
    printf "\033[31m    [×] $1\033[m\n"
}

print_success() {
    printf "\033[32m    [✓] $1\033[m\n"
}

print_warning() {
    printf "\033[33m    [!] $1\033[m\n"
}

print_title() {
    printf "\n\n\033[35m$1\033[m\n\n"
}

print_message() {
    printf "    $1\n"
}
######################################

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
        cd dotfiles && git pull
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

change_login_shell() {
    print_title "Xonsh"
    loginshell="$HOME/.pyenv/shims/xonsh"
    if [ $SHELL == $loginshell ]; then
        print_warning "Login shell: already xonsh"
    else
        print_message "Changing login shell..."
        grep "$loginshell" /etc/shells &>/dev/null || sudo sh -c "echo $loginshell >> /etc/shells"
        chsh -s $loginshell
        print_success "successfully changed to xonsh"
    fi
}

reboot_system() {
    print_title "Reboot System"
    printf "Do you want to reboot the system? (y/n) "
    read
    if [[ $REPLY =~ ^[Yy]$ || $REPLY == '' ]]; then
        sudo shutdown -r now &> /dev/null
    fi
}

reload_shell() {
    printf "\n\n"
    exec $(which xonsh)
}

main() {
    check_os
    download_dotfiles

    . $DOTFILES_PATH/setup/symbolic_links.sh
    . $DOTFILES_PATH/setup/gdrive.sh
    . $DOTFILES_PATH/setup/install/main.sh

    change_login_shell
    reboot_system
    reload_shell
}

main


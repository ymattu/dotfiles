#!bin/bash

# dotfiles path
DOTFILES_PATH="$HOME/dotfiles"

# Load utils
. $DOTFILES_PATH/setup/utils.sh

install_rbenv(){
    print_title "rbenv"

    if type rbenv > /dev/null 2>&1; then
        print_warning "rbenv: already installed"
    else
        print_message "Installing rbenv..."
        echo 'eval "$(rbenv init -)"' >> ~/.bashrc
        source ~/.bashrc
        rbenv install 2.4.1
        rbenv global 2.4.1
        print_success "successfully installed"
    fi
}

install_packages() {
    print_message "Installing packages"
    packages=(rcodetools rdefs google-ime-skk)

    for package in "${packages[@]}"; do
        if gem list "$package" > /dev/null 2>&1; then
            print_warning "$package: already installed"
        elif gem install $package > /dev/null 2>&1; then
            print_success "$package: successfully installed"
        else
            print_error "$package: unsuccessfully installed"
        fi
    done
}

main() {
    install_rbenv
    install_packages
}

main

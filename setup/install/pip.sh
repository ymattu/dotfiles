#!bin/bash

# Load utils
. setup/utils.sh

install_pyenv(){
    print_title "pyenv"

    if type pyenv > /dev/null 2>&1; then
        print_warning "pyenv: already installed"
    else
        print_message "Installing pyenv..."
        git clone https://github.com/yyuu/pyenv.git ~/.pyenv
        echo "export PYENV_ROOT=$HOME/.pyenv" >> ~/.bashrc
        echo "export PATH=$PYENV_ROOT/bin:$PATH" >> ~/.bashrc
        echo 'eval "$(pyenv init -)"' >> ~/.bashrc
        pyenv install 3.6.0
        pyenv install anaconda3-5.0.1
        pyenv global anaconda3-5.0.1
        git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
        echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
        print_success "successfully installed"
    fi
}

install_packages() {
    print_message "Installing packages"
    packages=(grip vertualenv xonsh backtrace xontrib-powerline)

    for package in "${packages[@]}"; do
        if pip list | grep "$package" > /dev/null 2>&1; then
            print_warning "$package: already installed"
        elif pip install $package > /dev/null 2>&1; then
            print_success "$package: successfully installed"
        else
            print_error "$package: unsuccessfully installed"
        fi
    done
}

main() {
    install_pyenv
    install_packages
}

main

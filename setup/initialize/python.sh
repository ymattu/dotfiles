#!bin/bash

# dotfiles path
DOTFILES_PATH="$HOME/dotfiles"

# Load utils
. $DOTFILES_PATH/setup/utils.sh

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
        source ~/.bashrc
        unset PYENV_VERSION
        pyenv install 3.6.0
        pyenv install anaconda3-5.0.0
        pyenv global anaconda3-5.0.0
        pyenv rehash
        git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
        echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
        print_success "successfully installed"
    fi
}

install_packages() {
    print_message "Installing packages..."
    packages=(grip virtualenv jedi epc xonsh backtrace xontrib-powerline)

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

install_juno() {
    print_title "Juno for Jupyter Notebooks"
    print_message "Installing Juno..."
    if [ -e /Applications/Juno.app ]; then
        print_warning "Juno is already installed"
    else
        download_url=https://github.com/uetchy/juno/releases/download/v0.3.2-beta.1/juno-0.3.2-beta.1-mac.zip
        zip_file=${download_url##*/}

        curl -LO $download_url
        sudo unzip $zip_file -d /Applications
        rm $zip_file
    fi

    print_message "Making .junorc.json..."
    jupyter_dir=$(which jupyter-notebook)
    jupyter_home=$HOME
    printf '{"jupyterCommand": "%s","jupyterPort": 8888,"jupyterHome": "%s","openBrowserOnStartup": false}' $jupyter_dir $jupyter_home | jq . > $DOTFILES_PATH/.junorc.json

    if [ -e $HOME/.junorc.json ]; then
        sudo rm .junorc.json
    fi

    ln -s $DOTFILES_PATH/.junorc.json $HOME/
    print_success "Success!"
}

main() {
    install_pyenv
    install_packages
    install_juno
}

main

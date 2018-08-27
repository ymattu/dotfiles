#!bin/bash

# Load utils
. setup/utils.sh

print_title "pip"

# pyenv
git clone https://github.com/yyuu/pyenv.git ~/.pyenv
echo "export PYENV_ROOT=$HOME/.pyenv" >> ~/.bashrc
echo "export PATH=$PYENV_ROOT/bin:$PATH" >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
pyenv install 3.6.0
pyenv install anaconda3-5.0.1
pyenv global anaconda3-5.0.1
git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc

# packages
pip install grip vertualenv

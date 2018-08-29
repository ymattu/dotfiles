#!bin/bash

# dotfiles path
DOTFILES_PATH="$HOME/dotfiles"

# Load utils
. $DOTFILES_PATH/setup/utils.sh

print_title "node"

npm install tern

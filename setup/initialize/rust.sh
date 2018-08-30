#!bin/bash

# dotfiles path
DOTFILES_PATH="$HOME/dotfiles"

# Load utils
. $DOTFILES_PATH/setup/utils.sh

print_title "Rust"

if type rustup > /dev/null 2>&1; then
    print_warning "rustup: already installed"
else
    curl https://sh.rustup.rs -sSf | sh
    cargo install racer rustfmt ripgrep
    rustup component add rust-src
fi

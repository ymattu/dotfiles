#!/bin/bash

# dotfiles path
DOTFILES_PATH="$HOME/dotfiles"

# Load utils
. $DOTFILES_PATH/setup/utils.sh


deploy() {
    for file in .?*
    do
        filepath="${PWD}/${file}"

        [[ "$file" == ".git" ]] && continue
        [[ "$file" == ".gitignore" ]] && continue
        [[ "$file" == ".DS_Store" ]] && continue

        ln -sfn $filepath $HOME/$file
        print_success "$HOME/$file -> $filepath"
    done

    ln -s $HOME/dotfiles/.R/.Renviron $HOME/.Renviron
    print_success "$HOME/.Renviron -> $HOME/dotfiles/.R/.Renviron"
}

main() {
    cd $DOTFILES_PATH
    print_title "Create symbolic links"
    deploy
}

main

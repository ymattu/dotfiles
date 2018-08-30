#!/bin/bash

# dotfiles path
DOTFILES_PATH="$HOME/dotfiles"

# Load utils
. $DOTFILES_PATH/setup/utils.sh

install_iterm2() {
    print_title "iterm2"
    print_message "Downloading iterm2..."
    download_url=https://iterm2.com/downloads/stable/latest
    zip_file=${download_url##*/}

    curl -LO $download_url
    sudo unzip $zip_file -d /Applications
    rm $zip_file

    print_message "iterm2: successfully installed."
}

setting_iterm2() {
    print_title "Setting iterm2"
    # tmp
    readonly DIR_TEMP="${HOME}/temp"
    [ ! -e ${DIR_TEMP} ] && mkdir ${DIR_TEMP}

    readonly ITERM_DIR="${HOME}/Downloads/item_setting"
    [ ! -e ${ITERM_DIR} ] && mkdir ${ITERM_DIR}

    # clear
    if [ -e ${HOME}/Library/com.googlecode.iterm2.plist ]; then
        mv ${HOME}/Library/com.googlecode.iterm2.plist \
           ${DIR_TEMP}/com.googlecode.iterm2.plist.$(date '+%Y%m%d%H%M')
    fi

    # set
    url_is="https://gist.githubusercontent.com/ymattu/a9091fb743f5c0b311402e32233e0453/raw/0501191ae368e3af56b57f86f9a0f1e6eca774b9/com.googlecode.iterm2.plist"
    ## download plist
    curl "${url_is}" \
         -o "${DIR_TEMP}/$(basename $url_is)"
    ## 持ってく
    cp -f ${DIR_TEMP}/com.googlecode.iterm2.plist \
       ${ITERM_DIR}

    # 反映
    defaults read com.googlecode.iterm2 >/dev/null

    print_message "Success!"
}

main() {
    install_iterm2
    setting_iterm2
}

main

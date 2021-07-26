#!/bin/bash
if [[ "$(nvim -v | head -n1 | cut -c6-)" != "$(wget -qO- api.github.com/repos/neovim/neovim/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')" ]]; then
    DIR=$PWD
    cd ~/.local/bin
    echo Downloading Neovim...
    wget --show-progress -q github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    mv nvim.appimage nvim
    cd $DIR
else
    echo Neovim is up to date.
fi

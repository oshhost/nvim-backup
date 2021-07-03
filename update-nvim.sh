#!/bin/bash
if [[ "$(nvim -v | head -n1 | cut -c6-)" != "$(wget -qO- api.github.com/repos/neovim/neovim/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')" ]]; then
    DIR=$PWD
    cd /tmp
    echo Downloading Neovim...
    wget --show-progress -q github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    echo Extracting...
    ./nvim.appimage --appimage-extract >/dev/null
    rm nvim.appimage
    echo Moving content to ~/.local/share/nvim...
    rm -rf ~/.local/share/nvim
    mv squashfs-root/* ~/.local/share/nvim
    rm -rf squashfs-root
    cd $DIR
else
    echo Neovim is up to date.
fi

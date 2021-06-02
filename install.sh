#!/bin/bash
URL="https://raw.githubusercontent.com/oshhost/nvim-backup/main/init.vim"

mkdir -p ~/.local/bin
mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload

if ! hash nvim 2>/dev/null; then
    if [ ! -e ~/.local/share/nvim/AppRun ]; then
        DIR=$PWD
        cd ~/.local/share
        echo Downloading Neovim...
        wget https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        chmod u+x nvim.appimage
        ./nvim.appimage --appimage-extract
        rm nvim.appimage
        shopt -s dotglob
        mv squashfs-root/* nvim
        rmdir squashfs-root
        for DEST in vi vim nvim; do
            ln -sf "/home/$USER/.local/share/nvim/AppRun" "/home/$USER/.local/bin/$DEST"
        done
        cd $DIR
    fi
    if ! hash nvim 2>/dev/null; then
        echo 'PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        NS=1
    fi
else
    if [ ! -e ~/.local/share/nvim/AppRun ]; then
        for DEST in vi vim nvim; do
            ln -sf "/usr/bin/nvim" "/home/$USER/.local/bin/$DEST"
        done
    fi
fi

if [ ! -e ~/.local/share/nvim/site/autoload/plug.vim ]; then
    echo Downloading plug.vim...
    wget -O "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if ! hash node 2>/dev/null; then
    echo Downloading Node.js...
    wget -O- install-node.now.sh/lts | FORCE=1 PREFIX=$HOME/.local bash
fi

if [ ! -e ~/.config/nvim/init.vim ]; then
    mkdir -p ~/.config/nvim
    echo Downloading init.vim...
    wget -O ~/.config/nvim/init.vim $URL
fi

if [ -z "$NS" ]; then
    nvim +'PlugInstall --sync|source $MYVIMRC'
else
    bash -c "nvim +'PlugInstall --sync|source $MYVIMRC'"
fi

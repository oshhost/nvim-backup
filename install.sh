#!/bin/bash
URL="https://raw.githubusercontent.com/oshhost/nvim-backup/main/init.vim"

mkdir -p ~/.config/nvim/
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/nvim

if ! hash nvim 2>/dev/null; then
    if [[ ! -e ~/.local/share/nvim/AppRun ]]; then
        DIR=$PWD
        cd ~/.local/share
        echo Downloading Neovim...
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
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
        echo 'PATH="$HOME/.local/bin:$PATH"' >> ~/.profile
        NS=1
    fi
else
    if [[ ! -e ~/.local/share/nvim/AppRun ]]; then
        for dest in vi vim nvim; do
            ln -sf "/usr/bin/nvim" "/home/$USER/.local/bin/$DEST"
        done
    fi
fi

if [[ ! -e ~/.local/share/nvim/site/autoload/plug.vim ]]; then
    echo Downloading plug.vim...
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi

if ! hash node 2>/dev/null; then
    echo Downloading Node.js...
    curl -L install-node.now.sh/lts | FORCE=1 PREFIX=$HOME/.local bash
fi

echo Downloading init.vim...
curl -o ~/.config/nvim/init.vim $URL

if [[ -z "$NS" ]]; then
    nvim +'PlugInstall --sync|source $MYVIMRC'
else
    bash -c "nvim +'PlugInstall --sync|source $MYVIMRC'"
fi

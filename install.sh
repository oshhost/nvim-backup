#!/bin/bash
INIT="raw.githubusercontent.com/oshhost/nvim-backup/main/init.vim"
NODE="install-node.now.sh/lts"

mkdir -p ~/.local/bin
mkdir -p ~/.local/share/nvim/site/autoload
mkdir -p ~/.config/nvim/plugged

if ! hash nvim 2>/dev/null; then
    if [ ! -e ~/.local/share/nvim/AppRun ]; then
        DIR=$PWD
        cd /tmp
        echo Downloading Neovim...
        wget https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        chmod u+x nvim.appimage
        ./nvim.appimage --appimage-extract
        rm nvim.appimage
        shopt -s dotglob
        mv squashfs-root/* ~/.local/share/nvim
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

if [ ! -e ~/.config/nvim/init.vim ]; then
    echo Downloading init.vim...
    wget -O ~/.config/nvim/init.vim $INIT
fi

if [ ! -e ~/.local/share/nvim/site/autoload/plug.vim ]; then
    echo Downloading plug.vim...
    wget -O ~/.local/share/nvim/site/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if ! hash git 2>/dev/null; then
    DIR=$PWD
    cd ~/.config/nvim/plugged
    echo Git not found. Downloading plugins via wget... 
    cat ~/.config/nvim/init.vim | grep "Plug '" | sed -e "s/^.*Plug [']//" -e "s/'.*//" | grep -v git | while read REP; if [ "$REP" = "" ]; then break; fi; OUT=$(echo $REP | sed -e "s/.*\///").tgz; do wget --show-progress -qO $OUT github.com/$REP/tarball/master; done
    ls | grep .tgz$ | while read TAR; do tar xfv $TAR; done
    rm *.tgz
    ls | while read REP; do mv $REP $(echo $REP | sed -e "s/^[^-]*-//" -e "s/\(.*\)-.*/\1/"); done
    cd $DIR
fi

if ! hash node 2>/dev/null; then
    echo Installing Node.js...
    wget -O- $NODE | FORCE=1 PREFIX=$HOME/.local bash
fi

if [ -z "$NS" ]; then
    nvim +'PlugInstall --sync|source $MYVIMRC'
else
    ~/.local/bin/nvim +'PlugInstall --sync|source $MYVIMRC'
fi

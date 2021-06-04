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
        wget --show-progress -q https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        chmod u+x nvim.appimage
        ./nvim.appimage --appimage-extract >/dev/null
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
    wget --show-progress -qO ~/.config/nvim/init.vim $INIT
fi

if [ ! -e ~/.local/share/nvim/site/autoload/plug.vim ]; then
    echo Downloading plug.vim...
    wget --show-progress -qO ~/.local/share/nvim/site/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if ! hash git 2>/dev/null; then
    if [ -z "$(ls -A ~/.config/nvim/plugged)" ]; then
        DIR=$PWD
        cd ~/.config/nvim/plugged
        echo Git not found. Downloading plugins via wget... 
        cat ~/.config/nvim/init.vim | grep "Plug '" | sed -e "s/^.*Plug [']//" -e "s/'.*//" | grep -v git | while read REP; if [ "$REP" = "" ]; then break; fi; OUT=$(echo $REP | sed -e "s/.*\///").tgz; do if [ "$REP" = "neoclide/coc.nvim" ]; then REF=release; else REF=master; fi; wget --show-progress -qO $OUT github.com/$REP/tarball/$REF; done
        ls | grep .tgz$ | while read TAR; do tar xf $TAR; done
        rm *.tgz
        ls | while read REP; do mv $REP $(echo $REP | sed -e "s/^[^-]*-//" -e "s/\(.*\)-.*/\1/"); done
        cd $DIR
    else
        echo ~/.config/nvim/plugged already contain some files. Assuming the plugins are installed...
    fi
fi

if ! hash node 2>/dev/null; then
    echo Installing Node.js...
    wget --show-progress -qO- $NODE | FORCE=1 PREFIX=$HOME/.local bash >/dev/null
fi

if [ -z "$NS" ]; then
    nvim +'PlugInstall --sync|source $MYVIMRC'
else
    bash -c "source ~/.bashrc && nvim +'PlugInstall --sync|source $MYVIMRC'"
fi

echo Done.

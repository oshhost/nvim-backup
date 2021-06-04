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
        wget --show-progress -q github.com/neovim/neovim/releases/latest/download/nvim.appimage
        chmod u+x nvim.appimage
        echo Extracting...
        ./nvim.appimage --appimage-extract >/dev/null
        rm nvim.appimage
        echo Moving content to ~/.local/share/nvim...
        mv squashfs-root/* ~/.local/share/nvim
        rm -rf squashfs-root
        echo Symlinking vi and vim to nvim... You might want to change this behaviour.
        for DEST in vi vim nvim; do
            ln -sf "$HOME/.local/share/nvim/AppRun" "$HOME/.local/bin/$DEST"
        done
        cd $DIR
    fi
    if ! hash nvim 2>/dev/null; then
        echo Prepending ~/.local/bin to PATH \(~/.bashrc\)... You might want to change this behaviour.
        echo 'PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        PATH=$HOME/.local/bin:$PATH
    fi
else
    if [ ! -e ~/.local/share/nvim/AppRun ]; then
        echo Symlinking vi and vim to nvim... You might want to change this behaviour.
        for DEST in vi vim nvim; do
            ln -sf "/usr/bin/nvim" "$HOME/.local/bin/$DEST"
        done
    fi
fi

if [ ! -e ~/.config/nvim/init.vim ]; then
    echo Downloading init.vim...
    wget --show-progress -qO ~/.config/nvim/init.vim $INIT
fi

if [ ! -e ~/.local/share/nvim/site/autoload/plug.vim ]; then
    echo Downloading plug.vim...
    wget --show-progress -qO ~/.local/share/nvim/site/autoload/plug.vim raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if ! hash git 2>/dev/null; then
    NO_GIT=1
    if [ -z "$(ls -A ~/.config/nvim/plugged)" ]; then
        DIR=$PWD
        cd ~/.config/nvim/plugged
        echo Git not found. Downloading plugins via wget... 
        echo Skipping plugins containing the \'git\' substring...
        cat ~/.config/nvim/init.vim | grep "Plug '" | grep -v git | sed -e "s/^.*Plug [']//" -e "s/'.*//" | while read REP; if [ "$REP" = "" ]; then break; fi; OUT=$(echo $REP | sed -e "s/.*\///").tgz; do if [ "$REP" = "neoclide/coc.nvim" ]; then REF=release; else REF=master; fi; wget --show-progress -qO $OUT github.com/$REP/tarball/$REF; done
        echo Extracting...
        ls | grep .tgz$ | while read TAR; do tar xf $TAR; done
        rm *.tgz
        echo Renaming...
        ls | while read REP; do mv $REP $(echo $REP | sed -e "s/^[^-]*-//" -e "s/\(.*\)-.*/\1/"); done
        cd $DIR
    else
        echo ~/.config/nvim/plugged already contains some files. Assuming the plugins are installed...
    fi
fi

if ! hash node 2>/dev/null; then
    echo Installing Node.js...
    wget --show-progress -qO- $NODE | FORCE=1 PREFIX=~/.local bash >/dev/null 2>&1
fi

if [ -z "$NO_GIT" ]; then
    nvim +'PlugInstall --sync|q|q'
    nvim
else
    nvim
fi

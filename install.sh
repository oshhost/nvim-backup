#!/bin/sh
INIT="raw.githubusercontent.com/oshhost/nvim-backup/main/init.vim"
NODE="install-node.now.sh/lts"

CB=$(tput setaf 4);CG=$(tput setaf 2);CD=$(tput sgr0)

echo
echo "${CB}ooooo      ooo${CG}                                 o8o"
echo "${CB}\`888b.     \`8'${CG}                                 \`\"'"
echo "${CB} 8 \`88b.    8   .ooooo.   .ooooo.${CG} oooo    ooo oooo  ooo. .oo.  .oo."
echo "${CB} 8   \`88b.  8  d88' \`88b d88' \`88b${CG} \`88.  .8'  \`888  \`888P\"Y88bP\"Y88b"
echo "${CB} 8     \`88b.8  888ooo888 888   888${CG}  \`88..8'    888   888   888   888"
echo "${CB} 8       \`888  888    .o 888   888${CG}   \`888'     888   888   888   888"
echo "${CB}o8o        \`8  \`Y8bod8P' \`Y8bod8P'${CG}    \`8'     o888o o888o o888o o888o${CD}"
echo

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
        echo Symlinking vi and vim to nvim \(~/.local/bin\)... You might want to change this behaviour manually.
        for DEST in vi vim nvim; do
            ln -sf "$HOME/.local/share/nvim/AppRun" "$HOME/.local/bin/$DEST"
        done
        cd $DIR
    fi
    if ! hash nvim 2>/dev/null; then
        echo Prepending ~/.local/bin to PATH \(~/.bashrc\)... You might want to change this behaviour manually.
        echo 'PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        PATH=$HOME/.local/bin:$PATH
    fi
else
    if [ ! -e ~/.local/share/nvim/AppRun ]; then
        echo Symlinking vi and vim to nvim... You might want to change this behaviour manually.
        for DEST in vi vim nvim; do
            ln -sf "/usr/bin/nvim" "$HOME/.local/bin/$DEST"
        done
    fi
fi
echo

if [ ! -e ~/.config/nvim/init.vim ]; then
    echo Downloading init.vim...
    wget --show-progress -qO ~/.config/nvim/init.vim $INIT
    echo
fi

if [ ! -e ~/.local/share/nvim/site/autoload/plug.vim ]; then
    echo Downloading plug.vim...
    wget --show-progress -qO ~/.local/share/nvim/site/autoload/plug.vim raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo
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
    echo
fi

if ! hash node 2>/dev/null; then
    echo Installing Node.js...
    wget --show-progress -qO- $NODE | FORCE=1 PREFIX=~/.local bash >/dev/null 2>&1
    echo
fi

echo The installation is complete.
sleep 1
echo

if [ -z "$NO_GIT" ]; then
    nvim +'PlugInstall --sync|q!|q!'
fi
nvim +"let g:startify_custom_header=startify#fortune#cowsay(['Thank you for installing Neovim!'])|sil Startify"

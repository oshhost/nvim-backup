url="https://raw.githubusercontent.com/oshhost/nvim-backup/main/init.vim"

mkdir -p ~/.config/nvim/

if ! hash nvim 2>/dev/null; then
    dir=$PWD
    cd ~/.config/nvim/
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    sudo mv nvim.appimage /usr/bin/nvim
    cd $dir
fi

sudo ln -sf /usr/bin/nvim /usr/bin/vi
sudo ln -sf /usr/bin/nvim /usr/bin/vim

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
curl -o ~/.config/nvim/init.vim $url

nvim +PlugInstall

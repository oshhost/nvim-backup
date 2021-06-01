os="$(cat /etc/os-release | grep ^ID= | cut -c 4-)"
url="https://raw.githubusercontent.com/oshhost/nvim-backup/main/init.vim"

if ! hash nvim 2>/dev/null; then
    case "$os" in 
        "ubuntu"* )
            sudo add-apt-repository ppa:neovim-ppa/unstable -y
            sudo apt update
            sudo apt -y install neovim
        ;;
        "arch"* )
            yes | sudo pacman -S neovim
        ;;
        * )
            echo The system is not supported.
            exit 1
    esac
fi

read -p "Do you want to symlink /bin/vi and /bin/vim to /bin/nvim? [y/N] " yn
case $yn in
    [Yy]* )
        sudo ln -sf /usr/bin/nvim /usr/bin/vi
        sudo ln -sf /usr/bin/nvim /usr/bin/vim
        ;;
    * );;
esac

read -p "Do you want install custom init.vim? [y/N] " yn
case $yn in 
    [Yy]* )
        rm -f ~/.local/share/nvim/site/autoload/plug.vim
	mkdir -p ~/.config/nvim/
        if hash wget 2>/dev/null; then
            wget -O ~/.config/nvim/init.vim $url
        elif hash curl 2>/dev/null; then
            curl -o ~/.config/nvim/init.vim $url
            echo 1
        else
            read -p "Neither wget nor curl is installed. Do you want to install wget? [y/N] " yn
            case $yn in
                [Yy]* )
                    case "$os" in
                        "ubuntu"* )
                            sudo apt -y install wget
                        ;;
                        "arch"* )
                            yes | sudo pacman -S wget
                        ;;
                    esac
                    ;;
                * );;
            esac
            if hash wget 2>/dev/null; then
                wget -P ~/.config/nvim/ -O init.vim $url
            fi
        fi
        ;;
    * );;
esac

killall yes

nvim

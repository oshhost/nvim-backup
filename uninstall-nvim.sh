#!/bin/bash
read -p "Do you really want to uninstall Neovim? [y/N] " yn
case $yn in
    [Yy]* )
        read -p "All configuration files will be deleted. Continue? [y/N] " ync
        case $ync in 
            [Yy]* )
                echo Removing symlinks and executables in ~/.local/bin...
                rm ~/.local/bin/vi ~/.local/bin/vim ~/.local/bin/nvim
                echo Removing data and config files...
                rm -rf ~/.local/share/nvim ~/.config/nvim ~/.config/coc
                echo Removing scripts...
                rm ~/.local/bin/update-nvim.sh ~/.local/bin/uninstall-nvim.sh
        esac
        ;;
esac

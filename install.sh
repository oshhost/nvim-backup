CC='\033[36m';CB='\033[34m';CG='\033[32m';CR='\033[31m';CD='\033[0m'
echo
echo "${CB}ooooo      ooo${CG}                                 o8o                                 ${CC}  .oooooo."
echo "${CB}\`888b.     \`8'${CG}                                 \`\"'                                 ${CC} d8P'  \`Y8b"
echo "${CB} 8 \`88b.    8   .ooooo.   .ooooo.${CG} oooo    ooo oooo  ooo. .oo.  .oo.   ${CR},d88b.d88b,  ${CC}888            .ooooo."
echo "${CB} 8   \`88b.  8  d88' \`88b d88' \`88b${CG} \`88.  .8'  \`888  \`888P\"Y88bP\"Y88b  ${CR}88888888888  ${CC}888           d88' \`88b"
echo "${CB} 8     \`88b.8  888ooo888 888   888${CG}  \`88..8'    888   888   888   888  ${CR}\`Y8888888Y'  ${CC}888     ooooo 888   888"
echo "${CB} 8       \`888  888    .o 888   888${CG}   \`888'     888   888   888   888    ${CR}\`Y888Y'    ${CC}\`88.    .88'  888   888"
echo "${CB}o8o        \`8  \`Y8bod8P' \`Y8bod8P'${CG}    \`8'     o888o o888o o888o o888o     ${CR}\`Y'      ${CC} \`Y8bood8P'   \`Y8bod8P'${CD}"
echo

mkdir -p ~/.local/bin
mkdir -p ~/.local/share/nvim/site/autoload
mkdir -p ~/.config/nvim/plugged

getch() {
	echo
	old=$(stty -g 2>/dev/null)
	stty raw min 0 time 50 2>/dev/null
	printf %s "$1"
	eval "$2=\$(dd bs=1 count=1 2>/dev/null)"
	stty $old 2>/dev/null
	echo
}

if ! hash nvim 2>/dev/null; then
	if [ ! -e ~/.local/share/nvim/AppRun ]; then
		cd ~/.local/bin
		echo Downloading Neovim...
		wget --continue --show-progress -q github.com/neovim/neovim/releases/latest/download/nvim.appimage
		chmod u+x nvim.appimage
		mv nvim.appimage nvim
		getch "Create symlinks to nvim? [Y/n]: " yn
		case $yn in
			[Nn]* );;
			* )
				echo Symlinking vi and vim to nvim \(~/.local/bin\)...
				for DEST in vi vim; do
					ln -sf "$HOME/.local/bin/nvim" "$HOME/.local/bin/$DEST"
				done
		esac
		echo && echo To uninstall and update neovim use uninstall-nvim.sh and update-nvim.sh scripts accordingly \(~/.local/bin\)...
		UNINSTALL="raw.githubusercontent.com/oshhost/nvim-backup/main/uninstall-nvim.sh"
		UPDATE="raw.githubusercontent.com/oshhost/nvim-backup/main/update-nvim.sh"
		wget --show-progress -q $UNINSTALL $UPDATE
		chmod +x uninstall-nvim.sh update-nvim.sh
	fi
	if ! hash nvim 2>/dev/null; then
		getch "Add ~/.local/bin to PATH? [Y/n]: " yn
		case $yn in
			[Nn]* );;
			* )
				echo Prepending ~/.local/bin to PATH \(~/.bashrc\)...
				echo 'PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
		esac
	fi
	PATH=$HOME/.local/bin:$PATH
else
	if [ ! -e ~/.local/share/nvim/AppRun ]; then
		getch "Create symlinks to nvim? [Y/n]: " yn
		case $yn in
			[Nn]* );;
			* )
				echo Symlinking vi and vim to nvim \(~/.local/bin\)...
				for DEST in vi vim; do
					ln -sf "/usr/bin/nvim" "$HOME/.local/bin/$DEST"
				done
		esac
	fi
fi

echo \\nSynchronizing init.vim...
INIT="raw.githubusercontent.com/oshhost/nvim-backup/main/init.vim"
wget --show-progress -qO ~/.config/nvim/init.vim $INIT

if [ ! -e ~/.local/share/nvim/site/autoload/plug.vim ]; then
	echo \\nDownloading plug.vim...
	wget --show-progress -qO ~/.local/share/nvim/site/autoload/plug.vim raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if ! hash git 2>/dev/null; then
	echo
	NO_GIT=1
	if [ -z "$(ls -A ~/.config/nvim/plugged)" ]; then
		cd ~/.config/nvim/plugged
		echo Git not found. Downloading plugins via wget...
		echo Skipping plugins containing the \'git\' substring...
		cat ~/.config/nvim/init.vim | grep "Plug '" | grep -v git | sed -e "s/^.*Plug [']//" -e "s/'.*//" | while read REP; if [ "$REP" = "" ]; then break; fi; OUT=$(echo $REP | sed -e "s/.*\///").tgz; do if [ "$REP" = "neoclide/coc.nvim" ]; then REF=release; else REF=master; fi; wget --show-progress -qO $OUT github.com/$REP/tarball/$REF; done
		echo Extracting...
		ls | grep .tgz$ | while read TAR; do TE=${TAR%.tgz}; mkdir $TE; tar xf $TAR -C $TE; cd $TE; TD=$(ls); mv $TD/* .; mv $TD/.* . 2>/dev/null; rmdir $TD; cd ..; done
		rm *.tgz
	else
		echo ~/.config/nvim/plugged already contains some files. Assuming the plugins are installed...
	fi
fi

echo
echo Synchronizing coc-settings.json...
COC="https://raw.githubusercontent.com/oshhost/nvim-backup/main/coc-settings.json"
wget --show-progress -qO ~/.config/nvim/coc-settings.json $COC

if ! hash node 2>/dev/null; then
	getch "Install Node.js? [Y/n]: " yn
	case $yn in
		[Nn]* );;
		* )
			echo Installing Node.js... It might take a while.
			NODE="install-node.vercel.app/lts"
			wget --show-progress -qO- $NODE | FORCE=1 PREFIX=~/.local bash >/dev/null 2>&1
	esac
fi

if ! hash go 2>/dev/null; then
	getch "Install Golang & Go tools? [Y/n]: " yn
		case $yn in
			[Nn]* );;
			* )
				cd /tmp
				echo Installing Golang...
				LATEST="$(wget -qO- 'https://golang.org/VERSION?m=text')"
				DL_PKG="$LATEST.linux-amd64.tar.gz"
				DL_URL="https://golang.org/dl/$DL_PKG"
				wget --no-check-certificate --continue --show-progress -q "$DL_URL" -P "$GOUTIL"
				tar -C $HOME -xzf "$DL_PKG"
				rm "$DL_PKG"
				cd $HOME
				mv go .go
				echo To update golang use update-golang.sh script \(~/.local/bin\)...
				cd ~/.local/bin
				UPDATE="https://raw.githubusercontent.com/oshhost/nvim-backup/main/update-golang.sh"
				wget --show-progress -q $UPDATE
				chmod +x update-golang.sh
				cd ~/.go/bin
				echo \\nInstalling Go tools...
				GOBIN="https://downloader.disk.yandex.ru/disk/51ab885eccc75ffa598d64719707a5fcd752d2aebb45721744dac1761b6cf218/611e6dce/DRMCr5CGSzbe88mLEQlnqDx1fHc8lpPwWY4iHj9xZlOnj1MitsUfSzzcbTvm4T2KFnTxUu5C4S7atq0tEcJUiQ%3D%3D?uid=0&filename=bin.tbz&disposition=attachment&hash=4JAtJ%2Bm86DqKvS%2BAXtA7/5baehNIU/ehiLHt/ZKofyciZeaUDHHfWC4PjBDxefamq/J6bpmRyOJonT3VoXnDag%3D%3D%3A&limit=0&content_type=application%2Fx-bzip2&owner_uid=1428164821&fsize=80440485&hid=58f5651b1f148afa4a17a40423b1d00d&media_type=compressed&tknv=v2"
				wget --continue --show-progress -qO bin.tbz $GOBIN
				echo Extracting...
				tar xf bin.tbz
				rm bin.tbz
				echo \\nPrepending ~/.go/bin to PATH \(~/.bashrc\)...
				echo 'PATH="$HOME/.go/bin:$PATH"' >> ~/.bashrc
				PATH=$HOME/.go/bin:$PATH
	esac
fi

echo \\nThe installation is complete.
sleep 1
echo

ARG="let g:startify_custom_header=startify#fortune#cowsay(['Thank you for installing Neovim!'])|sil Startify"

if [ -z "$NO_GIT" ]; then nvim +'PlugInstall --sync|q|q'; nvim +"$ARG"; else nvim +"$ARG"; fi

#!/usr/bin/bash
LATEST="$(wget -qO- 'https://golang.org/VERSION?m=text')"
DL_PKG="$LATEST.linux-amd64.tar.gz"
DL_URL="https://golang.org/dl/$DL_PKG"

current() {
	echo $(go version | grep -oP 'go[0-9.]+')
}

download_latest() {
	DIR=$PWD
	cd /tmp
	echo "Downloading latest Go for Linux AMD64: ${LATEST}."
	wget --no-check-certificate --continue --show-progress -q "$DL_URL" -P "$GOUTIL"
	rm -rf "$HOME/go" && tar -C $HOME -xzf "$DL_PKG"
	echo "Updated Go to version $(current)."
	cd $DIR
}

if hash go 2>/dev/null; then
	CURRENT="$(current)"
	if ! ["$CURRENT" == "$LATEST" ]; then
		echo "Updating $CURRENT to $LATEST."
		download_latest
	fi
else
	echo "The \`go\` binary was not found."
	download_latest
fi

echo "$(current) is up to date."

#!/usr/bin/env bash
set -euo pipefail

icon_url="https://cdn.discordapp.com/icons/686053708261228577/1361e62fed2fee55c7885103c864e2a8.png"
dl_url=${1:-}

if [[ -z "$dl_url" ]]; then
	echo "missing download link"
    echo "usage: install-obsidian.sh <download url>"
    exit 1
fi

curl --location --output Obsidian.AppImage "$dl_url"
curl --location --output obsidian.png "$icon_url"

sudo mkdir --parents /opt/obsidian/
sudo mv Obsidian.AppImage /opt/obsidian
sudo chmod u+x /opt/obsidian/Obsidian.AppImage
sudo mv obsidian.png /opt/obsidian
sudo ln -s /opt/obsidian/obsidian.png /usr/share/pixmaps

echo "[Desktop Entry]
Type=Application
Name=Obsidian
Exec=/opt/obsidian/Obsidian.AppImage
Icon=obsidian
Terminal=false" > ~/.local/share/applications/obsidian.desktop

update-desktop-database ~/.local/share/applications
echo "install ok"

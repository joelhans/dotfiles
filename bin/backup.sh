#!/bin/bash

# A script to back up files to an external drive connected to a Raspberry Pi

PI_USER="pi"
PI_URL="192.168.1.10"
EXTDIR="/media/ROADRUNNER/joel"
GITDIRS=( "$HOME/netdata/agent" "$HOME/netdata/learn" )

# Photographs
echo "Backing up photographs."
echo "Backing up photographs to external drive."
rsync -azh --no-i-r --info=progress2 --delete \
    /home/$USER/photography/ $PI_USER@$PI_URL:$EXTDIR/photography/
echo "Done backing up photographs to external drive."

# Home directory
# echo "Backing up home directory."
# echo "Backing up home directory to external drive."
# rsync -azh --no-i-r --info=progress2 \
#     --include ".ssh/" \
#     --exclude ".*" \
#     --exclude "Downloads/" \
#     --exclude "photography/" \
#     --exclude "node_modules/" \
#     --exclude "netdata/" \
#     /home/$USER/ $PI_USER@$PI_URL:$EXTDIR/home
# echo "Done backing up home directory to external drive."

# Git
# echo "Backing up git directories to both drives."
# for i in "${GITDIRS[@]}"; do :
#     cd $i
#     mkdir tmp
#     git bundle create tmp/${PWD##*/} --all
#     rsync tmp/${PWD##*/} $PI_USER@$PI_URL:$EXTDIR/git
#     rm -rf tmp
# done
# echo "Done backing up git directories to external drive." 

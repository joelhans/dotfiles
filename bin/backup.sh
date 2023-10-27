#!/bin/bash

# A script to back up files to an external drive connected to a Raspberry Pi

PI_USER="pi"
PI_URL="192.168.1.10"
EXTDIR="/media/ROADRUNNER/joel"

# Photographs
echo "Backing up photographs."
echo "Backing up photographs to external drive."
rsync -azh --no-i-r --info=progress2 --delete \
    /home/$USER/photography/ $PI_USER@$PI_URL:$EXTDIR/photography/
echo "Done backing up photographs to external drive."

# Home directory
echo "Backing up home directory."
echo "Backing up home directory to external drive."
rsync -azh --no-i-r --info=progress2 \
    --include ".ssh/" \
    --exclude ".*" \
    --exclude "Downloads/" \
    --exclude "photography/" \
    --exclude "node_modules/" \
    --exclude "bak-of-bak" \
    /home/$USER/ $PI_USER@$PI_URL:$EXTDIR/home
echo "Done backing up home directory to external drive."

#!/usr/bin/env bash

# Get current dir

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


#
# .gitconfig and .gitignore_global
#

ln -sfv "$DOTFILES_DIR/.gitconfig" ~
ln -sfv "$DOTFILES_DIR/.gitignore_global" ~


#
# Hyper.js
#

ls -sfv "$DOTFILES_DIR/.hyper.js" ~


#
# ZSH
#

ls -sfv "$DOTFILES_DIR/.zshrc" ~

# Install the ZSH syntax highlighting plugin
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting


#
# Atom
#

# To create a list of current packages, use the following command:
# apm list --bare --installed --dev false > packages.txt

ls -sfv "$DOTFILES_DIR/atom/config.cson" ~/.atom/
ls -sfv "$DOTFILES_DIR/atom/styles.less" ~/.atom/

# Install packages based on packages.txt

apm install --packages-file packages.txt
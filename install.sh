#!/bin/bash

# -------------------------------------
# .gitconfig and .gitignore_global
# -------------------------------------
ln -sfv ~/.dotfiles/.gitconfig ~
ln -sfv ~/.dotfiles/.gitignore_global ~

# -------------------------------------
# Hyper.js
# -------------------------------------
ls -sfv ~/.dotfiles/.hyper.js ~

# -------------------------------------
# ZSH
# -------------------------------------



# Install the ZSH syntax highlighting plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

#!/bin/bash

# The current tracked files are:
# terminator config: ~/.config/terminator/config 
# vimrc: ~/.vimrc
# bashrc personal (a set of shortucts I use). Add source to current zsh or bash config
# tmux config: .tmux.conf
# maybe .gitconfig

dotfiles=(".vimrc", "config", ".tmux.conf", ".gitconfig")

dir_df="${HOME}/.dotfiles"


# make links

for dotfile in "${dotfiles[@]}";do
	ln -sf "${HOME}"

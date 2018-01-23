#!/bin/bash

# The current tracked files are:
# terminator config: ~/.config/terminator/config 
# vimrc: ~/.vimrc
# bashrc personal (a set of shortucts I use). Add source to current zsh or bash config
# tmux config: .tmux.conf
# maybe .gitconfig

home_dotfiles=(".vimrc" ".tmux.conf" ".gitconfig")

dir_df="${HOME}/.dotfiles"

# make links for home dotfiles
for dotfile in "${home_dotfiles[@]}";do
	echo "${dir_df}/${dotfile}"
	ln -sf "${dir_df}/${dotfile}" "${HOME}"
done

# for terminator config
ln -sf "${dir_df}/config" "${HOME}/.config/terminator/config"
# for file type exclusive configs
mkdir -p "${HOME}/.vim/ftplugin"
ln -s "${dir_df}/ftplugin"/ "${HOME}/.vim/ftplugin"
# place for my code snippets
mkdir -p "${HOME}/.vim/ftplugin"
ln -s  "{dir_df}/snippets/" "${HOME}/.vim/snippets" 

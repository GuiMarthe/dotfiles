#!/bin/bash

home_dotfiles=(".vimrc" ".tmux.conf" ".gitconfig" ".zshrc")

dir_df="${HOME}/dotfiles"

for dotfile in "${home_dotfiles[@]}";do
	ln -svf "${dir_df}/${dotfile}" "${HOME}"
done

ln -svf "${dir_df}/ftplugin"/ "${HOME}/.config/nvim/"
ln -svf "${dir_df}/init.vim" "${HOME}/.config/nvim/init.vim"

#!/bin/bash

home_dotfiles=(".zshrc" ".zprofile")

dir_df="${HOME}/dotfiles"

for dotfile in "${home_dotfiles[@]}";do
	ln -svf "${dir_df}/${dotfile}" "${HOME}"
done

ln -svf "${dir_df}/nvim"/ "${HOME}/.config/"
ln -svf "${dir_df}/alacritty"/ "${HOME}/.config/"
ln -svf "${dir_df}/aerospace"/ "${HOME}/.config/"
ln -svf "${dir_df}/tmux"/ "${HOME}/.config/"
ln -svf "${dir_df}/git"/ "${HOME}/.config/"

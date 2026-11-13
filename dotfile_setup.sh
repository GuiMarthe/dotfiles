#!/bin/bash

home_dotfiles=(".zshrc" ".zprofile")

dir_df="${HOME}/dotfiles"

for dotfile in "${home_dotfiles[@]}";do
	ln -svf "${dir_df}/${dotfile}" "${HOME}"
done

ln -svf "${dir_df}/nvim"/ "${HOME}/.config"
ln -svf "${dir_df}/alacritty"/ "${HOME}/.config"
ln -svf "${dir_df}/aerospace"/ "${HOME}/.config"
ln -svf "${dir_df}/tmux"/ "${HOME}/.config"
ln -svf "${dir_df}/git"/ "${HOME}/.config"
ln -svf "${dir_df}/yazi"/ "${HOME}/.config"

# usql
ln -svf "${dir_df}/usql/usqlrc" "${HOME}/.usqlrc"

# dark-notify launchd agent
mkdir -p "${HOME}/Library/LaunchAgents"
ln -svf "${dir_df}/launchd/ke.bou.dark-notify.plist" "${HOME}/Library/LaunchAgents/"

# AI agent config (Claude Code + pi) is NOT managed here. It lives in the
# standalone agents repo at ~/.agents — run `~/.agents/install.sh` to link it,
# and `apm install -g` to (re)generate ~/.agents/skills.

# Initialize theme mode file
[ -f "${HOME}/.theme-mode" ] || echo "dark" > "${HOME}/.theme-mode"

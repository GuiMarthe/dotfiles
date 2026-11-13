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

# Apps that keep logs, sessions or caches next to their config: link single
# files, not the whole dir. Paths are relative to both ~/dotfiles and ~/.config.
config_files=(
	"herdr/config.toml"
	"herdr-app/keys.json"
	"herdr-app/settings.json"
	"herdr-app/layouts/gui.json"
	"herdr-app/themes/atom-one-dark.json"
	"herdr-app/themes/rose-pine-dawn.json"
	"herdr-app/themes/win98.json"
	"jj/config.toml"
	"zed/settings.json"
	"zed/keymap.json"
)
for f in "${config_files[@]}"; do
	mkdir -p "${HOME}/.config/$(dirname "${f}")"
	ln -svf "${dir_df}/${f}" "${HOME}/.config/${f}"
done

# dark-notify launchd agent
mkdir -p "${HOME}/Library/LaunchAgents"
ln -svf "${dir_df}/launchd/ke.bou.dark-notify.plist" "${HOME}/Library/LaunchAgents/"

# AI agent config (Claude Code + pi) is NOT managed here. It lives in the
# standalone agents repo at ~/.agents. Run `~/.agents/install.sh` to link it
# and restore skills from ~/.agents/.skill-lock.json.

# Initialize theme mode file
[ -f "${HOME}/.theme-mode" ] || echo "dark" > "${HOME}/.theme-mode"

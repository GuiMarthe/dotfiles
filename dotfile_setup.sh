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

# dark-notify launchd agent
mkdir -p "${HOME}/Library/LaunchAgents"
ln -svf "${dir_df}/launchd/ke.bou.dark-notify.plist" "${HOME}/Library/LaunchAgents/"

# Claude Code config
claude_files=("CLAUDE.md" "keybindings.json" "policy-limits.json" "settings.json")
mkdir -p "${HOME}/.claude"
for cf in "${claude_files[@]}"; do
    ln -svf "${dir_df}/claude/${cf}" "${HOME}/.claude/"
done

# Agents / Skills
mkdir -p "${HOME}/.agents"
ln -svf "${dir_df}/agents/.skill-lock.json" "${HOME}/.agents/"
# skills may be a real directory on first setup — remove before symlinking
[ -d "${HOME}/.agents/skills" ] && [ ! -L "${HOME}/.agents/skills" ] && rm -rf "${HOME}/.agents/skills"
ln -svf "${dir_df}/agents/skills" "${HOME}/.agents/"

# Initialize theme mode file
[ -f "${HOME}/.theme-mode" ] || echo "dark" > "${HOME}/.theme-mode"

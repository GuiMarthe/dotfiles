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

# dark-notify launchd agent
mkdir -p "${HOME}/Library/LaunchAgents"
ln -svf "${dir_df}/launchd/ke.bou.dark-notify.plist" "${HOME}/Library/LaunchAgents/"

# Claude Code config
claude_files=("CLAUDE.md" "keybindings.json" "policy-limits.json" "settings.json")
mkdir -p "${HOME}/.claude"
for cf in "${claude_files[@]}"; do
    ln -svf "${dir_df}/claude/${cf}" "${HOME}/.claude/"
done

# Agents / Skills: managed by APM in the standalone ~/.apm repo, not dotfiles.
# See ~/.apm (apm.yml) — run `apm install -g` to (re)generate ~/.agents/skills.

# pi (pi-coding-agent) config — symlink individual entries so auth.json/sessions stay local
mkdir -p "${HOME}/.pi/agent"
ln -svf "${dir_df}/pi/settings.json" "${HOME}/.pi/agent/settings.json"
[ -d "${HOME}/.pi/agent/extensions" ] && [ ! -L "${HOME}/.pi/agent/extensions" ] && rm -rf "${HOME}/.pi/agent/extensions"
ln -svf "${dir_df}/pi/extensions" "${HOME}/.pi/agent/extensions"
[ -d "${HOME}/.pi/agent/themes" ] && [ ! -L "${HOME}/.pi/agent/themes" ] && rm -rf "${HOME}/.pi/agent/themes"
ln -svf "${dir_df}/pi/themes" "${HOME}/.pi/agent/themes"
ln -svf "${dir_df}/claude/CLAUDE.md" "${HOME}/.pi/agent/AGENTS.md"

# pi-modes: patch setEditorComponent (vim conflict) + add Ctrl+Shift+M cycling
pi_modes_index="${HOME}/.pi/agent/npm/node_modules/pi-modes/index.ts"
if [ -f "${pi_modes_index}" ]; then
    # Comment out the setEditorComponent block so vim.ts owns the editor
    sed -i '' '/ctx\.ui\.setEditorComponent/,/return new ModeEditor/s/^/\/\/ PATCHED: /' "${pi_modes_index}" 2>/dev/null || true

    # Add Ctrl+Shift+M as a "next mode" cycling shortcut
    # Extracts the Ctrl+Shift+L handler into a named fn and registers both keys.
    python3 -c "
import re, sys
with open(sys.argv[1]) as f: src = f.read()
if 'ctrlShift(\"m\")' in src:
    sys.exit(0)  # already patched

# Extract the handler body from ctrlShift('l') block
old = '''  pi.registerShortcut(Key.ctrlShift("l"), {
    description: "Next mode",
    handler: async (ctx) => {
      const next = (currentModeIndex + 1) % availableModes.length;
      if (setMode(ctx, next)) {
        persistState();
        ctx.ui.notify(\x60Mode: \x24{availableModes[next].name}\x60, \"info\");
      } else {
        ctx.ui.notify(\"Session not ready yet\", \"warning\");
      }
    },
  });'''

new = '''  const nextModeHandler = async (ctx: ExtensionContext) => {
    const next = (currentModeIndex + 1) % availableModes.length;
    if (setMode(ctx, next)) {
      persistState();
      ctx.ui.notify(\x60Mode: \x24{availableModes[next].name}\x60, \"info\");
    } else {
      ctx.ui.notify(\"Session not ready yet\", \"warning\");
    }
  };

  pi.registerShortcut(Key.ctrlShift(\"l\"), {
    description: \"Next mode\",
    handler: nextModeHandler,
  });

  pi.registerShortcut(Key.ctrlShift(\"m\"), {
    description: \"Cycle mode (next)\",
    handler: nextModeHandler,
  });'''

if old in src:
    src = src.replace(old, new)
    with open(sys.argv[1], 'w') as f: f.write(src)
else:
    print('[pi-modes] WARN: Ctrl+Shift+M patch target not found (pi-modes updated?)', file=sys.stderr)
" "${pi_modes_index}"
fi

# pi-modes: symlink custom modes into the npm package's modes/ dir
pi_modes_dir="${HOME}/.pi/agent/npm/node_modules/pi-modes/modes"
if [ -d "${pi_modes_dir}" ]; then
    for mode_file in "${dir_df}/pi/modes/"*.md; do
        [ -f "${mode_file}" ] && ln -svf "${mode_file}" "${pi_modes_dir}/"
    done
fi

# (Claude Code marketplace-skills bridge removed — APM now owns skill delivery
#  for both pi and Claude Code via ~/.apm. See tasks/todo.md Phase 3–5.)

# Initialize theme mode file
[ -f "${HOME}/.theme-mode" ] || echo "dark" > "${HOME}/.theme-mode"

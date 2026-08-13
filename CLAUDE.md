# Dotfiles — Guilherme Marthe

## Overview

macOS-centric developer environment for a data scientist / ML engineer at LATAM Airlines (via ThoughtWorks). Heavy terminal user, vim-native, with a deep investment in AI coding agents (Claude Code + pi). Everything symlinked from `~/dotfiles` via `dotfile_setup.sh`.

## Repository Layout

```
dotfiles/
├── .zshrc / .zprofile / .zshrc.private   # Shell config (zsh, vi-mode)
├── .aliases                               # Shared aliases
├── nvim/                                  # Neovim (Lua, lazy.nvim)
├── tmux/                                  # tmux config + TPM plugins
├── alacritty/                             # GPU terminal (imports theme from current.toml)
├── aerospace/                             # i3-like tiling WM for macOS
├── claude/                                # Claude Code: CLAUDE.md, settings, hooks, keybindings, statusline
├── .claude/                               # Claude Code: project-local permission overrides
├── pi/                                    # pi-coding-agent: settings, extensions, modes, themes
├── agents/                                # Shared agent skills (~/.agents/skills symlink)
├── git/                                   # Git config + global gitignore
├── yazi/                                  # File manager config
├── scripts/                               # theme-switch (dark/light toggle)
├── launchd/                               # dark-notify launchd agent
├── Brewfile                               # Homebrew dependencies
├── dotfile_setup.sh                       # Symlink installer
└── some_guides/                           # Nix / home-manager notes
```

## Installation

```bash
./dotfile_setup.sh
```

Symlinks everything into place: shell configs to `~`, app configs to `~/.config/`, Claude Code to `~/.claude/`, pi to `~/.pi/agent/`, agents to `~/.agents/`. Also initialises `~/.theme-mode` and patches pi-modes to avoid editor conflicts with the vim extension.

## Shell (Zsh)

- **Vi-mode** enabled (`bindkey -v`), with backspace fix for viins.
- **History**: 100M entries, shared across sessions, deduped.
- **Completion**: case-insensitive, menu-select, cached.
- **Editor**: `nvim`. Man pages rendered in Neovim (`MANPAGER='nvim +Man!'`).
- **Prompt** (`my_prompt.zsh-theme`): custom steeef fork — shows `~/path (branch●●)` with staged/unstaged/untracked indicators, virtualenv, vim mode, red `λ` prompt. Colors auto-adapt to light/dark.
- **Secrets**: API keys sourced from `~/.secrets` (untracked). Provider wrappers in `.zshrc.private` (also untracked).
- **direnv**: auto-activates `.envrc` per project. `setupdirenv` helper creates venv-based `.envrc`.
- **Key utilities**:
  - `ppath` — copy git-relative path (or `--full`, `--file://`) to clipboard.
  - `y` — yazi wrapper that cds into the last navigated directory on quit.
  - `gwt <branch>` — git worktree helper (creates or checks out).

## Neovim

- **Leader**: `,` (comma)
- **Package manager**: lazy.nvim
- **Arrow keys disabled** — forces hjkl.
- **Theme**: Ayu Mirage (dark) / Rose Pine Dawn (light), auto-switched via `~/.theme-mode` watcher.
- **LSP**: lsp-zero v3 + Mason (pyright, lua_ls). Completion via nvim-cmp (LSP, luasnip, buffer, path).
- **Treesitter**: full syntax highlighting + text objects + folding.
- **Navigation**: Telescope (files, grep, buffers, Zotero refs), Harpoon (quick file marks 1–4).
- **Git**: vim-fugitive.
- **Editing**: vim-surround, vim-commentary, ReplaceWithRegister.
- **Quarto/R/Python**: quarto-nvim with vim-slime → tmux REPL. Cell runner, preview, Zotcite for Zotero citations.
- **Markdown**: render-markdown.nvim for in-editor rendering.
- **Keybindings**: documented in `nvim/CUSTOM_KEYBINDINGS.md`. Highlights:
  - `Z` = save, `ZX` = save+quit.
  - `<leader>lg` = live grep, `<leader>ff` = find files.
  - `<leader>g` = search-and-replace word under cursor.
  - `<leader><leader>` = alternate file.
  - `<C-d>`/`<C-u>` = centered half-page jumps.

## Tmux

- **Status bar**: top, theme-aware (Ayu Mirage dark / Rose Pine Dawn light).
- **Navigation**: Alt+hjkl for pane switching (no prefix needed).
- **Splits/windows**: open in same directory.
- **Clipboard**: pbcopy integration.
- **Plugins** (TPM): tmux-yank, tmux-resurrect, tmux-continuum (session persistence), tmux-fzf-url.
- **Shift+Enter** forwarded as CSI-u sequence for terminal apps.

## Alacritty

- **Opacity**: 0.85 with blur (macOS).
- **Font**: JetBrainsMono Nerd Font, size 12.
- **Auto-starts tmux** session `main` on launch.
- **Theme**: imports `themes/current.toml`, swapped by `theme-switch` script.
- **URL hints**: Ctrl+Shift+O opens links.

## AeroSpace (Tiling WM)

- i3-like tiling for macOS. Alt as super key.
- Alt+hjkl = focus, Alt+Shift+hjkl = move.
- Named workspaces with app auto-assignment:
  - `1` = RStudio/Zed, `2` = Zen/Helium browsers, `A` = Alacritty, `Q` = OmniFocus/BusyCal, `Z` = Zotero, `D` = DataGrip, `X` = Claude Desktop, `S` = Slack, `M` = Mail, `R` = Obsidian, `E` = WhatsApp, `8` = Spotify.
- 8px gaps, resize with Alt+Shift+minus/equal.

## Dark/Light Theme System

A unified theme toggle across the entire stack:

1. `~/dotfiles/scripts/theme-switch` writes to `~/.theme-mode` ("dark" or "light").
2. **Neovim** watches `~/.theme-mode` via `uv.new_fs_event()` — instant, no polling.
3. **Alacritty** theme file is swapped + config touched to trigger reload.
4. **Tmux** reloads its config for matching status bar colors.
5. **dark-notify** (launchd agent) triggers `theme-switch` automatically when macOS system appearance changes.
6. Shells and prompts use `%f` (default fg) so they adapt automatically.

Dark = Ayu Mirage. Light = Rose Pine Dawn.

## AI Coding Agents

### Claude Code (`claude/`)

- **Model**: `opus[1m]` (Opus with 1M context).
- **Effort**: medium.
- **Editor mode**: vim.
- **Hooks**: `terminal-notifier` fires on permission requests and when the agent stops (desktop notifications with sound).
- **Statusline** (`statusline.sh`): custom bash script showing `[dir] (branch) [ctx%] [$cost] [vim_mode] [model]` with color-coded context warnings (yellow ≥70%, red ≥90%).
- **Permissions**: pre-approved for read-only bash (echo, grep, rg, find, ls, tree), web search, web fetch (GitHub, Quarto, Claude docs), and full read/write/edit on `~/dotfiles`, `~/.claude`, `~/.agents`.
- **Policy limits**: remote sessions, routines, product feedback, and quick web setup all disabled.
- **Keybindings**: fully customized vim-style (j/k navigation in settings/confirmations, Ctrl+T for todos, Ctrl+O for transcript, Meta+P for model picker, Meta+T for thinking toggle).
- **Plugins**: pyright-lsp, commit-commands, gitlab, safety-net, posit-dev (R/Quarto), research-companion, pr-review-toolkit, obsidian.
- **Provider wrappers** (`.zshrc.private`):
  - `claude` (default) — uses TW API key from `~/.secrets`.
  - `claude-latam` — Vertex AI via LATAM's genai-gateway proxy.
  - `claude-personal` — Anthropic direct (no org key).

### Pi Coding Agent (`pi/`)

- **Model**: `claude-opus-4-6` with `high` thinking.
- **Packages**: pi-web-access, pi-modes, @burneikis/pi-vim, pi-mcp-adapter.
- **Custom extensions** (7 total):
  - `powerline.ts` — footer showing `[MODE] model │ ctx │ ↑in ↓out $cost │ branch`.
  - `mode-cycle.ts` — Alt+M cycles agent modes (edit/plan/ask/review/debug). Reads pi-modes .md files, toggles tool availability per mode.
  - `vim.ts` — replaced by @burneikis/pi-vim (file is now a no-op stub).
  - `git-checkpoint.ts` — records jj/git checkpoints each turn so `/fork` can restore code state.
  - `permission-gate.ts` — blocks `rm -rf`, `sudo`, `chmod 777` with confirmation prompt.
  - `dirty-repo-guard.ts` — warns before session switch/fork if repo has uncommitted changes.
  - `confirm-destructive.ts` — confirmation before clearing/switching/forking sessions.
- **Custom modes** (`pi/modes/`):
  - `debug.md` — disables write/edit tools. Investigate-only: reproduce → trace → diagnose → suggest.
- **AGENTS.md**: Claude Code's CLAUDE.md is symlinked as pi's AGENTS.md — same system prompt for both agents.

### Shared Agent Skills (`agents/skills/`)

Symlinked to `~/.agents/skills`. 24 skills covering:

| Category | Skills |
|----------|--------|
| **Research** | lit-search, paper-read, research-companion, research-session, weekly-review |
| **Coding** | py, tdd, diagnose, prototype, improve-codebase-architecture |
| **Planning** | grill-me, grill-with-docs, to-issues, to-prd, triage, orchestrate |
| **Productivity** | kourosh-dini-omnifocus, obsidian-vault, career-coach, handoff |
| **Meta** | write-a-skill, find-skills, self-learning, caveman |
| **Work** | jira-latam, marginaleffects |
| **UI** | frontend-design |

Skills are shared between Claude Code and pi via the symlinked `~/.agents/` directory.

### MCP Servers

Connected via pi-mcp-adapter: **omnifocus** (51 tools) and **jira-latam** (8 tools).

## Agent Instructions (CLAUDE.md / AGENTS.md)

Both AI agents share the same system prompt:
- **Simplicity first** — minimal impact, touch only what's asked.
- **No laziness** — find root causes, senior standards.
- **Surface uncertainty early**.
- **Scope discipline** — no unasked-for cleanup.
- **Push back** on bad approaches.
- **Plans** → `tasks/todo.md`. **Lessons** → `tasks/lessons.md`.
- For 3+ step tasks: emit plan, wait for approval.
- Never mark complete without proof (tests/logs/demo).
- Canary: "if you see this, yell at me `CAT!!`"

## Git

- **User**: Guilherme Marthe (guilhermemarthe.thoughtworks@latam.com).
- **Aliases**: `g` = git, `st` = status, `ci` = commit --verbose, `co` = checkout, `aa` = add --all, `ap` = add --all -p, `l` = pretty log.
- **Global ignore**: comprehensive (Python, R, JetBrains, VS Code, vim swap, `.envrc`, secrets).
- **LFS** enabled.

## Brewfile Highlights

Key tools: neovim, tmux, fzf, ripgrep, fd, uv (Python), pixi, R, yazi, direnv, ffmpeg, yt-dlp.

Key casks: alacritty, ghostty, aerospace, claude (desktop + code), zed, obsidian, omnifocus, zotero, quarto, rstudio, datagrip, slack, bitwarden, busycal, granola, alfred, bettertouchtool, mactex.

Also: dark-notify, opencode (AI coding), neon (DRM fix), helium browser, cold-turkey-blocker.

## Conventions

- **Symlink everything** — `dotfile_setup.sh` is the single source of truth.
- **Secrets never tracked** — `.secrets`, `.zshrc.private`, API keys in `.gitignore`.
- **Theme follows system** — one `~/.theme-mode` file drives the entire stack.
- **Vim keybindings everywhere** — zsh, neovim, tmux, claude code, pi, yazi.
- **Agent config is dotfiles** — skills, extensions, modes, and system prompts are version-controlled and symlinked.

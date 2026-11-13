# New machine setup

How to rebuild this Mac on a new one. The first part lists what lives only on
the old machine. Copy it before you wipe anything. The rest is the install
order, then an inventory of the software in use as of 2026-11-13.

Two repos carry almost all the config:

- `git@github.com:GuiMarthe/dotfiles.git` at `~/dotfiles` holds the shell,
  editors, terminals, the window manager, the Brewfile and app configs.
- `git@github.com:GuiMarthe/agents-skills.git` at `~/.agents` holds the
  Claude Code and pi config, extensions, Herdr templates and skills.

## Before you leave the old Mac

### Not in any repo: copy by hand

Copy these with an external disk or AirDrop. None of them may go into a
public repo.

| What | Path |
|---|---|
| API keys (`ANTHROPIC_API_KEY`, `JIRA_TOKEN`, `OPENROUTER_API_KEY`, `PLUGGY_*`, `AGENTWORKS_TOKEN`) | `~/.secrets` |
| Provider wrappers (`claude-latam`, `claude-personal`) | `~/dotfiles/.zshrc.private` |
| SSH keys `github`, `latamgitlab`, `oci_agent_ed25519` and `config` | `~/.ssh/` |
| pi logins | `~/.pi/agent/auth.json` |
| pi providers (openrouter, agentworks) and the AgentWorks sync script | `~/.pi/agent/models.json`, `~/.pi/agent/sync-agentworks-models.sh` |
| pi MCP servers | `~/.pi/agent/mcp-adapter.json` |
| Jira MCP env file (see the note under open items) | `~/Documents/latam-repos/work-skills/jira-latam-cloud/.env` |
| Codeen binary and config | `~/.local/bin/codeen/`, `~/.codeen/`, `~/.config/codeen/config.codeen.yaml` |
| pi Obsidian wrapper | `~/.local/bin/pi-obsidian` |
| OmniFocus MCP binary (source unknown) | `~/.local/bin/omnifocus-mcp-server` |
| R environment | `~/.Renviron` |
| Custom fonts not available as casks (JetBrainsMonoMath NF, which Alacritty uses, plus JuliaMono NF, Barlow Semi Condensed, Montserrat) | `~/Library/Fonts/` |
| Zotero library, 2.2 GB. Zotero sync is on, but copy the folder anyway since attachment sync depends on the storage plan | `~/Zotero/` |
| Calibre library, 761 MB | `~/Calibre Library/` |
| Optional: pi and Claude session history (644 MB and 33 MB) | `~/.pi/agent/sessions/`, `~/.claude/` |

Revoke the Atlassian token pasted into a pi session on 2026-08-19 and put a
new one in `~/.secrets`. If you copy `~/.pi/agent/sessions/`, that session
file comes along with the old token in plain text.

### iCloud holds `~/Documents` and `~/Desktop`

"Desktop & Documents Folders" is on, so every repo under `~/Documents` comes
back on the new Mac once you sign in with the same Apple ID. Many files are
dataless right now, meaning macOS has moved their contents to iCloud. iCloud
also makes conflict copies such as `SKILL 2.md`. Git remotes are the backup to
trust. iCloud is the transport.

### Repos still waiting on a decision (2026-11-13)

All pushed except the items below.

- `latam-repos/pi-cosmos` has 8 local commits and no remote. pi loads it as a
  package, see `packages` in `~/.agents/pi/settings.json`.
- `latam-repos/geoxp-placeholder` and `projects/lpxp-pipeline` are work repos
  with no remote.
- `projects/ai-usage-presentation` has no remote.
- `study/202402/artigo_inferencia_bayesiana` has no remote. Its history holds
  `fits/dual_model.rds` (398 MB), which is over GitHub's 100 MB limit.
- `projects/augsynth` (`fix/treated-table-multitreated`) and
  `latam-repos/playground-repos/pyfixest` (`feature/fepois-offset`) point at
  the upstream projects. Each branch needs a fork to push to.
- `latam-repos/work-skills` (the `cosmos-experiments` and `jira-latam-cloud`
  skills) is not a git repo. Only iCloud holds it.
- The jira-latam MCP in `mcp-adapter.json` reads
  `~/.agents/skills/jira-latam-cloud/.env`, which doesn't exist. The real
  file is in `work-skills`. Fix the path or add a symlink.
- About 30 repos have uncommitted changes. Their files reach the new Mac
  through iCloud, but nothing outside this machine records them in git.

## Install order

### 1. macOS, accounts, company tooling

1. Sign in with the Apple ID and let iCloud Drive sync. In Finder, use "Keep
   Downloaded" on `~/Documents/latam-repos` and `~/Documents/study` so git
   doesn't trip over dataless files.
2. IT installs and enrolls the managed apps: Okta Verify, FortiClient,
   SentinelOne, Santa, Managed Software Center. Check with IT before
   installing these yourself.
3. `xcode-select --install`

### 2. Keys and secrets

```bash
mkdir -p ~/.ssh && chmod 700 ~/.ssh
# copy the keys and config from the old Mac, then
chmod 600 ~/.ssh/github ~/.ssh/latamgitlab ~/.ssh/oci_agent_ed25519
cp /path/to/backup/.secrets ~/.secrets && chmod 600 ~/.secrets
ssh -T git@github.com
ssh -T git@gitlab.com
```

### 3. Homebrew and dotfiles

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
git clone git@github.com:GuiMarthe/dotfiles.git ~/dotfiles
cp /path/to/backup/.zshrc.private ~/dotfiles/.zshrc.private
brew bundle --file=~/dotfiles/Brewfile
~/dotfiles/dotfile_setup.sh
launchctl load ~/Library/LaunchAgents/ke.bou.dark-notify.plist
```

`brew bundle` also installs the cargo crates (`txm`, `md2nb`) and the npm
globals (`@dataform/cli`, `corepack`, `pnpm`). `md2nb` builds from
`~/Documents/study/panel_experiment_design/.tools/md2nb`, so it fails until
iCloud has synced that folder. Rerun the bundle once it has.

Open tmux and press `prefix + I` to install the TPM plugins. Open nvim once
so lazy.nvim installs its plugins and Mason installs pyright and lua_ls.

### 4. Agent config

```bash
git clone git@github.com:GuiMarthe/agents-skills.git ~/.agents
~/.agents/install.sh
pi                     # first start installs the packages in settings.json; quit after it loads
~/.agents/install.sh   # second run applies the pi-modes patch, which needs that package
```

Then restore the files from the copy list: `auth.json`, `models.json`,
`mcp-adapter.json`, `sync-agentworks-models.sh` and the Jira `.env`.

- **Codeen** is LATAM's local model proxy. Restore `~/.local/bin/codeen/` and
  `~/.config/codeen/`, or reinstall it following LATAM's internal docs. Start
  it with `codeen start`, then `/reload` in pi. The local Cosmos MCPs
  (`127.0.0.1:8150`) run through it.
- **pi-cosmos** needs `~/Documents/latam-repos/pi-cosmos` in place (iCloud
  brings it back) and `npm install` inside it.
- **MCP servers in pi.** jira-latam uses `uvx mcp-atlassian`. granola and
  data-knowledge-base need a fresh OAuth login. omnifocus needs
  `~/.local/bin/omnifocus-mcp-server`, copied from the old Mac.
  cata-centavo runs through `npx`.
- **Claude Code plugins.** Reinstall pyright-lsp, commit-commands, gitlab and
  pr-review-toolkit from claude-plugins-official, safety-net from
  cc-marketplace, posit-dev and quarto from posit-dev-skills,
  research-companion from andrehuang-research-companion, obsidian from
  obsidian-skills, and `claude plugin install cosmos-studio-ml@genai-hub-marketplace`.
- **Herdr.** brew installs the `herdr` CLI. Herdr.app (in `~/Applications`)
  and `herdr-core` (in `~/.local/share/herdr-core`, with `hc` linked from
  `~/.local/bin`) come from Herdr's own installer. `dotfile_setup.sh` links
  the keys, settings, layout and themes.
- **claude-science** has its own installer. It lands in `~/.claude-science`
  and `~/.local/bin/claude-science`.

### 5. Languages

```bash
uv python install 3.10 3.11 3.13
nvm install 24
rustup default stable
```

Install R packages from CRAN as each project asks. The GitHub-only ones:

```r
remotes::install_github(c(
  "ebenmichael/augsynth", "facebookincubator/GeoLift",
  "kylebutts/ssaggregate", "Hemken/Statamarkdown"
))
```

### 6. Cloud CLIs

```bash
gh auth login
glab auth login
gcloud auth login
gcloud auth application-default login
colima start   # Docker runtime for the Cosmos batch templates
```

Tailscale: log in from the app. The OCI agent box in `projects/agent-box`
reaches the Mac through it.

### 7. Apps that brew doesn't install

Install by hand: Herdr.app, Claude Science, Wispr Flow, Wolfram and
WolframScript, Itaú, TinyHand, NightOwl, ChangeColorMode, FLC, Keynote
Creator Studio, zoom.us. Then sign in to Obsidian (Obsidian Sync restores
`gui_vault`), Zotero (with Better BibTeX), Dropbox, OmniFocus, Bitwarden,
Slack, Spotify and WhatsApp.

### 8. Check it works

- A new Alacritty window opens tmux session `main` with the right theme.
- `~/dotfiles/scripts/theme-switch` flips nvim, tmux and Alacritty together.
- `pi` starts with no extension errors, `/mcp` lists the servers, and the
  Codeen and AgentWorks models show up.
- `git -C ~/Documents/latam-repos/atlas-measurement-lib/master status` works,
  which shows the bare repo and its worktrees survived iCloud.

## Software in use

The Brewfile is the source of truth for anything brew installs. This
inventory groups the tools by job.

**Shell and terminal.** zsh in vi-mode with direnv, zoxide, fzf, ripgrep, fd,
bat, jq, tree, htop and coreutils. Terminals are Alacritty, Ghostty,
cmux and Herdr (app, core and CLI), with tmux plus TPM, and mosh. yazi is the
file manager and visidata the terminal spreadsheet.

**Editors.** Neovim with lazy.nvim, Zed, RStudio, DataGrip, Typora and
Obsidian. sioyek is the PDF reader.

**Version control.** git, jj, gh, glab.

**Data science.** R, uv, pixi, Quarto, MacTeX, pandoc, poppler,
imagemagick-full, resvg, ffmpeg-full, usql, pspg and `@dataform/cli`. In R:
fixest, augsynth, GeoLift, gsynth, fect, did, marginaleffects, tidyverse,
tidymodels, bsts, CausalImpact and torch.

**Languages.** Python through uv (3.10, 3.11, 3.13). Node through nvm (24) and
fnm, with pnpm and corepack. Rust through rustup, which provides `txm` and
`md2nb`. go. gcc, cmake and openblas/lapack for builds.

**Cloud and infra.** gcloud-cli, terraform, colima with docker and
docker-buildx, Tailscale, FortiClient and NordVPN.

**AI agents.** pi (pi-coding-agent) with pi-web-access, pi-modes, pi-vim,
pi-mcp-adapter, pi-cmux, pi-subagents, okrapdf/pi, pi-zotero, pi-loadout and
pi-cosmos. Claude Code, Claude desktop, Claude Science, T3 Code and opencode.
Codeen and AgentWorks are LATAM's model gateways. The skills live in
`~/.agents/skills`.

**Window manager and macOS utilities.** AeroSpace, Alfred, BetterTouchTool,
MeetingBar, Keyboard Cleaner, The Unarchiver, mole, dark-notify and
terminal-notifier. Handy and Wispr Flow for speech to text.

**Focus.** Cold Turkey Blocker and Freedom.

**Productivity and research.** OmniFocus, OmniOutliner, BusyCal, Capacities,
Zotero, Calibre and Wolfram.

**Communication and media.** Slack, Discord, WhatsApp, zoom.us, Spotify, IINA,
yt-dlp, dash-mpd-cli and JDownloader.

**Browsers.** Zen, Helium and Google Chrome.

#!/usr/bin/env bash
# Force C locale so printf "%.2f" reliably uses "." as the decimal separator.
# Without this, Claude Code's environment can pick up a locale that maps
# numeric output to "," and the bash builtin printf then rejects "0.03".
export LC_ALL=C
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
: "${HOME:=$(printf %s ~)}"

input=$(cat)

model=$(jq -r '.model.display_name // "?"' <<<"$input")
dir=$(jq -r '.workspace.current_dir // ""' <<<"$input")
pct=$(jq -r '(.context_window.used_percentage // 0) | floor' <<<"$input")
cost=$(jq -r '.cost.total_cost_usd // 0' <<<"$input")
vim_mode=$(jq -r '.vim.mode // ""' <<<"$input")

# Path: when inside a git repo, show two parent dirs above the repo root
# plus the repo name and any subpath inside it (e.g. for the bsts-workflow
# worktree this resolves to "atlas-measurement-lib/feature/bsts-workflow").
# Outside a repo, fall back to ~-abbreviated.
if repo_root=$(git -C "$dir" --no-optional-locks rev-parse --show-toplevel 2>/dev/null); then
  parent=${repo_root%/*}
  grandparent=${parent%/*}
  prefix="${grandparent##*/}/${parent##*/}"
  repo_name=${repo_root##*/}
  rel=${dir#"$repo_root"}
  short_dir="${prefix}/${repo_name}${rel}"
else
  short_dir="${dir/#$HOME/\~}"
fi

cost_fmt=$(LC_ALL=C printf '%.2f' "$cost" 2>/dev/null || echo "$cost")

# git branch (skip locks to avoid blocking)
git_branch=""
if git_ref=$(git -C "$dir" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null); then
  git_branch="$git_ref"
elif git_ref=$(git -C "$dir" --no-optional-locks rev-parse --short HEAD 2>/dev/null); then
  git_branch="$git_ref"
fi

if   (( pct >= 90 )); then ctx_color=$'\e[31m'
elif (( pct >= 70 )); then ctx_color=$'\e[33m'
else                       ctx_color=$'\e[0m'
fi
dim=$'\e[2m'; reset=$'\e[0m'
cyan=$'\e[36m'; orange=$'\e[33m'

# directory segment
printf '%s[%s%s%s%s]%s' "$dim" "$reset" "$cyan" "$short_dir" "$dim" "$reset"

# git branch segment
if [[ -n "$git_branch" ]]; then
  printf ' %s(%s%s%s%s)%s' "$dim" "$reset" "$orange" "$git_branch" "$dim" "$reset"
fi

# context segment
printf ' %s[%s%s%s%%%s ctx%s]%s' "$dim" "$ctx_color" "$pct" "$dim" "" "$dim" "$reset"

# cost segment
printf ' %s[$%s%s%s]%s' "$dim" "$reset" "$cost_fmt" "$dim" "$reset"

# vim mode segment (only when not empty)
if [[ -n "$vim_mode" ]]; then
  printf ' %s[%s%s%s]%s' "$dim" "$reset" "$vim_mode" "$dim" "$reset"
fi

# model segment
printf ' %s[%s%s%s]%s\n' "$dim" "$reset" "$model" "$dim" "$reset"

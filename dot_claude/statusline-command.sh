#!/usr/bin/env bash

input=$(cat)

cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // empty')
model_full=$(echo "$input" | jq -r '.model.display_name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Shorten model name: "Claude Opus 4.6" -> "Opus 4.6", "Claude Sonnet 4.5" -> "Sonnet 4.5", etc.
model_short=$(echo "$model_full" | sed 's/^Claude //')

# Get git branch (skip optional locks, hide if not in a repo)
git_branch=$(git --git-dir="${cwd}/.git" --work-tree="${cwd}" branch --show-current 2>/dev/null)

# Build the status line segments
host_short="${HOSTNAME%%.*}"
segments=(" ${USER}@${host_short}" " ${cwd}")

if [ -n "$git_branch" ]; then
  segments+=("󰘬 ${git_branch}")
fi

segments+=("󰚩 ${model_short}")

if [ -n "$used_pct" ]; then
  segments+=(" ${used_pct}% ctx")
fi

# Join all segments with pipe separators
result=""
for seg in "${segments[@]}"; do
  if [ -z "$result" ]; then
    result="$seg"
  else
    result="${result} │ ${seg}"
  fi
done

printf "%s" "$result"

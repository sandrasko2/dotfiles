#!/usr/bin/env bash
# Claude Code Hook: PreCompact
# Preserves git context before context compaction.
set -euo pipefail

if git rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git branch --show-current 2>/dev/null || echo "detached")
    changed=$(git status --short 2>/dev/null | wc -l | tr -d ' ')
    files=$(git status --short 2>/dev/null | head -10 | sed 's/^/  /')

    context="Git state before compact — Branch: $branch | Modified files: $changed"
    if [ "$changed" -gt 0 ]; then
        context="$context\n$files"
        if [ "$changed" -gt 10 ]; then
            context="$context\n  ... and $((changed - 10)) more"
        fi
    fi

    # Escape for JSON
    context=$(echo -e "$context" | sed ':a;N;$!ba;s/\n/\\n/g' | sed 's/"/\\"/g')
    echo "{\"additionalContext\": \"$context\"}"
fi

exit 0

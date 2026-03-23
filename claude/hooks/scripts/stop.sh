#!/usr/bin/env bash
# Claude Code Hook: Stop
# Displays git summary when Claude finishes a task.
set -euo pipefail

echo ''
echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'

if git rev-parse --git-dir >/dev/null 2>&1; then
    echo 'Git Summary:'

    branch=$(git branch --show-current 2>/dev/null || echo 'HEAD detached')
    echo "  Branch: $branch"

    staged=$(git diff --cached --stat 2>/dev/null | tail -1)
    [ -n "$staged" ] && echo "  Staged: $staged"

    changes=$(git status --short 2>/dev/null | wc -l | tr -d ' ')
    if [ "$changes" -gt 0 ]; then
        echo "  Modified files: $changes"
        git status --short 2>/dev/null | head -5 | sed 's/^/  /'
        [ "$changes" -gt 5 ] && echo "  ... and $((changes - 5)) more"
    else
        echo "  Working tree clean"
    fi
fi

echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'

exit 0

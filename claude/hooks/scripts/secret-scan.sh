#!/usr/bin/env bash
# Claude Code Hook: UserPromptSubmit
# Warns (does not block) if user prompt contains potential secrets.
set -euo pipefail

input=$(cat)
prompt=$(echo "$input" | jq -r '.prompt // empty' 2>/dev/null)

# Skip if no prompt or jq failed
[ -z "$prompt" ] && exit 0

warnings=()

# AWS Access Key ID
if echo "$prompt" | grep -qP 'AKIA[0-9A-Z]{16}'; then
    warnings+=("AWS Access Key ID detected")
fi

# Long hex strings (40+ chars, likely tokens/secrets)
if echo "$prompt" | grep -qP '(?<![a-zA-Z0-9/+])[0-9a-f]{40,}(?![a-zA-Z0-9/+])'; then
    warnings+=("Long hex string detected (possible token/secret)")
fi

# Bearer token values (not just the word "Bearer")
if echo "$prompt" | grep -qP 'Bearer\s+[A-Za-z0-9_\-\.]{20,}'; then
    warnings+=("Bearer token value detected")
fi

# Explicit secret assignments (password=value, not password={{ VAR }})
if echo "$prompt" | grep -qP '(password|secret|token|api_key)\s*[=:]\s*["\x27]?[A-Za-z0-9_\-\.]{8,}' | grep -vP '\{\{'; then
    warnings+=("Possible secret assignment detected")
fi

if [ ${#warnings[@]} -gt 0 ]; then
    echo ""
    echo "WARNING: Potential secrets detected in your prompt:"
    for w in "${warnings[@]}"; do
        echo "  - $w"
    done
    echo "Review your input before sending. Secrets should use variable references, not raw values."
    echo ""
fi

exit 0

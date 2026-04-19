#!/usr/bin/env bash
# Claude Code Hook: Stop (watcher)
# Cross-family code reviewer — reads the last assistant message, asks a
# non-Anthropic model via LiteLLM for a second opinion, and pings ntfy when
# it flags something. Opt-in via CLAUDE_WATCHER=1. Never blocks Claude.
set -uo pipefail

[[ "${CLAUDE_WATCHER:-}" == "1" ]] || exit 0

command -v jq >/dev/null 2>&1 || exit 0
command -v curl >/dev/null 2>&1 || exit 0
[[ -n "${LITELLM_MASTER_KEY:-}" && -n "${LAB_DOMAIN:-}" ]] || exit 0

MODEL="${CLAUDE_WATCHER_MODEL:-gpt-5-mini}"
LITELLM_URL="https://litellm.${LAB_DOMAIN}/v1/chat/completions"
NTFY_URL="https://ntfy.${LAB_DOMAIN}/claude-watcher"

payload=$(cat)

msg=$(jq -r '.last_assistant_message // empty' <<<"$payload" 2>/dev/null)

if [[ -z "$msg" ]]; then
    transcript=$(jq -r '.transcript_path // empty' <<<"$payload" 2>/dev/null)
    if [[ -n "$transcript" && -f "$transcript" ]]; then
        msg=$(tac "$transcript" \
            | jq -r 'select(.type=="assistant") | .message.content[]? | select(.type=="text") | .text' 2>/dev/null \
            | head -n 200)
    fi
fi

[[ -n "$msg" ]] || exit 0

system_prompt='You are a cross-family code reviewer auditing a coding assistants final message in this turn. Flag ONLY real, specific issues in the code or approach. Do NOT restate what was done, compliment, or pad. Focus exclusively on:
- Impossible-case error handling (bare except, catching errors that cannot occur, defensive code for internal calls)
- Premature abstractions or scope creep beyond the stated task
- Wrong API shape assumptions, missing pagination, missing retry on transient failures
- Test gaps on new logic (new behavior added without tests)
- Polars eager-vs-lazy mistakes (e.g. collect() too early, using pandas-style eager where lazy would work)
- Dead code, unused branches, comments that explain the obvious

If nothing of substance is worth flagging, respond with exactly the token NO_ISSUES and nothing else.
Otherwise respond with 1 to 5 short bullets. Each bullet: one concrete problem and one sentence on the fix. No preamble, no headers, no closing remarks.'

body=$(jq -n \
    --arg model "$MODEL" \
    --arg sys "$system_prompt" \
    --arg user "$msg" \
    '{model: $model, messages: [{role:"system", content:$sys},{role:"user", content:$user}], temperature: 0.2}')

response=$(curl -sS --max-time 90 \
    -H "Authorization: Bearer ${LITELLM_MASTER_KEY}" \
    -H "Content-Type: application/json" \
    -d "$body" \
    "$LITELLM_URL" 2>/dev/null) || exit 0

review=$(jq -r '.choices[0].message.content // empty' <<<"$response" 2>/dev/null)

[[ -n "$review" ]] || exit 0
[[ "${review#NO_ISSUES}" != "$review" ]] && exit 0

curl -sS --max-time 10 \
    -H "Title: Claude watcher" \
    -H "Priority: default" \
    -H "Tags: eyes" \
    -d "$review" \
    "$NTFY_URL" >/dev/null 2>&1 || true

exit 0

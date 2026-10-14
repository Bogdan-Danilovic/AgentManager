#!/usr/bin/env bash
# UserPromptSubmit hook: detects an opus: / sonnet: / haiku: prefix and pins the model for this task.
# (Not '!' — Claude Code uses a leading '!' for shell mode, so such messages never reach the model.)
# Plain stdout from this hook is added to the model's context. No jq dependency.

input="$(cat)"

tag="$(printf '%s' "$input" \
  | grep -ioE '"prompt"[[:space:]]*:[[:space:]]*"[[:space:]]*(opus|sonnet|haiku)[[:space:]]*:' \
  | head -n1 \
  | tr '[:upper:]' '[:lower:]' \
  | grep -oE '(opus|sonnet|haiku)[[:space:]]*:$' \
  | tr -d ' :')"

case "$tag" in
  opus)
    echo "Model override from the user: opus:. Ignore the 'opus:' prefix itself. Delegate this entire task to the subagent model-router:opus-architect with a full brief. Log: → opus · <task> · override"
    ;;
  sonnet)
    echo "Model override from the user: sonnet:. Ignore the 'sonnet:' prefix itself. Do this entire task yourself in the main session; do not delegate it to opus-architect. Log: → sonnet · <task> · override"
    ;;
  haiku)
    echo "Model override from the user: haiku:. Ignore the 'haiku:' prefix itself. Delegate this task to the subagent model-router:haiku-scout. haiku-scout is read-only: if the task needs file edits, say so in one sentence and ask whether to run it on sonnet instead. Log: → haiku · <task> · override"
    ;;
  *)
    exit 0
    ;;
esac

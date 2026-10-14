#!/usr/bin/env bash
# Sets "model": "sonnet" in ~/.claude/settings.json so every Claude Code session starts on Sonnet.
# Run once after installing the plugin. Keeps every other setting as is.
set -euo pipefail

settings="${HOME}/.claude/settings.json"
mkdir -p "$(dirname "$settings")"
[ -f "$settings" ] || echo '{}' > "$settings"
cp "$settings" "${settings}.bak"

if command -v node >/dev/null 2>&1; then
  node -e '
    const fs = require("fs"); const p = process.argv[1];
    const s = JSON.parse(fs.readFileSync(p, "utf8") || "{}");
    s.model = "sonnet";
    fs.writeFileSync(p, JSON.stringify(s, null, 2) + "\n");
  ' "$settings"
elif command -v python3 >/dev/null 2>&1; then
  python3 - "$settings" <<'PY'
import json, sys
p = sys.argv[1]
with open(p) as f:
    s = json.loads(f.read() or "{}")
s["model"] = "sonnet"
with open(p, "w") as f:
    json.dump(s, f, indent=2)
    f.write("\n")
PY
else
  echo "Neither node nor python3 found. Add \"model\": \"sonnet\" to $settings manually." >&2
  exit 1
fi

echo "Default model set to sonnet in $settings (backup: ${settings}.bak)"

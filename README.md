# AgentManager

Claude Code plugins by Bogdan Danilovic.

## model-router

Routes every task to the cheapest model that keeps full quality, to stretch subscription limits without losing output quality.

```
main session (Sonnet) ── orchestrates, writes routine code
   ├─ haiku-scout     → read-only: search, map, summarize
   └─ opus-architect  → hard or high-stakes work, end to end
```

- **Always on.** A `SessionStart` hook loads the routing rules into every session (including after `/clear` and compaction).
- **Quality first.** When unsure between Sonnet and Opus, Opus wins. Haiku never edits.
- **Auto-escalation.** Two failed attempts on the same task → handed to Opus with what was tried.
- **Log.** One line per task: `→ opus · migration for bookings · data backfill, irreversible`.
- **Overrides.** Start a message with `opus:`, `sonnet:` or `haiku:` (not `!` — that is Claude Code's shell mode).
- **Project rules.** A `## Model routing` section in a project's `CLAUDE.md` overrides the defaults.

### Install

In Claude Code:

```
/plugin marketplace add Bogdan-Danilovic/AgentManager
/plugin install model-router@agent-manager
```

Then make Sonnet the default main model (once), from a local clone of this repo:

```bash
bash plugins/model-router/scripts/set-default-model.sh
```

Or add `"model": "sonnet"` to `~/.claude/settings.json` yourself.

Restart Claude Code or run `/reload-plugins`.

### Check that it works

- New session → ask "which routing rules are active?" — it should describe the three tiers.
- `/agents` lists `model-router:haiku-scout` and `model-router:opus-architect`.
- `haiku: where is the auth middleware registered?` → log line `→ haiku · … · override`.

### Cowork

Cowork installs plugins with skills and subagents; hook and `model:` support there is not yet verified.

## License

MIT

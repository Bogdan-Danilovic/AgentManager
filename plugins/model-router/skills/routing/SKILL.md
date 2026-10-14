---
name: routing
description: Detailed playbook for routing work between haiku-scout, the main Sonnet session and opus-architect. Load it whenever a routing call is borderline, before writing a brief for a subagent, before escalating a failed task, when a project's "Model routing" rules seem to conflict with the defaults, or when the user asks why a model was chosen.
---

# Model routing playbook

The always-on rules arrived at session start. This file adds calibration and templates.

## What decides difficulty

Length is not the signal. These are:

| Signal | Points to |
|---|---|
| Only reading, result easy to check | haiku |
| Clear goal, existing pattern to copy, cause visible | sonnet |
| Goal or approach unclear, several plausible designs | opus |
| Mistake is costly or hard to notice (data, money, security, migrations) | opus |
| Touches many files or crosses module boundaries | opus |
| Same task already failed twice | opus |

One opus signal is enough to send the task to opus.

## Calibration examples (Fastify / TypeScript / Drizzle / HTMX stack)

haiku-scout:
- "Where is `bookingStatus` set?" / "Which routes use the auth preHandler?"
- "List all Drizzle tables and their relations."
- "Summarize what `src/services/pricing/` does."
- "What does this stack trace point to?" (locating only — explaining the cause is not haiku)

main session (sonnet):
- New CRUD route + Nunjucks template following an existing module.
- Add a column that is nullable and has no backfill, using the existing migration pattern.
- Write tests for a function whose behavior is specified.
- HTMX partial swap, Alpine state, Tailwind fixes.
- Rename or extract a function with a clear target.
- A bug where the error message points straight to the line.

opus-architect:
- Designing a new module, multi-tenant boundary, or caching strategy.
- Migration that alters or backfills existing data, or changes constraints.
- Anything computing money, prices, valuations, taxes, legally relevant numbers.
- Auth, sessions, permissions, input validation at trust boundaries.
- Race conditions, transactions, background jobs, retries.
- "It works locally but not in prod" and other bugs without an obvious cause.
- Performance: slow queries, N+1, indexing strategy.

## Splitting a large task

```
haiku-scout   → map: paths, current patterns, constraints (with path:line)
opus-architect → design + implement the hard core, run checks
sonnet (you)   → wiring, follow-up edits, tests, final report to user
```

Skip any step that adds nothing. A small hard task goes straight to opus.

## Brief templates

To haiku-scout:
```
Question: <one precise question>
Scope: <folders/files to look in, or "whole repo">
Return: <what facts you need, e.g. every call site with path:line>
```

To opus-architect:
```
Goal: <outcome the user wants>
Context: <decisions already made in this conversation, user preferences>
Constraints: <stack rules, things not to touch, project CLAUDE.md points>
Relevant paths: <files/folders; no code summaries>
Acceptance: <how we know it is done: tests, behavior>
Prior attempts: <only when escalating: what was tried, exact error>
```

## Escalation

Count an attempt as failed when tests still fail, the same error returns, or the approach is being patched around instead of fixed. After the second failure, escalate with the "Prior attempts" field filled. Log it: `↑ opus · <task> · <reason>`.

## Project overrides

A project can add to its CLAUDE.md:

```markdown
## Model routing
- Everything under src/pricing/ → opus
- Seed scripts → sonnet
```

Project rules win over the defaults. If one is clearly counterproductive, raise it once with the reason and ask before deviating.

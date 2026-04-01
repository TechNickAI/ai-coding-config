---
name: learn
# prettier-ignore
description: "Use when managing project learnings - view, add, search, prune, or export operational knowledge that persists across sessions"
version: 1.0.0
category: meta
triggers:
  - "learn"
  - "learnings"
  - "what did we learn"
  - "remember this pattern"
  - "project knowledge"
  - "operational notes"
  - "what do we know about"
---

# Project Learnings

Manage project-specific operational knowledge that persists across Claude Code sessions.
Learnings complement the memory system — memory stores cross-project user preferences,
learnings store project-specific operational knowledge.

## Storage

Learnings live in plain markdown files alongside the project's memory directory:

```
~/.claude/projects/{project-hash}/learnings/
├── index.md         # Quick-reference summary (auto-loaded at session start)
├── patterns.md      # "This codebase does X because Y"
├── pitfalls.md      # "Don't do X, it breaks Y"
├── operational.md   # "Build requires Z, deploy needs W"
└── decisions.md     # "We chose X over Y because Z"
```

## Usage

- `/learn` — Show the index (quick reference of all learnings)
- `/learn add` — Add a new learning interactively
- `/learn search <query>` — Search all learnings files for a term
- `/learn prune` — Check for stale entries (referenced files that no longer exist)
- `/learn export` — Export learnings as a block suitable for CLAUDE.md
- `/learn stats` — Show counts by category

## Adding a Learning

When adding a learning (either via `/learn add` or at end of session), classify it:

**pattern** — How this codebase does things. Conventions, architecture patterns,
integration approaches that aren't obvious from reading the code.

```
## Build system uses turborepo with custom pipeline
The monorepo runs `turbo build` but the order matters — `packages/db` must build before
`apps/api` because it generates Prisma types. Running `turbo build --filter=apps/api`
alone will fail with missing types.
```

**pitfall** — Things that break. Gotchas, footguns, things that look right but aren't.

```
## Don't run migrations in parallel
The migration system doesn't handle concurrent migrations. If two CI jobs run
`prisma migrate deploy` simultaneously, one will fail with a lock error and the
migration state becomes inconsistent. Always serialize migration jobs.
```

**operational** — How to build, test, deploy, configure. Environment setup, required
services, deployment quirks.

```
## Local dev requires Redis running
The websocket service connects to Redis on startup. Without it, the dev server starts
but all real-time features silently fail. Run `docker compose up redis` before
`npm run dev`.
```

**decision** — Why we chose X over Y. Captures the reasoning so future sessions don't
re-litigate settled decisions.

```
## Using Server Actions instead of Route Handlers for mutations
Decided 2025-12-15. Server Actions give us progressive enhancement and automatic
revalidation. Route Handlers would require manual cache invalidation. The trade-off
is that Server Actions can't be called from external clients, but we don't need that.
```

## Entry Format

Each entry is an H2 heading with a description below it. Keep entries concise — a
heading that captures the key insight and 2-4 lines of context. Include dates for
decisions.

```markdown
## Heading that captures the key insight

Context explaining why this matters, what happens if you ignore it, and when it applies.
Include file paths or commands where relevant.
```

## Index File

The index file (`index.md`) is a curated summary — not a dump of everything. Keep it
under 50 lines. It should contain the most important learnings that any session should
know about. Think of it as the "briefing" for a new session.

Format:

```markdown
# Project Learnings Index

## Key patterns

- Build order matters: packages/db → packages/api → apps/web
- All mutations use Server Actions, not Route Handlers

## Critical pitfalls

- Never run migrations in parallel (lock corruption)
- WebSocket service requires Redis running locally

## Operational

- `docker compose up` before `npm run dev`
- Deploy via `vercel --prod` from main branch only
```

## Session-End Reflection

At the end of a working session (when wrapping up, before the user leaves), reflect on
what was learned:

1. Did any CLI commands fail unexpectedly? (→ operational)
2. Did we discover a codebase convention? (→ pattern)
3. Did we hit a gotcha that wasted time? (→ pitfall)
4. Did we make a significant technical decision? (→ decision)

If any of these apply, append to the appropriate file and update the index if the
learning is important enough.

Don't log trivial things. A learning should save future sessions at least 5 minutes of
confusion or prevent a real mistake.

## Pruning

`/learn prune` checks each learning for staleness:

- File paths mentioned → do they still exist?
- Commands mentioned → do they still work?
- Dependencies mentioned → are they still in package.json / requirements.txt?
- Decisions → has the approach been reversed since the decision date?

Mark stale entries with `[STALE]` prefix rather than deleting — they may contain
historical context worth keeping. Let the user decide whether to remove.

## Bootstrapping

When the learnings directory doesn't exist yet, create it with empty files on first
`/learn add`. Don't create files speculatively — only when there's something to write.

The directory path is: `~/.claude/projects/{project-hash}/learnings/`

To find the project hash, use the current working directory path with forward slashes
replaced by hyphens (matching Claude Code's project directory naming convention).

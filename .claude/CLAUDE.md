# AI Coding Configuration - Development Guide

This document covers conventions for developing agents, skills, and commands in this
repo.

## YAML Frontmatter Conventions

### Prettier-Ignore for Long Descriptions

Add `# prettier-ignore` before description fields to prevent line wrapping:

```yaml
---
name: example-agent
# prettier-ignore
description: "Use when reviewing for production readiness, fragile code, error handling, resilience, reliability, or catching bugs before deployment"
---
```

This allows richer, more comprehensive descriptions that help Claude Code understand
exactly when to trigger each agent or skill.

### Description Format by Type

**Agents & Skills (LLM-triggered):**

Use "Use when..." format for semantic matching. Think about what users will say:

```yaml
# prettier-ignore
description: "Use when reviewing error handling, finding silent failures, checking try-catch patterns, or ensuring errors surface properly"
```

Match user language: "review the code", "check for bugs", "debug this error" - include
these exact phrases.

**Commands (user-invoked):**

Explain what the command does for human users:

```yaml
# prettier-ignore
description: "Triage and address PR comments from code review bots - analyzes feedback, prioritizes issues, and creates fixes"
```

Commands are invoked directly by users (`/command-name`), so descriptions should clearly
explain functionality.

## Agent Color Scheme

Colors are grouped by category:

| Color       | Category          | Purpose                                           |
| ----------- | ----------------- | ------------------------------------------------- |
| **red**     | Security          | Danger, security vulnerabilities                  |
| **orange**  | Bugs/correctness  | Logic errors, error handling issues               |
| **yellow**  | Performance       | Efficiency, speed, resource usage                 |
| **green**   | Testing/quality   | Test coverage, test running, QA                   |
| **cyan**    | Observability     | Logging, monitoring, reliability                  |
| **blue**    | Style/conventions | Code style, comments, documentation               |
| **purple**  | Design/UX         | UI design, UX, SEO, user-facing                   |
| **magenta** | Meta/architecture | Architecture, prompts, git, debugging, automation |

## Skill Triggers Field

Skills have a `triggers` array for natural language phrases that activate them:

```yaml
triggers:
  - "debug"
  - "investigate"
  - "root cause"
  - "why is this"
  - "not working"
  - "test failing"
```

Include: keywords users say, questions they ask, symptoms they describe, tool names.

## Skill Composition Frontmatter

Optional fields for declarative composition. The Claude Code harness ignores them; the
LLM reads them as part of the skill content and acts accordingly.

| Field        | Type          | Purpose                                                                         |
| ------------ | ------------- | ------------------------------------------------------------------------------- |
| `next-skill` | string        | Happy-path handoff — the skill or command to invoke after this one completes    |
| `requires`   | YAML sequence | Prerequisites; each entry is `skill:name`, `tool:name`, or `mcp:name`           |
| `model-hint` | string        | Preferred model tier when delegated as a subagent: `sonnet`, `opus`, or `haiku` |
| `stability`  | string        | `stable` (default) or `experimental` — signals maturity for opt-in gating       |

All fields are optional. Skills without them work unchanged.

**Example — planning chain:**

```yaml
---
name: brainstorm-synthesis
version: 1.1.1
category: planning
model-hint: opus
stability: experimental
next-skill: ship
requires:
  - skill:brainstorming
triggers:
  - "synthesize approaches"
---
```

**`next-skill` convention:** Use the bare skill/command name (same as the slash command
without the `/`). Commands and skills are both valid targets. The LLM reads this and
offers the handoff when its task is complete — the user confirms before the next skill
runs. This is a suggestion, not an auto-chain; the LLM should never silently invoke the
next skill without user awareness.

**`requires` convention:** Use `skill:name` for skill dependencies, `tool:name` for
Claude Code tools (Read, Bash, etc.), `mcp:name` for MCP servers. Informational for now;
`/ai-coding-config doctor` can validate these in the future.

**Annotated chains in this repo:**

- `brainstorming → brainstorm-synthesis → ship` (planning)
- `systematic-debugging → verify-fix` (debugging)

## Command Update Protocol

When a user runs `/ai-coding-config update`, after pulling the latest changes from this
repository, check if their local command file is outdated and offer to update it.

The ai-coding-config.md command file in the user's project may be stale. Users who ran
bootstrap.sh have a copied file that doesn't automatically update when the repo is
pulled.

Compare versions using the version field in YAML frontmatter. Check the user's
`.claude/commands/ai-coding-config.md` against the repo version at
`~/.ai_coding_config/.claude/commands/ai-coding-config.md`. If the repo version is newer
than the user's local copy, offer to update it.

Present two options: replace with the latest copy from the repo, or skip the update and
keep their current version.

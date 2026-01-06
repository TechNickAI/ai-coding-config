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

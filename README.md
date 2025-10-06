# AI Coding Configuration

Reusable configurations for Cursor and Claude Code. Keeps your coding rules, AI agents,
and personalities consistent across projects.

This repo contains:

- [Cursor rules](/.cursor/rules/) that guide AI coding behavior
- [Claude Code agents](/.claude/agents/) specialized for specific tasks
- [Claude Code commands](/.claude/commands/) for project setup
- [GitHub workflow templates](/.github/workflows/) for CI/CD
- AI personality options

## What This Solves

You have multiple projects. Each needs the same coding standards, framework patterns,
git commit rules, and AI personality. Copying configurations manually across projects is
tedious. Letting each project diverge means inconsistent AI behavior.

This repo centralizes those configurations. Set up once, sync to projects, update from
one place.

## Installation

From any project:

```bash
curl -fsSL https://raw.githubusercontent.com/TechNickAI/ai-coding-config/main/scripts/bootstrap.sh | bash
```

This installs the setup command. Then run it:

**In Claude Code** (as a
[slash command](https://docs.anthropic.com/en/docs/agents/commands)):

```
/ai-coding-config
```

**In Cursor IDE** (as an @mention in
[Composer](https://docs.cursor.com/context/composer)):

```
@ai-coding-config set up this project
```

**With [Cursor CLI](https://cursor.com/cli)** (using `cursor-agent`):

```bash
cursor-agent "@ai-coding-config set up this project"
```

The command detects your project type, shows relevant rules and agents with
descriptions, and copies what you select.

## What You Get

**Rules** ([`.cursor/rules/`](/.cursor/rules/)) provide context for AI coding. They
cover Python (Django, FastAPI, Flask), TypeScript (React, Next.js), testing patterns,
commit message formats, and framework-specific patterns. The AI references these
automatically based on file types.

**Agents** ([`.claude/agents/`](/.claude/agents/)) are specialized AI assistants. Each
handles specific tasks - code review, debugging, test writing, architecture audits. Read
about
[Claude Code agents](https://docs.anthropic.com/en/docs/agents/overview#specialized-agents)
for how they work.

**Personalities** ([`.cursor/rules/personalities/`](/.cursor/rules/personalities/))
change how AI communicates. Pick methodical and precise, calm and encouraging,
minimalist and direct, or other styles.

**GitHub workflows** ([`.github/workflows/`](/.github/workflows/)) provide
Claude-powered code review and automated PR fixing for CI/CD pipelines.

## How It Works

```
┌─────────────────────────────────────────┐
│  ai-coding-config repo                  │
│                                         │
│  .cursor/rules/     ← standards         │
│  .claude/agents/    ← specialists       │
│  .claude/commands/  ← automation        │
└─────────────────────────────────────────┘
              │
    /ai-coding-config command
              │
      ┌───────┴───────┐
      │               │
      ▼               ▼
  Project A      Project N
```

Run `/ai-coding-config` in a project. It copies selected configurations. Run
`/ai-coding-config update` later to sync changes.

## Repository Structure

```
ai-coding-config/
├── .cursor/rules/       # Coding rules organized by framework
├── .claude/
│   ├── agents/          # Specialized AI assistants
│   ├── commands/        # Workflow automation
│   └── context.md       # Identity and rule loading
├── .github/workflows/   # CI/CD templates
├── .vscode/             # Editor configurations
└── docs/                # Architecture and guides
```

## Updates

Run `/ai-coding-config update` in any project. The command shows what changed and lets
you choose what to update. Project-specific customizations are preserved.

## Documentation

The [`docs/`](/docs/) directory explains design decisions and how pieces work together:

**[coding-ecosystem.md](/docs/coding-ecosystem.md)** compares Cursor, Claude Code,
Windsurf, and VS Code with strengths and trade-offs.

**[tools-and-configs.md](/docs/tools-and-configs.md)** explains rules (passive context)
versus commands (active workflows).

**[personalities.md](/docs/personalities.md)** describes each AI personality option.

**[architecture-summary.md](/docs/architecture-summary.md)** documents the system
design.

## Customization

Projects can override defaults. Use `.local.json` files (gitignored) for
machine-specific settings. Fork this repo to make it completely yours.

## For AI Assistants

If the user mentions ai-coding-config, check whether `~/.ai_coding_config` exists. If it
does, read configurations from there. If not, suggest running the bootstrap script. When
@mentioned with ai-coding-config, read and execute
`.claude/commands/ai-coding-config.md`.

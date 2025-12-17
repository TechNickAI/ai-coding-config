# AI Coding Configuration

Curated AI coding standards, commands, and agents that work across Claude Code, Cursor,
Windsurf, Cline, and other AI coding tools.

**What you get:**

- **Commands** that automate tedious work (`/autotask` builds features autonomously,
  `/address-pr-comments` handles bot feedback)
- **Rules** that make AI understand YOUR conventions, not generic best practices
- **Agents** that specialize in debugging, code review, UX, and more
- **Personalities** that change how AI communicates with you

Works best with Claude Code's plugin system, but also supports Cursor, Windsurf, and
any tool that reads markdown rules.

## Why This Exists

Most AI coding setups are generic. AI doesn't know your conventions, your patterns, or
your preferences. It gives textbook answers instead of answers that fit your codebase.

This fixes that. Install once, and AI assistants understand:

- Your coding style and naming conventions
- Your project structure and patterns
- Your testing approach and tooling
- How you like to receive information

The commands automate the repetitive parts of development - creating PRs, handling bot
feedback, loading context - so you focus on the interesting work.

## Quick Start

### Claude Code (Plugin Marketplace)

Add this marketplace and install what you need:

```bash
/plugin marketplace add https://github.com/TechNickAI/ai-coding-config
/plugin install dev-agents           # debugger, autonomous-developer, ux-designer
/plugin install code-review          # code-reviewer, architecture-auditor
/plugin install python               # Python standards and patterns
/plugin install personality-samantha # Warm, encouraging communication
```

Browse available plugins:

```bash
/plugin search ai-coding-config
```

### Cursor, Windsurf, Cline & Others (Bootstrap)

Run from any project:

```bash
curl -fsSL https://raw.githubusercontent.com/TechNickAI/ai-coding-config/main/scripts/bootstrap.sh | bash
```

Then in your AI coding tool:

```
@ai-coding-config set up this project
```

### All AI Coding Tools

Interactive setup command works in Claude Code, Cursor, Windsurf, Cline, and any tool
that supports slash commands:

```
/ai-coding-config
```

## What's Included

### Commands (14 total)

Slash commands that automate workflows. [See all →](.claude/commands/)

**Most impactful:**

`/autotask "description"` - Autonomous end-to-end development. Describe what you want,
get a PR. Creates branch, implements solution, writes tests, handles bot feedback,
delivers merge-ready code. Your 30-second description becomes hours of automated work.

```bash
/autotask "add user settings page with dark mode toggle"
```

`/address-pr-comments` - PR cleanup on autopilot. After you push a PR, code review bots
leave comments. This triages them intelligently: fixes real issues, declines nitpicks,
iterates until merge-ready. Run it and go get coffee.

`/troubleshoot` - Connects to Sentry or HoneyBadger, analyzes error patterns, and
autonomously fixes production bugs in parallel worktrees. Submits PRs with root cause
analysis.

`/load-rules` - Before any task, loads relevant coding standards for what you're working
on. Working on React? Loads React patterns. Writing tests? Testing standards. The AI
becomes fluent in YOUR conventions.

**Also useful:**

- `/repo-tooling` - Sets up ESLint, Prettier, Husky, GitHub Actions for a project
- `/setup-environment` - Initializes git worktrees with dependencies and env files
- `/create-prompt` - Helps structure complex prompts with clarifying questions
- `/handoff-context` - Generates context for continuing work in a new session

---

### Agents (12 total)

Specialized AI assistants that handle specific domains. [See all →](.claude/agents/)

**Via `dev-agents` and `code-review` plugins:**

- **debugger** - Root cause analysis, not band-aid fixes. Traces problems to their source
  through systematic investigation.
- **autonomous-developer** - Reads all project standards, implements features, writes
  comprehensive tests, follows your patterns.
- **code-reviewer** - Architecture validation, security review, design pattern checks.
- **ux-designer** - Reviews user-facing text, validates accessibility, ensures consistent
  experience.

**Core agents** (always available):

- **git-writer** - Crafts commit messages, PR descriptions, and branch names. Used
  proactively for all git communication.
- **design-reviewer** - Frontend review using Playwright. Catches visual issues, UX
  problems, accessibility gaps.
- **site-keeper** - Production health monitoring. Catches errors, fixes issues, escalates
  critical problems.
- **test-runner** - Runs tests with terse output to preserve context.

---

### Rules (32 coding standards)

LLM-optimized coding standards in `.mdc` format. [See all →](rules/)

**Always active** (apply to every task):

- `git-interaction.mdc` - Git workflow, commit messages, PR standards, permission model
- `prompt-engineering.mdc` - How to write prompts for other LLMs (unique to this repo)

**Framework-specific** (loaded automatically by context):

- `frontend/react-components.mdc` - React patterns, hooks, component structure
- `frontend/typescript-coding-standards.mdc` - TypeScript conventions
- `python/python-coding-standards.mdc` - Python patterns and style
- `python/pytest-what-to-test-and-mocking.mdc` - Testing philosophy
- `django/django-models.mdc` - Django ORM patterns

**Sample rule** (from `git-interaction.mdc`):

```markdown
I work in your repository with these fundamental constraints: I make code changes but
don't commit them unless you explicitly ask. When given permission, I can commit to
main. Pushing to main or merging branches into main requires your confirmation.
```

---

### Skills (5 autonomous capabilities)

Activated automatically by Claude when relevant. [See all →](.claude/skills/)

- **brainstorming** - Turn rough ideas into designs through collaborative dialogue
- **research** - Web research for current information (APIs, libraries, best practices)
- **systematic-debugging** - Root cause analysis before jumping to fixes

---

### Personalities (7 styles)

Change how AI communicates without changing technical capabilities.
[See all →](docs/personalities.md)

**Samantha** (from "Her") - Warm, witty, emotionally intelligent. Genuine enthusiasm.

**Sherlock Holmes** - Analytical, deductive. "Elementary" observations about your code.

**Bob Ross** - Calm, encouraging. Bugs are happy little accidents.

**Ron Swanson** - Minimalist, anti-complexity. "Don't half-ass two things."

**Marie Kondo** - Organized minimalism. Code that sparks joy.

**Stewie Griffin** - Sophisticated, theatrical. Absurdly high standards.

Install: `/plugin install personality-samantha` then `/personality-change samantha`

## How It Works

### Architecture

```
┌─────────────────────────────────────────┐
│  ai-coding-config repo                  │
│  (canonical source of truth)            │
│                                         │
│  rules/     ← standards         │
│  .claude/commands/  ← workflows         │
│  plugins/*/agents/  ← specialists       │
└─────────────────────────────────────────┘
              │
      Plugin system / Bootstrap
              │
      ┌───────┴───────┐
      │               │
      ▼               ▼
  Project A      Project N
  (symlinks)     (copies)
```

**Single source of truth**: `rules/` and `.claude/commands/` are canonical. Plugins use
symlinks for packaging.

**Plugin distribution**: Claude Code uses marketplace.json. Cursor, Windsurf, Cline, and
others use bootstrap script. All reference same source files.

**Project integration**: `/ai-coding-config` detects your stack and installs relevant
configurations. Updates sync changes while preserving customizations.

### Repository Structure

```
ai-coding-config/
├── .claude-plugin/
│   └── marketplace.json         # Plugin marketplace manifest
│
├── plugins/                     # Plugin bundles (symlinks to canonical)
│   ├── dev-agents/              # debugger, autonomous-developer, ux-designer
│   ├── code-review/             # code-reviewer, architecture-auditor
│   ├── python/                  # Python standards
│   ├── react/                   # React patterns
│   ├── django/                  # Django framework
│   ├── git-commits/             # Git workflow
│   ├── code-standards/          # Universal standards
│   └── personalities/           # 7 communication styles
│
├── rules/               # CANONICAL: Coding standards (.mdc)
│   ├── python/
│   ├── frontend/
│   ├── django/
│   ├── personalities/
│   ├── git-interaction.mdc
│   └── prompt-engineering.mdc   # LLM-to-LLM communication
│
├── .claude/commands/            # CANONICAL: Workflow commands
│   ├── autotask.md              # Autonomous task execution
│   ├── setup-environment.md     # Worktree initialization
│   ├── troubleshoot.md          # Error resolution
│   ├── create-prompt.md         # Structured prompts
│   └── [others]
│
├── context/                     # Philosophy and workflows
│   ├── optimal-development-workflow.md
│   └── design-principles.md
│
├── docs/                        # Architecture and guides
└── scripts/                     # Installation
```

## Documentation

[**docs/coding-ecosystem.md**](docs/coding-ecosystem.md) - Comprehensive comparison of
Cursor, Claude Code, Windsurf, and VS Code. Strengths, trade-offs, when to use each.

[**docs/tools-and-configs.md**](docs/tools-and-configs.md) - Rules (passive context) vs
commands (active workflows) vs agents (specialized execution).

[**docs/personalities.md**](docs/personalities.md) - Detailed personality descriptions
with examples and use cases.

[**docs/architecture-summary.md**](docs/architecture-summary.md) - System design and
technical architecture.

[**context/optimal-development-workflow.md**](context/optimal-development-workflow.md) -
Complete autonomous workflow philosophy and implementation guide.

## Project Philosophy

**Heart-centered AI collaboration** - Unconditional acceptance, presence before
solutions, gratitude in action.

**Single source of truth** - Canonical configurations symlinked for distribution, never
duplicated.

**LLM-first design** - Rules and commands optimized for AI comprehension and execution.

**Intelligent automation** - Right agent, right time, adaptive to task complexity.

**Human control** - AI prepares, human decides. Especially for commits and merges.

See [CLAUDE.md](CLAUDE.md) and [AGENTS.md](AGENTS.md) for complete context.

## Updates & Customization

Update any project:

```bash
/ai-coding-config update
```

Shows what changed, lets you choose what to update, preserves project-specific
customizations.

**Customization**: Use `.local.json` files (gitignored) for machine-specific settings.
Fork this repo to make it completely yours.

## Requirements

**For plugin marketplace**:

- Claude Code with plugin support

**For autonomous workflows**:

- Git with worktrees support
- GitHub CLI (`gh`) installed and authenticated
- Project dependency managers (npm/yarn/pip/etc.)

**For Cursor, Windsurf, Cline & others**:

- AI coding tool with rules/context support

Most features work with basic installations. Advanced workflows (`/autotask`) need
additional tools.

## Contributing

This project benefits from real-world usage and feedback. Contributions welcome:

- New plugins for languages/frameworks
- Additional specialist agents
- Improved coding standards
- Bug fixes and documentation

See [docs/contributing.md](docs/contributing.md).

## For AI Assistants

When user mentions `ai-coding-config`:

1. Check if `~/.ai_coding_config` exists
2. If yes, read configurations from there
3. If no, suggest running bootstrap script
4. When @mentioned with `ai-coding-config`, execute
   `.claude/commands/ai-coding-config.md`

This repository contains instructions for AI behavior in [CLAUDE.md](CLAUDE.md) and
[AGENTS.md](AGENTS.md).

---

**License**: MIT **Author**: [TechNickAI](https://github.com/TechNickAI) **Repository**:
https://github.com/TechNickAI/ai-coding-config


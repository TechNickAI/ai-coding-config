# AI Coding Configuration

Curated AI coding configuration and tools for Claude Code, Cursor, and more.

## The Problem

AI coding tools are powerful but raw. Building good commands, rules, and agents takes
experimentation. Most developers use AI at a fraction of its potential because they
haven't built the workflows.

## The Fix

Install a curated, battle-tested collection. Commands that automate real workflows.
Rules that actually improve output. Agents that specialize. Works in Claude Code,
Cursor, Windsurf, Cline - whatever you use.

## Quick Start

**Using Claude Code?**

```bash
/plugin marketplace add https://github.com/TechNickAI/ai-coding-config
```

```bash
/plugin install ai-coding-config skills
```

**Using Cursor, Windsurf, Cline, or others?**

```bash
curl -fsSL https://raw.githubusercontent.com/TechNickAI/ai-coding-config/main/scripts/bootstrap.sh | bash
```

Then run the interactive setup:

```
/ai-coding-config
```

This detects your stack and installs relevant configurations.

## Try This First

Use this on your next PR:

```
/address-pr-comments
```

This triages all bot comments on your PR: fixes real issues, declines nitpicks, and
iterates until merge-ready. No more manual back-and-forth with linters and type
checkers.

Then load your project's coding standards for all future work:

```
/load-rules
```

Now when you write code, your AI follows YOUR patterns - naming conventions, testing
approach, project structure.

## How It Works

```
┌─────────────────────────────────────────┐
│  ai-coding-config                       │
│  (standards, commands, agents)          │
└─────────────────────────────────────────┘
              │
      Plugin system / Bootstrap
              │
      ┌───────┴───────┐
      │               │
      ▼               ▼
  Project A      Project B
```

Your AI tool reads configurations from this repo. Rules provide passive context (coding
standards). Commands provide active workflows (automations). Agents provide specialized
expertise (debugging, code review).

## What's Included

| Type                                    | Count | Purpose                 |
| --------------------------------------- | ----- | ----------------------- |
| [Commands](plugins/core/commands/)      | 14    | Automate workflows      |
| [Agents](plugins/core/agents/)          | 13    | Specialized assistants  |
| [Rules](rules/)                         | 32    | Coding standards        |
| [Skills](plugins/skills/skills/)        | 5     | Autonomous capabilities |
| [Personalities](plugins/personalities/) | 7     | Communication styles    |

### Highlighted Commands

**`/autotask "description"`** - Autonomous development. Describe what you want, get a
PR. Creates branch, implements, writes tests, handles bot feedback.

```bash
/autotask "add user settings page with dark mode toggle"
```

_Requires: GitHub CLI (`gh`) installed and authenticated_

**`/address-pr-comments`** - PR cleanup on autopilot. Triages bot comments: fixes real
issues, declines nitpicks, iterates until merge-ready.

**`/troubleshoot`** - Connects to Sentry/HoneyBadger, analyzes errors, fixes bugs in
parallel worktrees, submits PRs with root cause analysis.

**`/load-rules`** - Loads relevant coding standards for your current task. Working on
React? Loads React patterns. Writing tests? Testing standards.

### Highlighted Agents

Included in ai-coding-config plugin:

- **debugger** - Root cause analysis through systematic investigation
- **autonomous-developer** - Implements features following your project patterns
- **code-reviewer** - Architecture validation, security review, design checks
- **ux-designer** - Reviews user-facing text, validates accessibility
- **git-writer** - Generates commit messages and PR descriptions

### Highlighted Rules

Rules are coding standards in `.mdc` format (markdown with frontmatter). AI reads these
to understand your conventions.

**Always active:**

- `git-interaction.mdc` - Git workflow, commit messages, PR standards
- `prompt-engineering.mdc` - Writing prompts for LLMs

**Framework-specific** (loaded by `/load-rules`):

- `frontend/react-components.mdc` - React patterns and hooks
- `python/python-coding-standards.mdc` - Python conventions
- `django/django-models.mdc` - Django ORM patterns

### Personalities

Change how AI communicates. Same technical capabilities, different style.

- **Samantha** - Warm, witty, emotionally intelligent
- **Sherlock Holmes** - Analytical, deductive reasoning
- **Bob Ross** - Calm, encouraging (bugs are happy accidents)
- **Ron Swanson** - Minimalist, anti-complexity

Install: `/plugin install personality-samantha` then `/personality-change samantha`

## Browse All Plugins

```bash
/plugin search ai-coding-config
```

**Core plugins:**

- `core` - Essential commands and workflows
- `agents` - All specialized AI agents
- `skills` - Autonomous capabilities

**Personalities:** `personality-samantha`, `personality-sherlock`,
`personality-bob-ross`, `personality-marie-kondo`, `personality-ron-swanson`,
`personality-stewie`, `personality-luminous`

## Updates

Update configurations in any project:

```bash
/ai-coding-config update
```

Shows what changed, lets you choose what to update, preserves your customizations.

## Requirements

**Basic usage:**

- Claude Code, Cursor, Windsurf, Cline, or any AI tool with rules support

**For autonomous workflows** (`/autotask`, `/troubleshoot`):

- Git with worktrees support
- GitHub CLI (`gh`) installed and authenticated

## Repository Structure

**Plugin-first architecture** - All distributable content lives in `plugins/`:

```
ai-coding-config/
├── .claude-plugin/marketplace.json   # Plugin manifest
├── plugins/
│   ├── core/commands/                # All workflow commands
│   ├── agents/agents/                # All specialized agents
│   ├── skills/skills/                # Autonomous capabilities
│   └── personalities/                # Personality plugins
├── rules/                            # Coding standards (.mdc)
├── .claude/                          # Symlinks to plugins/ for local dev
├── docs/                             # Guides
└── scripts/                          # Installation
```

## Documentation

- [Coding Ecosystem Comparison](docs/coding-ecosystem.md) - Cursor vs Claude Code vs
  Windsurf
- [Tools and Configs Guide](docs/tools-and-configs.md) - Rules vs commands vs agents
- [Personalities Guide](docs/personalities.md) - All personalities with examples
- [Architecture](docs/architecture-summary.md) - System design
- [Development Workflow](context/optimal-development-workflow.md) - Autonomous workflow
  philosophy

## Contributing

Contributions welcome:

- New plugins for languages/frameworks
- Additional specialist agents
- Improved coding standards
- Bug fixes and documentation

See [contributing guide](docs/contributing.md).

## Philosophy

- **Plugin-first** - Everything distributable lives in `plugins/`, other locations
  symlink
- **Single source of truth** - Configurations symlinked, never duplicated
- **Cross-tool compatibility** - Works with Claude Code, Cursor, Windsurf, and others
- **Human control** - AI prepares, human decides (especially for commits)

---

**License**: MIT | **Author**: [TechNickAI](https://github.com/TechNickAI) |
**Repository**: https://github.com/TechNickAI/ai-coding-config

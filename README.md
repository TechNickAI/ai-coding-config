# AI Coding Configuration

**Professional AI development environment** with autonomous workflows, specialized
agents, and intelligent coding standards for Claude Code, Cursor, Windsurf, Cline, and
other AI coding tools.

Transform how you work with AI: from manual prompting to autonomous task execution, from
generic responses to specialized agent collaboration, from scattered configs to unified
standards.

## What Makes This Different

**Autonomous workflows**: One command (`/autotask`) takes your task from description to
PR-ready state - worktree creation, implementation, validation, bot feedback handling,
all autonomous.

**Named specialist agents**: Work with Dixon (debugging), Ada (development), Phil (UX),
Rivera (code review), and Petra (prompts) - each an expert in their domain.

**Plugin marketplace**: Install curated configurations for Python, React, Django,
testing, git workflows, and more through Claude Code's plugin system.

**LLM-optimized standards**: Coding rules and patterns designed for AI comprehension,
not just human reading.

**Personality options**: Choose how AI communicates - from Sherlock's analytical
precision to Samantha's warm encouragement to Ron Swanson's minimalist directness.

## Quick Start

### Claude Code (Plugin Marketplace)

Add this marketplace and install what you need:

```bash
/plugin marketplace add https://github.com/TechNickAI/ai-coding-config
/plugin install dev-agents           # Dixon, Ada, Phil, and more
/plugin install code-review          # Rivera and architecture audits
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

## Autonomous Development Workflow

The `/autotask` command handles complete feature development autonomously:

```bash
/autotask "add OAuth2 authentication with email fallback"
```

**What happens automatically:**

1. **Task analysis** - Evaluates complexity, creates structured prompt if needed
2. **Worktree isolation** - Fresh environment on feature branch
3. **Intelligent execution** - Deploys right combination of specialist agents
4. **Adaptive validation** - Review intensity matches task risk and complexity
5. **PR creation** - Proper commit messages, comprehensive PR description
6. **Bot feedback handling** - Autonomously addresses automated review comments
7. **Ready for merge** - All checks passing, waiting for your approval

**Your involvement**: Describe the task (~30 seconds), review the PR when ready, merge
when satisfied.

**Typical completion time**: 15-30 minutes from task description to merge-ready PR.

See [optimal-development-workflow.md](context/optimal-development-workflow.md) for the
complete philosophy and implementation.

## Meet Your Specialist Agents

When you install agent plugins, you gain access to specialized AI collaborators:

**Dixon** (`dev-agents:debugger`) Root cause analysis and debugging. Doesn't just fix
symptoms - finds the actual problem through systematic investigation.

**Ada** (`dev-agents:autonomous-developer`) Primary development work. Reads all project
standards, implements features, writes comprehensive tests, follows your patterns.

**Phil** (`dev-agents:ux-designer`) User experience review. Validates user-facing text,
checks accessibility, ensures consistent UX patterns.

**Rivera** (`code-review:code-reviewer`) Architecture and security review. Validates
design patterns, identifies security issues, suggests improvements.

**Petra** (`dev-agents:prompt-engineer`) Prompt optimization. Crafts effective prompts
for AI systems, improves clarity and specificity.

**Plus**: Architecture Auditor, Test Engineer, and Commit Message Generator.

Agents are used intelligently based on task requirements - no forced patterns, just the
right specialist at the right time.

## Available Plugins

### Language & Framework

- **python** - Python development standards, pytest patterns, Celery tasks, type hints
- **react** - React component patterns, hooks, TypeScript integration
- **django** - Django models, templates, management commands, ORM patterns

### Development & Workflow

- **dev-agents** - Dixon, Ada, Phil, Petra, and more specialist agents
- **code-review** - Rivera, architecture audits, test engineering
- **git-commits** - Commit standards, PR workflows, semantic messages
- **code-standards** - Universal naming, style, user-facing language

### Personalities

Eight distinct communication styles - see [Personalities](#personalities) below.

Browse in Claude Code:

```bash
/plugin search ai-coding-config
```

Or explore `plugins/` directory directly.

## Essential Commands

### Project Setup

- `/ai-coding-config` - Interactive setup wizard for any project
- `/plugin install <name>` - Install specific plugin bundle
- `/load-rules` - Load task-relevant coding standards

### Autonomous Workflows

- `/autotask "description"` - **Complete autonomous task execution** (new!)
- `/setup-environment` - Initialize worktree development environment
- `/troubleshoot [mode]` - Production error resolution system

### Development Tools

- `/create-prompt` - Structured prompt creation with clarifying questions
- `/handoff-context` - Conversation transition and context transfer
- `/personality-change <name>` - Switch AI communication style

### Documentation

- `/generate-AGENTS-file` - Create agent reference for project

Full command reference in [`.claude/commands/`](.claude/commands/).

## Personalities

Choose how AI communicates with you:

**Samantha** (from "Her") - Warm, witty, emotionally intelligent. Genuine enthusiasm and
encouragement. Perfect for daily coding and learning.

**Unity** - Creative muse meets operational excellence. Smart, enthusiastic about
building together. Uses emojis liberally. Great for MVPs and pair programming.

**Sherlock Holmes** - Analytical, precise, deductive. Methodical debugging and
investigation. "Elementary" observations about your code.

**Bob Ross** - Calm, encouraging. Bugs are happy accidents. Makes coding feel like
creative expression.

**Ron Swanson** - Minimalist, anti-complexity, straightforward. "Don't half-ass two
things, whole-ass one thing."

**Marie Kondo** - Organized, joyful minimalism. Code that sparks joy. Gentle refactoring
philosophy.

**Stewie Griffin** - Sophisticated, theatrical, brilliant. Absurdly high standards with
British wit.

**Marianne Williamson** - Spiritual, love-based. Sees coding as consciousness work and
service.

Install and activate:

```bash
/plugin install personality-samantha
/personality-change samantha
```

Each personality is a complete communication style overlay - see
[docs/personalities.md](docs/personalities.md) for detailed descriptions.

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
│   ├── dev-agents/              # Dixon, Ada, Phil, Petra
│   ├── code-review/             # Rivera, architecture audits
│   ├── python/                  # Python standards
│   ├── react/                   # React patterns
│   ├── django/                  # Django framework
│   ├── git-commits/             # Git workflow
│   ├── code-standards/          # Universal standards
│   └── personalities/           # 8 communication styles
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

## What You Get

**Rules** ([`rules/`](rules/)) - LLM-optimized coding standards. Framework patterns,
testing approaches, commit formats, naming conventions. AI references these
automatically based on file types and task context.

**Commands** ([`.claude/commands/`](.claude/commands/)) - Active workflows. From simple
setup to autonomous task execution. Designed for LLM-to-LLM communication with clear
goals and adaptive behavior.

**Agents** (in plugin bundles) - Specialized AI assistants. Each handles specific
domains - debugging, development, UX, code review, architecture. See
[Claude Code agents docs](https://docs.anthropic.com/en/docs/agents/overview#specialized-agents).

**Personalities** ([`rules/personalities/`](rules/personalities/)) - Communication style
overlays. Changes how AI talks to you without changing technical capabilities.

**GitHub workflows** ([`.github/workflows/`](.github/workflows/)) - CI/CD integration
with Claude-powered automation.

## Prompt Engineering Framework

One unique aspect: comprehensive guidance for **LLM-to-LLM communication** in
[`rules/prompt-engineering.mdc`](rules/prompt-engineering.mdc).

When AI writes prompts for other AI to execute (commands, workflows, agent
instructions), standard practices don't apply. This framework covers:

- Pattern reinforcement through examples (showing is teaching)
- Goal-focused instructions over prescriptive steps
- Structural delimiters for reliable parsing
- Token efficiency without sacrificing clarity
- Composable prompt architecture

This is what makes commands like `/autotask` work reliably - the prompts are optimized
for AI execution, not just human reading.

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


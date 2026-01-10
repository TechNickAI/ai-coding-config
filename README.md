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
| [Commands](plugins/core/commands/)      | 16    | Automate workflows      |
| [Agents](plugins/core/agents/)          | 22    | Specialized assistants  |
| [Rules](rules/)                         | 33    | Coding standards        |
| [Skills](plugins/core/skills/)          | 5     | Autonomous capabilities |
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

**`/session save|resume|list`** - Session persistence across conversations. Save your
context, decisions, and progress. Resume exactly where you left off - even in a new
conversation.

```bash
/session save "auth-refactor"    # Save current session
/session resume                   # Resume where you left off
```

### Agents (24 specialized reviewers)

**🚀 When building features**

- **autonomous-developer** - Implements features end-to-end following your patterns
- **test-engineer** - Writes comprehensive test coverage
- **test-runner** - Runs tests with terse, context-efficient output

**🐛 When debugging**

- **debugger** - Root cause analysis through systematic investigation
- **site-keeper** - Production health monitoring and error triage

**✅ When reviewing code for correctness**

- **logic-reviewer** - Bug and logic error detection
- **error-handling-reviewer** - Error handling and silent failure detection
- **security-reviewer** - Security vulnerabilities (injection, auth, OWASP top 10)
- **robustness-reviewer** - Production readiness and resilience

**⚡ When optimizing**

- **performance-reviewer** - Performance bottlenecks and efficiency
- **simplifier** - Reduce complexity while preserving functionality

**🎨 When building UX**

- **empathy-reviewer** - User experience from the user's chair (Norman, Krug, Rams)
- **ux-designer** - User-facing content and interface design
- **design-reviewer** - Visual quality and responsive behavior
- **mobile-ux-reviewer** - Mobile responsiveness and touch interactions

**📐 When reviewing architecture**

- **architecture-auditor** - Design patterns and structural decisions
- **style-reviewer** - Code style and project conventions
- **observability-reviewer** - Logging, monitoring, debuggability

**📝 When polishing**

- **comment-analyzer** - Comment accuracy and staleness
- **test-analyzer** - Test coverage gaps and brittle tests
- **seo-specialist** - SEO, meta tags, structured data
- **git-writer** - Commit messages and PR descriptions
- **prompt-engineer** - LLM prompt optimization

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
- **Marie Kondo** - Sparks joy in clean code
- **Stewie Griffin** - Sardonic genius
- **Luminous** - Heart-centered, presence-first

Activate: `/personality-change samantha`

## Plugin Architecture

Everything is consolidated into one plugin: `ai-coding-config`. Install it to get all
commands, agents, and skills:

```bash
/plugin install ai-coding-config
```

Personalities are included in the repository but activated separately via
`/personality-change`.

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
│   ├── core/                         # Main ai-coding-config plugin
│   │   ├── commands/                 # All workflow commands
│   │   ├── agents/                   # All 22 specialized agents
│   │   └── skills/                   # Autonomous capabilities
│   └── personalities/                # Personality variants
├── .cursor/rules/                    # Coding standards (.mdc)
├── rules/                            # Symlink to .cursor/rules/
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

## Discovery

This marketplace is indexed at
[claudemarketplaces.com](https://claudemarketplaces.com) - the searchable directory of
Claude Code plugins.

---

**License**: MIT | **Author**: [TechNickAI](https://github.com/TechNickAI) |
**Repository**: https://github.com/TechNickAI/ai-coding-config

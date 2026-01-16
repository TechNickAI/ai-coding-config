<p align="center">
  <img src="assets/logo.png" alt="AI Coding Configuration" width="200">
</p>

<p align="center">
  <a href="https://claude.ai"><img src="https://img.shields.io/badge/Claude_Code-D97757?logo=claude&logoColor=fff" alt="Claude Code"></a>
</p>

# AI Coding Configuration

Curated commands, agents, and rules for Claude Code, Cursor, Windsurf, and Cline.

## What This Is

A shared configuration that works across AI coding tools. Commands automate workflows
(PR handling, debugging, session management). Agents specialize in specific review types
(security, performance, UX). Rules encode your coding standards so AI follows your
patterns.

## Quick Start

**Claude Code:**

```bash
/plugin marketplace add https://github.com/TechNickAI/ai-coding-config
/plugin install ai-coding-config skills
```

**Cursor, Windsurf, Cline, or others:**

```bash
curl -fsSL https://raw.githubusercontent.com/TechNickAI/ai-coding-config/main/scripts/bootstrap.sh | bash
```

Then run the interactive setup:

```
/ai-coding-config
```

This detects your stack and installs relevant configurations.

## Example Usage

```bash
# Triage PR bot comments (fixes real issues, declines nitpicks)
/address-pr-comments

# Load coding standards for current task
/load-rules

# Autonomous task execution: describe what you want, get a PR
/autotask "add user settings page with dark mode toggle"
```

## What's Included

| Type                                    | Count | Purpose                 |
| --------------------------------------- | ----- | ----------------------- |
| [Commands](plugins/core/commands/)      | 18    | Automate workflows      |
| [Agents](plugins/core/agents/)          | 24    | Specialized assistants  |
| [Skills](plugins/core/skills/)          | 6     | Autonomous capabilities |
| [Rules](rules/)                         | 33    | Coding standards        |
| [Personalities](plugins/personalities/) | 7     | Communication styles    |

---

## Commands

Slash commands that automate real workflows. Type `/command-name` to invoke.

### Autonomous Development

**`/autotask "description"`** - Describe what you want, get a PR. Creates branch,
implements, writes tests, handles bot feedback.

```bash
/autotask "add user settings page with dark mode toggle"
```

**`/troubleshoot`** - Connects to Sentry/HoneyBadger, analyzes errors, fixes bugs in
parallel worktrees, submits PRs with root cause analysis.

**`/verify-fix`** - Confirms fixes actually work before claiming success. Runs tests,
checks live behavior.

### PR & Code Review

**`/address-pr-comments`** - Triages bot comments: fixes real issues, declines nitpicks,
iterates until merge-ready.

**`/multi-review`** - Runs multiple specialized reviewers in parallel. Security, logic,
performance, style - all at once.

### Context & Session Management

**`/session save|resume|list`** - Save your context, decisions, and progress. Resume
exactly where you left off - even in a new conversation.

```bash
/session save "auth-refactor"    # Save current session
/session resume                   # Resume where you left off
```

**`/load-rules`** - Loads relevant coding standards for your current task. Working on
React? Loads React patterns. Writing tests? Testing standards.

**`/handoff-context`** - Generate context handoff for new sessions.

### Project Setup

**`/ai-coding-config`** - Interactive setup for new projects. Detects your stack,
installs relevant rules.

**`/repo-tooling`** - Set up linting, formatting, CI/CD based on detected language.

**`/setup-environment`** - Initialize dev environment for git worktrees.

### Other Commands

- `/cleanup-worktree` - Clean up worktrees after PR merge
- `/create-prompt` - Create optimized prompts following prompt engineering principles
- `/generate-AGENTS-file` - Generate AGENTS.md for AI context
- `/generate-llms-txt` - Generate llms.txt for LLM navigation
- `/knowledge` - AI Product Manager - maintain living product understanding
- `/personality-change` - Switch AI communication style
- `/product-intel` - Competitive intelligence research

---

## Agents

24 specialized assistants that Claude Code invokes automatically based on context.

### Building Features

| Agent                    | Purpose                                                |
| ------------------------ | ------------------------------------------------------ |
| **autonomous-developer** | Implements features end-to-end following your patterns |
| **test-engineer**        | Writes comprehensive test coverage                     |
| **test-runner**          | Runs tests with terse, context-efficient output        |

### Debugging

| Agent           | Purpose                                              |
| --------------- | ---------------------------------------------------- |
| **debugger**    | Root cause analysis through systematic investigation |
| **site-keeper** | Production health monitoring and error triage        |

### Code Review - Correctness

| Agent                       | Purpose                                |
| --------------------------- | -------------------------------------- |
| **logic-reviewer**          | Bug and logic error detection          |
| **error-handling-reviewer** | Silent failures and try-catch patterns |
| **security-reviewer**       | Injection, auth, OWASP top 10          |
| **robustness-reviewer**     | Production readiness and resilience    |

### Code Review - Performance

| Agent                    | Purpose                                   |
| ------------------------ | ----------------------------------------- |
| **performance-reviewer** | N+1 queries, algorithmic complexity       |
| **simplifier**           | Reduce complexity, preserve functionality |

### Code Review - UX

| Agent                  | Purpose                                       |
| ---------------------- | --------------------------------------------- |
| **empathy-reviewer**   | UX from the user's chair (Norman, Krug, Rams) |
| **ux-designer**        | User-facing content and interface design      |
| **design-reviewer**    | Visual quality and responsive behavior        |
| **mobile-ux-reviewer** | Mobile responsiveness and touch interactions  |

### Code Review - Architecture

| Agent                      | Purpose                                  |
| -------------------------- | ---------------------------------------- |
| **architecture-auditor**   | Design patterns and structural decisions |
| **style-reviewer**         | Code style and project conventions       |
| **observability-reviewer** | Logging, monitoring, debuggability       |

### Polish & Documentation

| Agent                | Purpose                                    |
| -------------------- | ------------------------------------------ |
| **comment-analyzer** | Comment accuracy and staleness             |
| **test-analyzer**    | Test coverage gaps and brittle tests       |
| **seo-specialist**   | SEO, meta tags, structured data            |
| **git-writer**       | Commit messages and PR descriptions        |
| **prompt-engineer**  | LLM prompt optimization                    |
| **library-advisor**  | Evaluate libraries, build vs buy decisions |

---

## Skills

Autonomous capabilities with multi-step workflows.

| Skill                           | Purpose                                       |
| ------------------------------- | --------------------------------------------- |
| **brainstorming**               | Creative ideation with structured exploration |
| **playwright-browser**          | Browser automation, screenshots, UI testing   |
| **research**                    | Web research and documentation gathering      |
| **skill-creator**               | Framework for creating new skills             |
| **systematic-debugging**        | Root cause analysis framework                 |
| **youtube-transcript-analyzer** | Video transcript analysis for learning        |

---

## Rules

Coding standards in `.mdc` format (markdown with frontmatter). AI reads these to
understand your conventions.

**Always active:**

- `git-interaction.mdc` - Git workflow, commit messages, PR standards
- `prompt-engineering.mdc` - Writing prompts for LLMs
- `heart-centered-ai-philosophy.mdc` - Presence before solutions

**Framework-specific** (loaded by `/load-rules`):

- `frontend/react-components.mdc` - React patterns and hooks
- `frontend/typescript-standards.mdc` - TypeScript conventions
- `python/python-coding-standards.mdc` - Python conventions
- `django/django-models.mdc` - Django ORM patterns
- `observability/logfire.mdc` - Logging with Logfire
- And 25+ more...

---

## Personalities

Change how AI communicates. Same technical capabilities, different style.

| Personality         | Style                                        |
| ------------------- | -------------------------------------------- |
| **Samantha**        | Warm, witty, emotionally intelligent         |
| **Sherlock Holmes** | Analytical, deductive reasoning              |
| **Bob Ross**        | Calm, encouraging (bugs are happy accidents) |
| **Ron Swanson**     | Minimalist, anti-complexity                  |
| **Marie Kondo**     | Sparks joy in clean code                     |
| **Stewie Griffin**  | Sardonic genius                              |
| **Luminous**        | Heart-centered, presence-first               |

Activate: `/personality-change samantha`

---

## Architecture

```
┌─────────────────────────────────────────┐
│  ai-coding-config                       │
│  (commands, agents, rules, skills)      │
└─────────────────────────────────────────┘
              │
      Plugin system / Bootstrap
              │
      ┌───────┴───────┐
      │               │
      ▼               ▼
  Project A      Project B
```

**Plugin-first** - All distributable content lives in `plugins/`:

```
ai-coding-config/
├── .claude-plugin/marketplace.json   # Plugin manifest
├── plugins/
│   ├── core/                         # Main plugin
│   │   ├── commands/                 # 18 workflow commands
│   │   ├── agents/                   # 24 specialized agents
│   │   └── skills/                   # 6 autonomous capabilities
│   └── personalities/                # 7 personality variants
├── .cursor/rules/                    # 33 coding standards (.mdc)
├── docs/                             # Guides
└── scripts/                          # Installation
```

---

## Updates

Update configurations in any project:

```bash
/ai-coding-config update
```

Shows what changed, lets you choose what to update, preserves your customizations.

---

## Requirements

**Basic usage:**

- Claude Code, Cursor, Windsurf, Cline, or any AI tool with rules support

**For autonomous workflows** (`/autotask`, `/troubleshoot`):

- Git with worktrees support
- GitHub CLI (`gh`) installed and authenticated

---

## Documentation

- [Coding Ecosystem Comparison](docs/coding-ecosystem.md) - Cursor vs Claude Code vs
  Windsurf
- [Tools and Configs Guide](docs/tools-and-configs.md) - Rules vs commands vs agents
- [Personalities Guide](docs/personalities.md) - All personalities with examples
- [Architecture](docs/architecture-summary.md) - System design
- [Development Workflow](context/optimal-development-workflow.md) - Autonomous workflow
  philosophy
- [Contributing](docs/contributing.md) - How to contribute

---

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

# AI Coding Configuration

A **Claude Code plugin marketplace** and **Cursor configuration library**. Get
professional coding standards, specialized AI agents, and personality options through an
elegant plugin system.

This repo provides:

- **Plugin marketplace** - Install curated bundles for Python, React, Django, Git
  workflows, and more
- [Cursor rules](/.cursor/rules/) - Coding standards and patterns (accessible via
  `@rule-name`)
- **Specialized agents** - AI assistants for code review, debugging, testing (in plugin
  bundles)
- [Claude Code commands](/.claude/commands/) - Workflow automation (`/command-name`)
- **AI personalities** - Change how AI communicates (Sherlock, Bob Ross, Samantha,
  Unity, and more)
- [GitHub workflow templates](/.github/workflows/) - CI/CD integration

## What This Solves

You have multiple projects. Each needs the same coding standards, framework patterns,
git commit rules, and AI personality. Copying configurations manually across projects is
tedious. Letting each project diverge means inconsistent AI behavior.

This repo centralizes those configurations. Set up once, sync to projects, update from
one place.

## Installation

### For Claude Code Users (Plugin Marketplace)

Add this marketplace:

```bash
/plugin marketplace add https://github.com/TechNickAI/ai-coding-config
```

Then install plugins you need:

```bash
/plugin install python              # Python development setup
/plugin install code-review         # Code review agents
/plugin install personality-samantha  # Samantha personality
```

Browse available plugins:

```bash
/plugin search ai-coding-config
```

### For Cursor Users (Bootstrap Script)

From any project:

```bash
curl -fsSL https://raw.githubusercontent.com/TechNickAI/ai-coding-config/main/scripts/bootstrap.sh | bash
```

Then run the setup command:

**In Cursor IDE:**

```
@ai-coding-config set up this project
```

**With [Cursor CLI](https://cursor.com/cli):**

```bash
cursor-agent "@ai-coding-config set up this project"
```

The command detects your project type and copies selected rules to your project.

### For Both Tools

You can also use the `/ai-coding-config` command which works in both Claude Code and
Cursor to interactively select and install configurations.

## What You Get

**Rules** ([`.cursor/rules/`](/.cursor/rules/)) provide context for AI coding. They
cover Python (Django, FastAPI, Flask), TypeScript (React, Next.js), testing patterns,
commit message formats, and framework-specific patterns. The AI references these
automatically based on file types.

**Agents** (in plugin bundles like `plugins/code-review/agents/`) are specialized AI
assistants. Each handles specific tasks - code review, debugging, test writing,
architecture audits. Read about
[Claude Code agents](https://docs.anthropic.com/en/docs/agents/overview#specialized-agents)
for how they work.

**Personalities** ([`.cursor/rules/personalities/`](/.cursor/rules/personalities/))
change how AI communicates. Pick methodical and precise, calm and encouraging,
minimalist and direct, or other styles.

**GitHub workflows** ([`.github/workflows/`](/.github/workflows/)) provide
Claude-powered code review and automated PR fixing for CI/CD pipelines.

## Available Plugins

Browse the `plugins/` directory to see all available plugins, or use:

```bash
/plugin search ai-coding-config
```

Plugin categories include:

- **Language & Framework** - Python, React, Django setups with rules and patterns
- **Workflow** - Git standards, error tracking, code conventions
- **Agents** - Code review, development assistance, specialized AI helpers
- **Personalities** - Different communication styles (analytical, encouraging,
  minimalist, spiritual, etc.)

### Using Personalities

Personalities change how AI communicates. Install and activate with:

```bash
/plugin install personality-samantha
/personality-change samantha
```

Browse available personalities in `plugins/personalities/` or
`.cursor/rules/personalities/`.

**For Cursor:** Reference via `@personality-name` or set `alwaysApply: true` in the rule
file.

**For Claude Code:** Use `/personality-change <name>` to activate permanently.

## How It Works

```
┌─────────────────────────────────────────┐
│  ai-coding-config repo                  │
│                                         │
│  .cursor/rules/     ← standards         │
│  plugins/*/agents/  ← specialists       │
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
├── .claude-plugin/
│   └── marketplace.json          # Plugin marketplace manifest
│
├── plugins/                      # Plugin bundles (symlink to canonical sources)
│   ├── python/                   # Python development setup
│   ├── react/                    # React patterns
│   ├── django/                   # Django framework
│   ├── git-commits/              # Git workflow
│   ├── error-tracking/           # Logging & monitoring
│   ├── code-standards/           # Universal standards
│   ├── code-review/              # Code quality agents
│   ├── dev-agents/               # Development agents
│   └── personalities/            # AI personalities
│       ├── personality-sherlock/
│       ├── personality-samantha/
│       └── [others]/
│
├── .cursor/
│   └── rules/                    # CANONICAL: Coding standards
│       ├── python/               # Python rules
│       ├── frontend/             # React, TypeScript rules
│       ├── django/               # Django rules
│       ├── personalities/        # Personality rules
│       └── [others]/
│
├── .claude/
│   ├── commands/                 # CANONICAL: Workflow commands
│   └── context.md                # Project context
│
├── .github/workflows/            # CI/CD templates
└── docs/                         # Architecture and guides
```

**Key principle:** Single source of truth with plugin symlinks for easy packaging.

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

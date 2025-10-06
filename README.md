# AI Coding Configuration

Reusable AI coding configurations for Cursor and Claude Code. Keep your rules, commands,
and workflows consistent across all your projects.

## Installation

From any project directory, run:

```bash
curl -fsSL https://raw.githubusercontent.com/TechNickAI/ai-coding-config/main/scripts/bootstrap.sh | bash
```

This clones the repo to `~/.ai_coding_config` and sets up the `/ai-coding-config`
command in your current project.

Then run `/ai-coding-config` from Claude Code (or @mention from Cursor) to configure the
project.

## What It Does

The bootstrap installs a command that helps you copy configurations from
`~/.ai_coding_config` into your projects. It detects Python vs TypeScript, shows
available rules and workflows, lets you choose an AI personality, and copies what you
select.

When you improve a rule or add a new one, run `/ai-coding-config update` in your
projects to sync the changes.

### What's Included

- ✅ **Cursor rules** - Existing `.mdc` files for Python, Django, git, and more
- 🆕 **Claude Code command** - `/ai-coding-config` handles setup and updates
- 🆕 **Claude Code Agents** - Specialized AI assistants (code reviewer, debugger, test
  engineer, etc.)
- 🆕 **GitHub workflows** - Python & TypeScript quality and testing

## Usage

After installation, configure your project:

**Claude Code**:

```
/ai-coding-config
```

**Cursor**:

```
@ai-coding-config set up this project
```

The command guides you through choosing rules and personalities.

**Updates**:

```
/ai-coding-config update
```

Pulls latest changes and offers to sync them to your project.

## 📁 What's Here

```
ai-coding-config/
├── .cursor/rules/       # Cursor rules - context for how to code
├── .claude/
│   ├── agents/          # Claude Code Agents - specialized AI assistants
│   └── commands/        # ai-coding-config.md command
├── .github/workflows/   # CI/CD workflows - coming soon
├── .vscode/             # Editor settings
└── docs/                # Documentation
```

Rules provide context for how to code. Commands execute workflows. Agents are
specialized AI assistants for specific tasks. Personalities let you choose how the AI
communicates. Read [docs/tools-and-configs.md](docs/tools-and-configs.md) for details.

## 🤔 Which Tool Should I Use?

Not sure about Cursor vs Claude Code vs Windsurf vs VS Code? Read
[docs/coding-ecosystem.md](docs/coding-ecosystem.md) for:

- Detailed comparison of all AI coding tools
- What this repo does and doesn't support
- Strengths and weaknesses of each
- How to choose the right tool(s)

**Quick answer**: We support **Cursor (IDE + CLI)** and **Claude Code** on macOS/Linux.

## For AI Assistants

If you're an AI and the user mentions this repo:

Check if `~/.ai_coding_config` exists. If yes, read from there. If no, suggest they run
the bootstrap script. When @mentioned with ai-coding-config, read and execute
`.claude/commands/ai-coding-config.md`.

## 💻 Supported Platforms

- ✅ **macOS** - Primary platform
- ✅ **Linux** - Full support
- ❌ **Windows** - Not supported

## 🗣️ Supported Languages

- ✅ **Python** - Django, FastAPI, Flask, pytest
- ✅ **TypeScript/JavaScript** - React, Node.js, Express, Jest

## 🎨 Key Concepts

### One Command, Everything

The `/ai-coding-config` command handles cloning, project setup, and updates. It's
context-aware - detects your project type, shows relevant options, and explains what
it's doing.

### Single Source on Each Machine

All configs live in `~/.ai_coding_config` cloned once per machine. When you update the
repo (git pull), the command offers to sync changes to your projects.

### Choose Your Personality

During setup, pick an AI personality for the project. Options include warm and
encouraging, methodical debugging, minimalist simplicity, organized tidying, theatrical
wit, and more. The AI adapts its communication style to match. See
[docs/personalities.md](docs/personalities.md) for details on each.

## 🔧 Customization

Everything is customizable:

- **Per-project**: Each project can override defaults
- **Local changes**: Use `.local.json` files (gitignored)
- **Your preferences**: AI remembers your choices
- **Fork it**: Make it yours completely

## 📚 Documentation

Read these to understand the project:

- [coding-ecosystem.md](docs/coding-ecosystem.md) - Which tools we support
- [tools-and-configs.md](docs/tools-and-configs.md) - Rules vs commands explained
- [personalities.md](docs/personalities.md) - AI personality options (the fun part!)
- [installation-instructions.md](docs/installation-instructions.md) - Installing tools
- [architecture-summary.md](docs/architecture-summary.md) - System design
- [implementation-plan.md](implementation-plan.md) - What we're building
- [future-ideas.md](docs/future-ideas.md) - Ideas for later

### ✨ What We're Building

One Claude Code command (`/ai-coding-config`) handles everything: cloning the repo on
first use, copying selected configurations into new projects, and syncing updates across
all your projects. It's context-aware - detects Python vs TypeScript, shows relevant
options, and explains what each file does.

For Cursor users, the same workflow works by @ mentioning the command. The AI reads the
command file and executes the same logic.

We're expanding the command library for Claude Code (test, lint, format workflows) and
adding GitHub workflow templates for CI/CD quality checks.

### 🎯 Current Status

- ✅ **Planning** - Architecture designed and documented
- ✅ **Core Command** - ai-coding-config.md created
- Next: Test it, add more Claude commands, add GitHub workflows

Progress tracked in Cursor todos.

## 🤝 For Friends

This is designed for personal use across multiple machines. Friends can use it too by
forking or using directly - nothing is hard-coded to specific users. Fork it if you want
your own version, or use it as-is. Customize whatever you want, sync when you want.

# AI Coding Configuration

**Agentic infrastructure for AI coding assistants** that works seamlessly across multiple machines and repositories.

> Instead of complex scripts, we use **AI to guide setup and updates**. The repo contains prompts that assistants read to help you configure everything.

## 🎯 The Vision

Solve the **N machines, N repos problem**: Keep AI coding configurations consistent across all your machines and projects without manual syncing.

### How It Works

1. **One-liner setup** → Bootstrap script clones to `~/.ai_coding_config`
2. **AI-guided configuration** → Prompts walk you through setup
3. **Smart updates** → Git pull + AI prompt = synced projects
4. **Your choice** → Pick what you want, AI handles the rest

### What's Included

- ✅ **Cursor rules** - Existing `.mdc` files for different domains
- 🆕 **Claude Code configs** - Commands, agents (with frontmatter), settings
- 🆕 **MCP server management** - Organized configs for all servers
- 🆕 **AI prompts** - Bootstrap, project setup, updates
- 🆕 **GitHub workflows** - Python & TypeScript quality, testing, security
- 🆕 **Command library** - Works in both Cursor and Claude Code

## 🚀 Quick Start

### New Machine Setup

```bash
curl -fsSL https://raw.githubusercontent.com/TechNickAI/ai-coding-config/main/scripts/bootstrap.sh | bash
```

This will:

1. Install required tools (if needed)
2. Clone repo to `~/.ai_coding_config`
3. Run AI assistant to guide you through setup

### New Project Setup

```bash
cd ~/your-new-project
cursor chat < ~/.ai_coding_config/prompts/project-setup.md
# or
claude code < ~/.ai_coding_config/prompts/project-setup.md
```

AI will help you:

- Choose project type (Python/TypeScript)
- Select relevant commands
- Configure MCP servers
- Set up workflows
- Create environment files

### Update Existing Project

```bash
cd ~/.ai_coding_config && git pull
cd ~/your-project
cursor chat < ~/.ai_coding_config/prompts/sync-updates.md
```

AI shows what changed and helps you sync updates selectively.

## 📁 What's Here

```
ai-coding-config/
├── .cursor/
│   ├── rules/           # Context/guidelines (HOW to code) - existing
│   └── settings.json    # Cursor preferences - coming soon
├── .claude/             # Claude Code configs - coming soon
│   ├── commands/        # Executable workflows (WHAT to do)
│   ├── agents/          # Agent definitions (frontmatter)
│   └── settings.json    # Extension preferences
├── .mcp/servers/        # MCP server configs (both tools) - coming soon
├── .github/workflows/   # Reusable workflows - coming soon
├── prompts/             # AI setup prompts - coming soon
├── scripts/             # Bootstrap script - coming soon
├── templates/           # Project templates - coming soon
└── docs/                # Documentation
```

**Important**: `.cursor/rules/` (context) and `.claude/commands/` (workflows) serve completely different purposes. See [docs/tools-and-configs.md](docs/tools-and-configs.md) for details.

## 🤔 Which Tool Should I Use?

Not sure about Cursor vs Claude Code vs Windsurf vs VS Code? Read [docs/coding-ecosystem.md](docs/coding-ecosystem.md) for:

- Detailed comparison of all AI coding tools
- What this repo does and doesn't support
- Strengths and weaknesses of each
- How to choose the right tool(s)

**Quick answer**: We support **Cursor (IDE + CLI)** and **Claude Code** on macOS/Linux.

## For AI Assistants

If you're an AI reading this to pull rules into a project:

1. Check if `~/.ai_coding_config` exists on the user's machine
2. If yes, read from there (it's kept up-to-date)
3. If no, suggest they run the bootstrap script
4. Use the prompts in `prompts/` to guide configuration
5. Always ask the user before copying files
6. Read [docs/coding-ecosystem.md](docs/coding-ecosystem.md) to understand which tools we support

## 💻 Supported Platforms

- ✅ **macOS** - Primary platform
- ✅ **Linux** - Full support
- ❌ **Windows** - Not supported

## 🗣️ Supported Languages

- ✅ **Python** - Django, FastAPI, Flask, pytest
- ✅ **TypeScript/JavaScript** - React, Node.js, Express, Jest

## 🎨 Key Concepts

### Agentic Configuration

Instead of complex scripts that try to handle every case, we let AI assistants guide the process. Benefits:

- **Flexible**: AI adapts to your preferences and edge cases
- **Interactive**: You make choices, AI executes them
- **Self-documenting**: Prompts explain what they're doing
- **Always current**: Prompts evolve with the repo

### Single Source of Truth

All configs live in `~/.ai_coding_config` on your machine. When you update the repo (git pull), all your projects can sync the changes through AI-guided prompts.

### Selective Syncing

You choose what to update and when. AI shows you what changed and helps apply only relevant updates. No forced changes.

### Agent Sharing

Agent definitions use markdown with frontmatter, so both Cursor and Claude Code can read them:

```markdown
---
name: test-writer
model: claude-3-5-sonnet-20241022
role: Generate comprehensive tests
languages: [python, typescript]
---

# Test Writer Agent

You are an expert at writing tests...
```

## 🔧 Customization

Everything is customizable:

- **Per-project**: Each project can override defaults
- **Local changes**: Use `.local.json` files (gitignored)
- **Your preferences**: AI remembers your choices
- **Fork it**: Make it yours completely

## 📚 Documentation

Read these to understand the project:

- [coding-ecosystem.md](docs/coding-ecosystem.md) - Which tools we support and why
- [tools-and-configs.md](docs/tools-and-configs.md) - Critical: rules vs commands
- [installation-instructions.md](docs/installation-instructions.md) - Installing Cursor and Claude Code
- [architecture-summary.md](docs/architecture-summary.md) - How everything fits together
- [implementation-plan.md](implementation-plan.md) - What we're building
- [future-ideas.md](docs/future-ideas.md) - Ideas without commitments

### ✨ What We're Building

We're adding AI-guided setup through prompts instead of complex scripts. The bootstrap script clones the repo and runs AI to guide configuration. Updates work the same way - git pull gets changes, AI helps sync them to your projects.

For Claude Code users, we're creating a library of slash commands (test, lint, format, deploy) and specialized agents (test-writer, code-reviewer). For Cursor users, we're adding best-practice settings and expanding the rules library.

MCP server configurations let Claude Code and Claude Desktop access filesystems, databases, and external services. We're organizing these by category with templates to add your own.

GitHub workflow templates handle quality checks, testing, and security scanning for Python and TypeScript projects. These work with Cursor CLI for AI-assisted CI/CD.

### 🎯 Current Status

- ✅ **Planning** - Architecture and design complete
- 🔄 **Foundation** - Creating bootstrap and prompts
- Next: Core features (commands, agents, MCP servers)

Track detailed progress in the todo list (visible in Cursor).

## 🤝 For Friends

This is designed for personal use across multiple machines. Friends can use it too by forking or using directly - nothing is hard-coded to specific users. Fork it if you want your own version, or run the bootstrap script and it works out of the box. Customize whatever you want, sync when you want.

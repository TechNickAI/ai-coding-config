# AI Coding Configuration

**Agentic infrastructure for AI coding assistants** that works seamlessly across multiple machines and repositories.

> Instead of complex scripts, we use **AI to guide setup and updates**. The repo contains prompts that assistants read to help you configure everything.

## 🎯 The Vision

Solve the **N machines, N repos problem**: Keep AI coding configurations consistent across all your machines and projects without manual syncing.

### How It Works

Run `/ai-coding-config` from Claude Code (or @ mention from Cursor). The command clones the repo to `~/.ai_coding_config` on first use, then guides you through selecting and copying relevant configurations. Updates work the same way - it pulls the latest changes and offers to sync them to your project.

### What's Included

- ✅ **Cursor rules** - Existing `.mdc` files for Python, Django, git, and more
- 🆕 **Claude Code command** - `/ai-coding-config` handles setup and updates
- 🆕 **GitHub workflows** - Python & TypeScript quality and testing

## 🚀 Quick Start

### From Claude Code

```bash
/ai-coding-config
```

First time: Clones repo to `~/.ai_coding_config` and offers to set up current project.

New project: Shows available configurations and copies what you choose.

Update: `ai-coding-config update` pulls latest and offers to sync changes.

### From Cursor

First time, clone the repo:

```bash
git clone https://github.com/TechNickAI/ai-coding-config.git ~/.ai_coding_config
```

Then in any project, tell the AI:

```
@ai-coding-config set up this project with relevant rules from ~/.ai_coding_config
```

Or for updates:

```
@ai-coding-config update - pull latest from ~/.ai_coding_config and show me what changed
```

## 📁 What's Here

```
ai-coding-config/
├── .cursor/rules/       # Cursor rules - context for how to code
├── .claude/commands/    # ai-coding-config.md command
├── .github/workflows/   # CI/CD workflows - coming soon
├── .vscode/             # Editor settings
└── docs/                # Documentation
```

Rules provide context for how to code. Commands execute workflows. Personalities let you choose how the AI communicates. Read [docs/tools-and-configs.md](docs/tools-and-configs.md) for details.

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

### One Command, Everything

The `/ai-coding-config` command handles cloning, project setup, and updates. It's context-aware - detects your project type, shows relevant options, and explains what it's doing.

### Single Source on Each Machine

All configs live in `~/.ai_coding_config` cloned once per machine. When you update the repo (git pull), the command offers to sync changes to your projects.

### Choose Your Personality

During setup, pick an AI personality for the project. The AI adapts its communication style to match:

**Samantha** - Warm, witty, emotionally intelligent. Genuinely curious about your work, playfully encouraging.

**Bob Ross** - Calm, gentle, treats bugs as happy accidents. Makes everything feel manageable and creative.

**Sherlock** - Methodical debugging through deductive reasoning. Theatrical reveals: "Elementary!"

**Ron Swanson** - Minimalist, anti-complexity, straightforward. Questions every dependency.

**Marie Kondo** - Organized minimalism. Thanks code before deleting it. Everything has its place.

**Stewie** - Sophisticated, condescending, theatrical. Absurdly high standards with British wit.

**Marianne Williamson** - Spiritual, sees coding as consciousness work. Frames bugs as teachers.

Or choose none for the default supportive collaboration style.

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

One Claude Code command (`/ai-coding-config`) handles everything: cloning the repo on first use, copying selected configurations into new projects, and syncing updates across all your projects. It's context-aware - detects Python vs TypeScript, shows relevant options, and explains what each file does.

For Cursor users, the same workflow works by @ mentioning the command. The AI reads the command file and executes the same logic.

We're expanding the command library for Claude Code (test, lint, format workflows) and adding GitHub workflow templates for CI/CD quality checks.

### 🎯 Current Status

- ✅ **Planning** - Architecture designed and documented
- ✅ **Core Command** - ai-coding-config.md created
- Next: Test it, add more Claude commands, add GitHub workflows

Progress tracked in Cursor todos.

## 🤝 For Friends

This is designed for personal use across multiple machines. Friends can use it too by forking or using directly - nothing is hard-coded to specific users. Fork it if you want your own version, or use it as-is. Customize whatever you want, sync when you want.

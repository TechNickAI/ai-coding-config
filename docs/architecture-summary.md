# Architecture Summary

## The Three Tools

### Cursor IDE

An AI-powered code editor that uses `rules/*.mdc` files for context and guidelines.
Rules guide how the AI codes - they're passive, providing standards and patterns. You
invoke them with `@rule-name` or they apply automatically based on file patterns.

### Cursor CLI

A command-line interface for CI/CD that uses the same `rules/` as the IDE. This runs AI
operations from the terminal, typically with commands like `cursor --command`. It
ensures your automated fixes follow the same standards as your interactive coding.

### Claude Code

A command-line AI coding assistant by Anthropic that uses `.claude/commands/*.md` files
for executable workflows. Commands do things - they're active, running tests or
deployments. You invoke them with `/command-name` in your terminal.

## Rules vs Commands

### Rules (`rules/*.mdc`)

Rules provide context and guidelines. They're passive - they guide AI decisions without
executing anything. Cursor IDE and Cursor CLI both use them. Examples:
`python-coding-standards.mdc` tells the AI how to write Python, `git-commit-message.mdc`
defines commit formats, `django-models.mdc` explains model structure patterns.

### Commands (`.claude/commands/*.md`)

Commands define executable workflows. They're active - they run tasks and show results.
Only Claude Code uses them. Examples: `python-test.md` runs pytest, `python-lint.md`
runs ruff, `deploy.md` handles deployment.

### They Serve Different Purposes

You can't port rules to commands or use commands in Cursor. They're fundamentally
different: rules guide how AI codes, commands execute workflows. Both are valuable, and
they work together naturally - rules ensure quality, commands automate tasks.

## Repository Structure

```
~/.ai_coding_config/
├── .cursor/
│   ├── rules/              # Context for Cursor (IDE + CLI)
│   │   ├── python/
│   │   ├── django/
│   │   └── ...
│   └── settings.json       # Cursor preferences
├── .claude/
│   ├── commands/           # Workflows for Claude Code
│   │   ├── python-test.md
│   │   ├── python-lint.md
│   │   └── ...
│   ├── agents/             # Agent definitions
│   │   ├── test-writer.md
│   │   └── ...
│   └── settings.json       # Claude Code preferences
├── .mcp/servers/           # MCP configs (both tools)
├── prompts/                # AI setup prompts
└── templates/              # Project templates
```

## How Developers Use Both

### Cursor IDE Workflow

```
1. Open Python file
2. python-coding-standards.mdc auto-applies
3. AI suggests code following standards
4. Use Cmd+K for AI edits
5. Use @git-commit-message for commits
```

### Claude Code Workflow

```
1. Write Python code
2. /python-lint - runs ruff
3. /python-test - runs pytest
4. /python-format - formats code
5. Commands execute and show results
```

### Cursor CLI Workflow (CI/CD)

```bash
# In GitHub Actions
cursor --rules rules/ --check src/
# Uses rules to guide AI fixes
```

## What We're Building

### For Cursor Users

Rules: Already have many covering Python, Django, git, and more. Settings: Best practice
configurations for the IDE. CLI configs: Setups for CI/CD use.

### For Claude Code Users

Commands: Python and TypeScript workflows for testing, linting, deployment. Agents:
Specialized assistants for specific tasks. Settings: CLI preferences.

### For Both

MCP Servers work with both tools. Prompts provide AI-guided setup. Templates offer
project starters.

## Key Points

Rules and commands are fundamentally different. Cursor IDE and Cursor CLI share `rules/`
while Claude Code has its own `.claude/commands/`. Agents can be referenced by both
tools - they're markdown files with frontmatter. Never mention `.cursorrules` - it's
deprecated.

## See Also

- [tools-and-configs.md](tools-and-configs.md) - Detailed explanation
- [implementation-plan.md](../implementation-plan.md) - Full plan (needs update)

# AI Coding Ecosystem

This repository supports **Cursor** (IDE and CLI) and **Claude Code** on macOS and
Linux. We don't support Windows, Windsurf, or generic VS Code.

## The Tools

### Claude by Anthropic

Anthropic offers Claude in three forms. The **website** (claude.ai) provides general AI
chat and coding discussions, but requires manual copy-paste between browser and editor.
**Claude Desktop** adds MCP (Model Context Protocol) support, letting Claude access your
filesystem, GitHub, and databases. It's better than the website for development work,
but still separate from your code editor.

**Claude Code** is different. It's a command-line tool that can modify files directly.
You interact through slash commands like `/test` or `/lint`, and the AI executes
workflows rather than just suggesting them. This makes it excellent for automation and
complex multi-step tasks. Claude Code uses configuration files in `.claude/commands/`
for slash commands and `.claude/agents/` for specialized AI assistants.

This repository fully supports Claude Code with command libraries, agent definitions,
and MCP server configurations.

### Cursor by Anysphere

**Cursor IDE** is an AI-powered code editor built on VS Code. It provides inline AI
suggestions as you type (Tab to accept), quick edits with Cmd+K, and a chat interface
that understands your codebase. The rules system in `rules/` guides how the AI codes -
think coding standards, framework patterns, and best practices.

**Cursor CLI** (using the `cursor-agent` command) brings the same AI to your terminal
and CI/CD pipelines. It uses the same `rules/` as the IDE, so your AI behavior stays
consistent whether you're coding interactively or running automated fixes in GitHub
Actions. Install it from [cursor.com/cli](https://cursor.com/cli).

This repository provides comprehensive Cursor configurations including an extensive
rules library for Python and TypeScript projects.

### Other Tools

**Windsurf** by Codeium is similar to Cursor but uses a different configuration system.
We don't support it - supporting both would dilute focus without adding value.

**VS Code** with extensions like Copilot works well, but we only provide basic editor
settings. There's no unified AI configuration system across VS Code extensions, so
there's little we can standardize.

## Tool Comparison

| Feature        | Cursor IDE         | Cursor CLI         | Claude Code         | Claude Desktop      |
| -------------- | ------------------ | ------------------ | ------------------- | ------------------- |
| Type           | Full IDE           | CLI                | CLI                 | Chat App            |
| AI Integration | Native             | Native             | Native              | Native              |
| Configuration  | `rules/`           | Same as IDE        | `.claude/commands/` | MCP only            |
| Primary Use    | Interactive coding | CI/CD              | Agentic workflows   | Research            |
| Cost           | $20/mo             | Included with IDE  | $20/mo              | $20/mo              |
| This Repo      | ✅ Fully supported | ✅ Fully supported | ✅ Fully supported  | ⚠️ MCP configs only |

## What We Support

This repository provides complete configurations for Cursor and Claude Code on macOS and
Linux. For Cursor, you get an extensive rules library that guides AI behavior - coding
standards, framework patterns, testing approaches. For Claude Code, you get executable
commands and specialized agents.

Both tools can use the MCP server configurations we provide. These let Claude Code (and
Claude Desktop) access your filesystem, GitHub repositories, databases, and external
services.

We don't support Windows because it adds significant complexity and we use Unix systems.
We don't support Windsurf because it's too similar to Cursor - better to focus on making
one thing excellent.

## Choosing Your Tools

Use Cursor IDE for day-to-day coding when you want inline AI suggestions and a visual
interface. The rules system keeps AI behavior consistent, and the chat interface is
excellent for larger refactoring tasks.

Use Cursor CLI in CI/CD pipelines. It applies the same rules as the IDE, so your
automated fixes follow the same standards as your interactive coding. This is
particularly useful for fixing lint errors or applying migrations across a codebase.

Use Claude Code for complex multi-step workflows. Its agentic nature means it can run
tests, fix issues, and deploy changes without your intervention. The slash command
interface (`/test`, `/lint`, `/deploy`) makes workflows repeatable and shareable.

Many developers use multiple tools together: Cursor IDE for interactive work, Claude
Code for automation, Cursor CLI for CI/CD. This repository configures all three
consistently.

## Getting Started

Install Cursor IDE from [cursor.com](https://cursor.com). For the CLI, install
`cursor-agent` separately:

```bash
curl https://cursor.com/install -fsS | bash
```

Install Claude Code via npm: `npm install -g @anthropic-ai/claude-code`, or visit
[anthropic.com/claude/code](https://anthropic.com/claude/code) for other installation
methods.

Once you have either tool installed, run our bootstrap script. It clones this repository
to `~/.ai_coding_config`, then uses AI to guide you through configuration. The AI
detects which tools you have and configures them appropriately.

## Why These Choices

We built this repository because we use Cursor and Claude Code daily. Cursor's rules
system solves a real problem - keeping AI behavior consistent across a team and across
projects. Claude Code's agentic approach solves another problem - automating complex
workflows that would otherwise require manual intervention.

We focused on Python and TypeScript because those are the languages we use. Deep support
for two languages is more valuable than shallow support for ten. We focused on macOS and
Linux because that's what we run. Supporting Windows would double the complexity without
helping us.

This is designed for personal use across multiple machines and projects. Friends can use
it by forking or using it directly - nothing is hard-coded to specific users.

## Resources

**Official Documentation**:

- Cursor IDE: [docs.cursor.com](https://docs.cursor.com)
- Cursor CLI: [cursor.com/cli](https://cursor.com/cli)
- Claude Code: [docs.anthropic.com](https://docs.anthropic.com)
- MCP: [modelcontextprotocol.io](https://modelcontextprotocol.io)

**Our Documentation**:

- [tools-and-configs.md](tools-and-configs.md) - Rules vs commands explained
- [architecture-summary.md](architecture-summary.md) - System design
- [implementation-plan.md](../implementation-plan.md) - Technical details
- [README.md](../README.md) - Getting started

## Common Questions

**Can I use this with Windsurf?** No, different configuration system. You'd need to fork
and adapt it.

**What about Windows?** Not supported.

**Do I need both Cursor and Claude Code?** No. Use whichever fits your workflow. Both is
nice but not required.

**What about other languages?** We focus on Python and TypeScript. Fork and extend for
other languages if needed.

---
description: Set up, update, or add AI coding configurations
---

# AI Coding Configuration

Manages reusable AI configurations across machines and projects. The system lives in
`~/.ai_coding_config` and contains Cursor rules, Claude commands, agents, skills,
personalities, and GitHub workflows.

## Usage

- `/ai-coding-config` - Interactive setup for current project
- `/ai-coding-config update` - Update existing configs to latest versions
- `/ai-coding-config add` - Add new command/skill/agent/plugin to the repo

---

## Setup Mode (no arguments)

Walk through setting up AI coding configs for the current project.

### Ensure Local Repository Exists

If `~/.ai_coding_config` doesn't exist, clone it:

```bash
git clone https://github.com/TechNickAI/ai-coding-config.git ~/.ai_coding_config
```

If it exists, update it:

```bash
cd ~/.ai_coding_config && git pull
```

### Understand the Project

Detect what kind of project this is. Be specific about frameworks, not just languages.
Django needs different rules than FastAPI. React differs from Next.js.

Look for existing configurations to avoid duplicates. Understand the project's purpose -
API server, web app, CLI tool?

### Present Relevant Options

Show what's available that matches this project. Group by relevance - framework-specific
first, then universal.

For each option, read the description from frontmatter to explain what it does. Help
users understand their choices, not just list files.

**Rules** - `.cursor/rules/` subdirectories and files

**Personalities** - One personality or none. Common-personality is always included as
baseline. Read `~/.ai_coding_config/.cursor/rules/personalities/` for options.

**Agents** - Specialized AI assistants for specific tasks. Default to all agents -
they're useful for most projects and take minimal space. Read
`~/.ai_coding_config/.claude/agents/` for available agents.

**Skills** - Modular packages extending Claude's capabilities. Default to all skills -
they provide domain expertise useful for most projects. Read
`~/.ai_coding_config/.skills/` for available skills.

**Commands** - Always copy all commands from `~/.ai_coding_config/.claude/commands/` to
both `.claude/commands/` AND create symlinks in `.cursor/commands/` (shared format).

**Standard configs** - VSCode settings, Prettier config, GitHub workflows included by
default.

### Install Selected Configurations

Use `cp` for efficiency. Before copying each file, check if it exists. If it does, use
`diff` to compare. If identical, skip it. If different, show what changed and ask what
to do. Don't silently overwrite. When in doubt, ask.

Copy to these locations:

- Rules → `.cursor/rules/` (preserve subdirectory structure)
- Commands → `.claude/commands/` AND symlinks in `.cursor/commands/`
- Context → `.claude/context.md`
- Selected agents → `.claude/agents/`
- Selected skills → `.skills/` (copy entire directories)
- Common personality → `.cursor/rules/personalities/` (always)
- Additional personality → `.cursor/rules/personalities/` (set `alwaysApply: true`)
- VSCode settings → `.vscode/` (`settings.json`, `extensions.json`)
- Prettier → `.prettierrc` at root
- GitHub workflows → `.github/workflows/` (claude.yml, claude-code-review.yml)
- Gitignore → `.cursor/.gitignore` and `.claude/.gitignore` containing `*.local.json`

Report what was copied, skipped, and how conflicts were handled.

### Verify Installation

Confirm files are where they should be:

- List installed rules (by directory: framework-specific, then universal)
- List commands in `.claude/commands/`
- Confirm symlinks in `.cursor/commands/` point to `.claude/commands/*.md`
- List agents in `.claude/agents/`
- List skills in `.skills/`
- Confirm which personality was selected and `alwaysApply` is set
- Confirm VSCode settings exist
- Confirm `.prettierrc` at root
- List GitHub workflows
- Confirm gitignore files in place

Report a clear summary. No deep validation needed.

---

## Update Mode (`update` argument)

Update existing configs to latest versions from the repo.

### Update Repository

Pull latest changes:

```bash
cd ~/.ai_coding_config && git pull
```

### Self-Update

Compare this command file (`~/.ai_coding_config/.claude/commands/ai-coding-config.md`)
with the project version (`.claude/commands/ai-coding-config.md`). If the repo version
is newer or different, copy it using `cp`, then re-read it to follow latest
instructions.

### Compare and Update

For each config file, use `diff` to see what changed. Categorize as trivial (typos,
comments) or significant.

List files that exist in repo but not in project. List files in project that aren't in
repo (possible local customizations).

Explain what changed and why they might want to update. Let the user choose - "all",
"none", or pick individually. Be careful with customized files.

Copy selected files using `cp`. Don't silently overwrite. Re-verify and highlight what
changed.

---

## Add Mode (`add` argument)

Help contributors add new functionality to the ai-coding-config repo itself.

### Understand What They're Adding

Ask for a description of the functionality. Based on the description, work through
clarifying questions to determine the right mechanism.

### Fetch Claude Code Documentation

Before creating files, fetch the latest Claude Code documentation for the mechanism
you're implementing (commands, skills, agents, or plugins). Get current implementation
details including frontmatter requirements, file structure, and best practices.

### Decision Framework

**Who triggers it?**

- User manually → Command
- Claude autonomously → Skill
- Claude delegates focused work → Agent
- Bundling multiple mechanisms → Plugin

**Does it need isolated context?**

- No → Command or Skill
- Yes → Agent

**Cursor compatibility needed?**

- Commands work in both (native Claude Code, Cursor v1.6+)
- Skills are Claude Code only (create companion Command for Cursor if needed)
- Agents work in Claude Code (Cursor can @ mention agent file paths)
- Plugins are Claude Code only (content works when manually copied to Cursor)

### Ask Clarifying Questions

1. Who should trigger this - user manually, or should Claude decide when to use it?
2. Does it need its own isolated context window, or use the main conversation?
3. Does it need to work in Cursor, or is Claude Code only acceptable?
4. Is this a single capability, or bundling multiple related features?

### Create Files

**For Commands:** Create `.claude/commands/command-name.md` with frontmatter including
description. Commands work in both Claude Code and Cursor.

**For Skills:** Create `.claude/skills/skill-name/SKILL.md` with frontmatter (name,
description). The description is critical - Claude uses it to decide when to activate.
Add supporting files in skill directory if needed. If Cursor compatibility needed, also
create a Command for manual invocation.

**For Agents:** Determine which plugin this belongs to (or create new plugin). Create
`plugins/plugin-name/agents/agent-name.md` with frontmatter (name, description, tools,
model). Agents live in plugins, not in `.claude/agents/`.

**For Plugins:** Create `plugins/plugin-name/` directory structure. Add
`.claude-plugin/plugin.json` manifest. Bundle appropriate commands (via symlinks),
skills, agents, hooks, MCP servers. Add README.md documenting the plugin. Update
`.claude-plugin/marketplace.json` to list the new plugin.

### Verify Implementation

Check that files are in correct locations, frontmatter includes required fields, skill
descriptions clearly define when to activate, commands work when invoked, and plugins
are properly structured.

Explain what was created and how to test it.

---

## Execution Philosophy

Work conversationally, not robotically. Focus on outcomes. Figure out the best approach
for each situation. Show file paths when copying. Let users make all choices. Verify
everything works before finishing.

Respect existing files - always check before overwriting. Use `diff` to understand
differences, then decide intelligently or ask. Better to be thoughtful than fast.

Be helpful explaining choices. Don't just list files - explain what they do and why
someone might want them.

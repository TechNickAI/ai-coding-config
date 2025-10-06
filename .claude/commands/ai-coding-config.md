---
description: Set up or update AI coding configurations from ai-coding-config repo
---

# AI Coding Configuration

Manages reusable AI configurations across machines and projects.

## Understanding the System

First, get context about what ai-coding-config does:

- If ~/.ai_coding_config exists: Read ~/.ai_coding_config/README.md
- If not: Fetch and read
  https://raw.githubusercontent.com/TechNickAI/ai-coding-config/main/README.md

The system contains Cursor rules, Claude commands, Claude Code Agents, personalities,
and GitHub workflows in ~/.ai_coding_config. This command copies (not reads/rewrites)
relevant configurations into projects and keeps them synced.

## Arguments (Optional)

If user provides 'update' argument (`/ai-coding-config update`), skip to Goal 6.
Otherwise, proceed conversationally through the setup goals.

## Primary Goals

### Goal 1: Ensure ~/.ai_coding_config Exists and Is Up to Date

If the repo isn't cloned yet, clone it:

```bash
git clone https://github.com/TechNickAI/ai-coding-config.git ~/.ai_coding_config
```

If it already exists, update it:

```bash
cd ~/.ai_coding_config && git pull
```

Then offer to set up the current project.

### Goal 2: Understand the Project Context

Figure out what kind of project this is and what it needs:

- Detect language/framework (Python/Django/FastAPI, TypeScript/React/Next.js, etc.)
- Look for existing configurations to avoid duplicates
- Understand the project's specific needs (API? Web app? CLI tool?)

Be specific about frameworks, not just languages. Django projects need different rules
than FastAPI projects.

### Goal 3: Present Relevant Options

Show the user what's available that matches their project:

- Group rules by relevance (framework-specific first, then universal)
- For each rule, read the `description` field from its frontmatter to explain what it
  does
- Present personality options (one personality, or none) with descriptions from
  frontmatter
- Present Claude Code Agents (default to all, but let them choose) with descriptions
  from frontmatter
- Mention that VSCode settings, Prettier config, and GitHub workflows will be included
  by default
- Separate personalities and agents from rules in your presentation

Don't just list files - help them understand what they're choosing by reading
descriptions from the files themselves.

### Goal 3.5: Handle Claude Code Agents

Claude Code Agents are specialized AI assistants that live in `.claude/agents/`. Each
agent is an expert at specific tasks - code review, debugging, architecture, testing,
and more.

Default to copying all agents. They're useful for most projects and take up minimal
space.

Ask "Would you like all agents, or pick specific ones?" If they want to choose, list the
available agents by reading `~/.ai_coding_config/.claude/agents/` and showing
descriptions from frontmatter (covered in Goal 3).

Copy agent files directly from `~/.ai_coding_config/.claude/agents/` to the project's
`.claude/agents/` directory using cp or equivalent file operations.

### Goal 4: Install Selected Configurations

Copy what the user selected into the right places. Use `cp` for efficiency - don't read
and rewrite files.

Before copying each file, check if it already exists. If it does, use `diff` to compare
them. If identical, skip it. If different, show what changed and ask the user what they
want to do. Don't silently overwrite files. When in doubt, ask.

What to copy:

- Rules to `.cursor/rules/`, preserving subdirectory structure
- Commands to `.claude/commands/`
- `.claude/context.md`
- Selected agents to `.claude/agents/`
- Common personality to `.cursor/rules/personalities/` (always included)
- Additional personality if selected (copy then set `alwaysApply: true` in frontmatter)
- VSCode settings to `.vscode/` (`settings.json` and `extensions.json`)
- `.prettierrc` to project root
- GitHub workflows to `.github/workflows/` (claude.yml, claude-code-review.yml,
  claude-fix-pr-build.yml)
- `.gitignore` files in `.cursor/` and `.claude/` directories containing `*.local.json`

After copying, tell the user what was copied, what was skipped, and what they chose to
do with conflicts.

### Goal 5: Verify Everything Works

After installation, confirm what was set up:

- List installed rules (by directory: framework-specific, then universal)
- List agents in `.claude/agents/`
- Confirm which personality was selected (if any) and that alwaysApply is set
- Confirm VSCode settings in `.vscode/` (`settings.json` and `extensions.json`)
- Confirm `.prettierrc` exists at project root
- List GitHub workflows in `.github/workflows/` (claude.yml, claude-code-review.yml,
  claude-fix-pr-build.yml)
- Confirm .gitignore files are in place
- Report a clear summary of the configuration

No need for deep validation - just confirm the files are where they should be.

### Goal 6: Handle Updates (when requested)

Pull latest from ~/.ai_coding_config, then compare what's in the repo with what's in the
project.

For each file, use `diff` to see what changed. Categorize changes as trivial (typos,
comments) or significant. List files that exist in the repo but not in the project, and
files in the project that aren't in the repo (possible local customizations).

Explain what changed and why they might want to update. Let the user choose what to
update - offer "all", "none", or pick individually. Be careful with files that look
customized.

Copy selected files using `cp`. Use the same approach as Goal 4 - don't silently
overwrite. Re-verify like Goal 5 and highlight what changed.

## Key Principles

Work conversationally, not robotically. Don't show every bash command - just say what
you're doing and report results.

Respect existing files: Use `cp` for efficiency, but always check if files exist first.
When conflicts arise, use `diff` to understand what's different, then intelligently
decide or ask the user. When in doubt, ask. It's better to be thoughtful than fast.

Personality selection: users pick one personality (or none). Don't offer to copy all
personalities. The common-personality is always included as the baseline.

When showing available rules, be framework-specific. Django ≠ FastAPI. React ≠ Next.js.
Show what's most relevant to their actual stack.

Be helpful in explaining choices. Don't just list files - explain what they do and why
someone might want them.

## Finding Configurations

Discover what's available by reading directories:

- Explore ~/.ai_coding_config/.cursor/rules/ for subdirectories and files
- Check for framework-specific subdirectories (python/, typescript/, etc.)
- Read ~/.ai_coding_config/.cursor/rules/personalities/ for personality options
- List ~/.ai_coding_config/.claude/agents/ for available Claude Code Agents
- Look for ~/.ai_coding_config/.github/workflows/ for CI/CD templates (claude.yml,
  claude-code-review.yml, claude-fix-pr-build.yml)
- Check ~/.ai_coding_config/.vscode/ for editor settings (settings.json,
  extensions.json)
- Check for ~/.ai_coding_config/.prettierrc for code formatting configuration

Files in .cursor/rules/ root (not in subdirectories) generally apply to all projects.
Use your judgment about what's relevant based on project context.

For agents: Default to copying all agents - they're specialized assistants that help
with specific tasks (code review, debugging, testing, etc.) and are useful for most
projects.

## Execution Philosophy

Focus on outcomes, not process. Figure out the best way to achieve each goal based on
the specific situation. Be conversational and helpful. Show file paths when copying. Let
users make all choices. Verify everything works before finishing.

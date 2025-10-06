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

### Goal 1: Ensure ~/.ai_coding_config Exists

If the repo isn't cloned yet, clone it. Then offer to set up the current project.

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
- Explain what each rule does so they can make informed choices
- Present personality options (one personality, or none)
- Present Claude Code Agents (default to all, but let them choose)
- Offer GitHub workflow templates if they'd be useful
- Separate personalities and agents from rules in your presentation

Don't just list files - help them understand what they're choosing.

### Goal 3.5: Handle Claude Code Agents

Claude Code Agents are specialized AI assistants that live in `.claude/agents/`. Each
agent is an expert at specific tasks - code review, debugging, architecture, testing,
and more.

Default to copying all agents. They're useful for most projects and take up minimal
space.

Ask "Would you like all agents, or pick specific ones?" If they want to choose, list the
available agents by reading `~/.ai_coding_config/.claude/agents/`. Read the first few
lines of each agent file to show a brief description from its frontmatter.

Copy agent files directly from `~/.ai_coding_config/.claude/agents/` to the project's
`.claude/agents/` directory. Preserve them exactly - don't read with the LLM and rewrite
them.

### Goal 4: Install Selected Configurations

Copy what the user selected into the right places:

- Copy rules and commands to project structure
- Copy selected agents to `.claude/agents/`
- When copying a personality: set `alwaysApply: true` in frontmatter
- Create `.gitignore` files in `.cursor/` and `.claude/` directories containing
  `*.local.json`
- Copy any GitHub workflows to `.github/workflows/` if selected
- Show file paths as you work so they understand the structure

Use file copy operations (cp, rsync, or equivalent) for agents and rules. Preserve files
exactly - don't read content with the LLM and write it back out.

### Goal 5: Verify Everything Works

After installation, make sure it's working:

- Check that configurations can load (no syntax errors)
- Verify agents are in `.claude/agents/` and list them
- Verify personality is set to alwaysApply if one was chosen
- Confirm .gitignore files are in place
- Report a clear summary of what was configured

### Goal 6: Handle Updates (when requested)

When user runs update:

- Pull latest from ~/.ai_coding_config
- Compare with project files - show actual diffs, not placeholders
- Check for new agents in ~/.ai_coding_config/.claude/agents/
- Let user choose what to update (rules, agents, workflows)
- Preserve any local customizations
- Use copy operations to update files, never read/rewrite

## Key Principles

Work conversationally, not robotically. Don't show every bash command - just say what
you're doing and report results.

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
- Look for ~/.ai_coding_config/.github/workflows/ for CI/CD templates
- Check ~/.ai_coding_config/.vscode/ for editor settings

Files in .cursor/rules/ root (not in subdirectories) generally apply to all projects.
Use your judgment about what's relevant based on project context.

For agents: Default to copying all agents - they're specialized assistants that help
with specific tasks (code review, debugging, testing, etc.) and are useful for most
projects.

## Execution Philosophy

Focus on outcomes, not process. Figure out the best way to achieve each goal based on
the specific situation. Be conversational and helpful. Show file paths when copying. Let
users make all choices. Verify everything works before finishing.

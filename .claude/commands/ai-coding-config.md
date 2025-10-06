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

The system contains Cursor rules, Claude commands, personalities, and GitHub workflows
in ~/.ai_coding_config. This command helps copy relevant configurations into projects
and keeps them synced.

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
- Present personality options (ONE personality, or none)
- Offer GitHub workflow templates if they'd be useful
- Separate personalities from rules in your presentation

Don't just list files - help them understand what they're choosing.

### Goal 4: Install Selected Configurations

Copy what the user selected into the right places:

- Copy rules and commands to project structure
- When copying a personality: set `alwaysApply: true` in frontmatter
- Create `.gitignore` files in `.cursor/` and `.claude/` directories containing
  `*.local.json`
- Copy any GitHub workflows to `.github/workflows/` if selected
- Show file paths as you work so they understand the structure

### Goal 5: Verify Everything Works

After installation, make sure it's working:

- Check that configurations can load (no syntax errors)
- Verify personality is set to alwaysApply if one was chosen
- Confirm .gitignore files are in place
- Report a clear summary of what was configured

### Goal 6: Handle Updates (when requested)

When user runs update:

- Pull latest from ~/.ai_coding_config
- Compare with project files - show actual diffs, not placeholders
- Let user choose what to update
- Preserve any local customizations

## Key Principles

Work conversationally, not robotically. Don't show every bash command - just say what
you're doing and report results.

Personality selection: users pick ONE personality (or none). Don't offer to copy all
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
- Look for ~/.ai_coding_config/.github/workflows/ for CI/CD templates
- Check ~/.ai_coding_config/.vscode/ for editor settings

Files in .cursor/rules/ root (not in subdirectories) generally apply to all projects.
Use your judgment about what's relevant based on project context.

## Execution Philosophy

Focus on outcomes, not process. Figure out the best way to achieve each goal based on
the specific situation. Be conversational and helpful. Show file paths when copying. Let
users make all choices. Verify everything works before finishing.

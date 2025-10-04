---
description: Set up or update AI coding configurations from ai-coding-config repo
allowed-tools: read_file, write, list_dir, search_replace, grep, glob_file_search, run_terminal_cmd
---

# AI Coding Configuration

Manages AI coding configurations across machines and projects.

## Context Awareness

Check if ~/.ai_coding_config exists:

If NO - First time setup for this machine:

1. Fetch and read https://raw.githubusercontent.com/TechNickAI/ai-coding-config/main/README.md to understand what this system does
2. Explain briefly: "This clones a repository of reusable AI configurations - Cursor rules, Claude commands, GitHub workflows, and personality options"
3. Clone: git clone https://github.com/TechNickAI/ai-coding-config.git ~/.ai_coding_config
4. Ask if they want to set up current project now or later

If YES - Check if current directory has .cursor/ or .claude/:

- Has configs: Offer updates
- No configs: Offer new project setup
- User said "update": Run update flow

## New Project Setup

Detect project type by looking for:

- Python: pyproject.toml, requirements.txt, manage.py
- TypeScript: package.json, tsconfig.json
- Django: manage.py, settings.py

Show and explain what's available from ~/.ai_coding_config:

For Python:

- .cursor/rules/python/ - Python coding standards, pytest patterns, celery structure
- .cursor/rules/django/ - Django models, commands, templates (if Django detected)
- .cursor/rules/observability/ - Logging and error tracking

For TypeScript:

- .cursor/rules/frontend/ - React components, n8n workflows

Universal:

- .cursor/rules/git-commit-message.mdc - Commit message guidelines
- .cursor/rules/naming-stuff.mdc - Naming conventions
- .cursor/rules/user-facing-language.mdc - Writing docs and UI text
- .cursor/rules/prompt-engineering.mdc - Writing prompts for AI

Ask which configurations they want copied.

Offer personalities:
"Want to choose an AI personality? Check what's available:"

List ~/.ai_coding_config/.cursor/rules/personalities/ directory (excluding common-personality.mdc which is always included).

For each file found, show the description from frontmatter and the first line after the # heading.

Example: "samantha.mdc - Warm, witty, emotionally intelligent companion"

Let them choose multiple personalities if desired.

Copy selected files:

- Create .cursor/rules/ and subdirectories
- Copy selected rules
- Always copy common-personality.mdc to .cursor/rules/personalities/
- Copy chosen personalities to .cursor/rules/personalities/
- Copy .vscode/ settings if they want

Update .gitignore:
Add these lines if not present:

```
.cursor/settings.local.json
.claude/settings.local.json
```

Confirm what was set up:
"Copied [list of rules] and [list of personalities].

The common-personality (gratitude-focused, supportive) is always active.
Invoke optional personalities with @personality-name when you want that style.

Run /ai-coding-config update when you want to sync latest changes."

## Update Existing Project

Run: cd ~/.ai_coding_config && git pull

Compare project files with repo:

- Check .cursor/rules/ against ~/.ai_coding_config/.cursor/rules/
- Check .cursor/rules/personalities/ against ~/.ai_coding_config/.cursor/rules/personalities/

Show changes:
"Found updates:

New personalities available:

- bob-ross.mdc - Calm, treats bugs as happy accidents
- marie-kondo.mdc - Joyful tidying and organization

Changed rules:

- git-commit-message.mdc - Added [no-deploy] marker guidance
- user-facing-language.mdc - Now emphasizes prose over lists

Want to add personalities? Update rules?"

Apply selected updates by copying files.

## Error Handling

If git clone fails: Show error, suggest checking network or repo URL

If git pull fails: Show error, suggest cd ~/.ai_coding_config && git status

If copy fails: Show error and path that failed

## Implementation Notes

Be conversational and explain what you're doing.

Show actual file paths so users understand the structure.

Let users choose everything - no forced configurations.

Personalities should be presented as fun choices that affect communication style.

Always copy common-personality.mdc - it's the baseline supportive style.

For Cursor users, explain they can @mention personalities to invoke them.

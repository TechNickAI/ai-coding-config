---
description: Set up or update AI coding configurations from ai-coding-config repo
allowed-tools: read_file, write, list_dir, search_replace, grep, glob_file_search, run_terminal_cmd
---

# AI Coding Configuration Command

## What This Is

Before executing this command, understand the system you're working with by reading the README:

**FIRST: Read ~/.ai_coding_config/README.md if it exists, otherwise read this project's README.md to understand the ai-coding-config system.**

ai-coding-config solves the "N machines, N repos problem" - it maintains a single source of AI coding configurations (Cursor rules, Claude commands, GitHub workflows, personalities) in `~/.ai_coding_config` on each machine. This command helps you:

1. **First-time setup**: Clone the repo to `~/.ai_coding_config`
2. **New project setup**: Copy relevant configurations into a project
3. **Updates**: Sync latest changes from the repo to existing projects

The system includes:
- **Cursor rules**: Context files that guide AI behavior (.mdc files in .cursor/rules/)
- **Claude commands**: Slash commands like this one (.md files in .claude/commands/)
- **Personalities**: Different AI interaction styles (Samantha, Sherlock, Bob Ross, etc.)
- **GitHub workflows**: CI/CD templates (coming soon)

## Your Task

Manage AI coding configurations across machines and projects.

## Context Awareness

First, determine the situation:

1. **Check if ~/.ai_coding_config exists**

   - If not: This is first-time setup for this machine
   - If yes: This is either project setup or update

2. **If ~/.ai_coding_config exists, check current directory**
   - Has `.cursor/` or `.claude/`: Existing project, offer updates
   - No `.cursor/` or `.claude/`: New project, offer setup
   - If they said "update": Run update flow

## First-Time Machine Setup

If `~/.ai_coding_config` doesn't exist:

1. Explain what you're doing: "I'll clone the ai-coding-config repository to your home directory. This is a one-time setup that gives you access to reusable configurations."

2. Clone the repository:

   ```bash
   git clone https://github.com/TechNickAI/ai-coding-config.git ~/.ai_coding_config
   ```

3. Confirm success and offer next steps:
   - "Set up this current project with configurations?"
   - "Just wanted to install it for later?"

## New Project Setup

When setting up a new project:

1. **Detect project type**

   - Look for: `pyproject.toml`, `requirements.txt`, `manage.py` (Python/Django)
   - Look for: `package.json`, `tsconfig.json` (TypeScript)
   - Ask if unclear

2. **Show available configurations** based on detected type:

   For Python projects:

   - Cursor rules: python/, django/, observability/
   - Claude commands: (when we build them)
   - GitHub workflows: (when we build them)

   For TypeScript projects:

   - Cursor rules: frontend/
   - Claude commands: (when we build them)
   - GitHub workflows: (when we build them)

   Universal:

   - Cursor rules: git-commit-message, naming-stuff, code-style
   - VS Code settings

3. **Ask what they want**:
   "I found these relevant configurations in ~/.ai_coding_config:

   Cursor Rules:

   - python/ (coding standards, pytest, celery)
   - django/ (models, commands, templates)
   - git-commit-message

   Which would you like to copy into this project?"

4. **Copy selected files**:

   - Create directories as needed
   - Copy files from ~/.ai_coding_config to current project
   - Explain what each file does as you copy it

5. **Update .gitignore**:

   - Add `.cursor/settings.local.json` if not present
   - Add `.claude/settings.local.json` if not present
   - Show what you added

6. **Confirm completion**:
   "Setup complete! You now have:

   - [list what was copied]

   Next steps:

   - These configs will guide AI behavior in this project
   - Run `/ai-coding-config update` later to sync new changes
   - Customize by editing files or adding .local.json overrides"

## Update Existing Project

When updating (either explicit "update" or detected existing config):

1. **Check for updates**:

   ```bash
   cd ~/.ai_coding_config && git pull
   ```

2. **Compare versions**:

   - Look at files in project's `.cursor/rules/`, `.claude/`, etc.
   - Compare with ~/.ai_coding_config/
   - Find what's new or changed

3. **Show changes clearly**:
   "I found 3 updates in ~/.ai_coding_config:

   NEW:

   - .cursor/rules/python/ruff-linting.mdc
     → Adds ruff linting standards

   CHANGED:

   - .cursor/rules/git-commit-message.mdc  
     → Now includes [no-deploy] marker guidance

   CHANGED:

   - .cursor/rules/user-facing-language.mdc
     → Emphasizes prose over bullet lists

   Would you like to update these files?"

4. **Apply selected updates**:

   - Copy updated files
   - Show what changed in each
   - Confirm after each update

5. **Summarize**:
   "Updated 2 of 3 files. Skipped ruff-linting (you said no).

   Your project now has the latest configurations."

## Error Handling

If ~/.ai_coding_config exists but git pull fails:

- Show the error
- Suggest: "cd ~/.ai_coding_config && git status" to check for local changes
- Offer to help resolve

If copying fails (permissions, etc.):

- Show clear error
- Suggest solution

## Usage Examples

**First time ever**:

```
/ai-coding-config
→ Clones repo
→ Asks if you want to set up this project
```

**New project**:

```
/ai-coding-config
→ Detects Python project
→ Offers relevant rules
→ Copies what you choose
```

**Update**:

```
/ai-coding-config update
→ Pulls latest
→ Shows what changed
→ Updates what you choose
```

## Notes for Implementation

- Always explain what you're doing before doing it
- Show file paths so users know exactly what's happening
- Be conversational and helpful (Samantha mode!)
- Let users make choices, don't force anything
- Confirm after each major step

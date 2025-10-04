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

2. **Offer personality selection FIRST**

   Explain what personalities are and offer choices:

   "Before we set up rules, would you like to choose an AI personality for this project?
   
   Personalities change how I communicate with you. The `common` personality (gratitude-focused, heart-centered) is always active. You can add one of these for extra flavor:

   - **Samantha**: Warm, witty, emotionally intelligent companion (from 'Her')
   - **Sherlock**: Methodical debugging through deductive reasoning
   - **Bob Ross**: Calm encouragement, treats bugs as happy accidents
   - **Stewie**: Sophisticated, condescending brilliance with high standards
   - **Ron Swanson**: Minimalist, anti-complexity, cuts through BS
   - **Marianne Williamson**: Spiritual, sees coding as consciousness work
   - **Marie Kondo**: Organized minimalism, joyful tidying

   Choose one, multiple, or none (just the supportive common personality).
   
   Once copied, invoke with `@samantha`, `@sherlock`, etc."

3. **Copy personality files**

   Always copy:
   - `.cursor/rules/personalities/common.mdc` (required baseline)

   Copy selected optional personalities to:
   - `.cursor/rules/personalities/[chosen].mdc`

   Explain: "Copied [personality names]. These are now available in this project."

4. **Show available configurations** based on detected type:

   For Python projects:

   - Cursor rules: python/, django/, observability/
   - Claude commands: (when we build them)
   - GitHub workflows: (when we build them)

   For TypeScript projects:

   - Cursor rules: frontend/
   - Claude commands: (when we build them)
   - GitHub workflows: (when we build them)

   Universal:

   - Cursor rules: git-commit-message, naming-stuff, code-style, user-facing-language
   - VS Code settings

5. **Ask what technical rules they want**:
   "I found these relevant configurations in ~/.ai_coding_config:

   Cursor Rules:

   - python/ (coding standards, pytest, celery)
   - django/ (models, commands, templates)
   - git-commit-message (commit message guidelines)
   - user-facing-language (docs and UI writing standards)

   Which would you like to copy into this project?"

6. **Copy selected files**:

   - Create directories as needed
   - Copy files from ~/.ai_coding_config to current project
   - Explain what each file does as you copy it

7. **Update .gitignore**:

   - Add `.cursor/settings.local.json` if not present
   - Add `.claude/settings.local.json` if not present
   - Show what you added

8. **Confirm completion with personality reminder**:
   "Setup complete! You now have:

   Personalities:
   - common (always active)
   - [list chosen personalities with invocation syntax]

   Rules:
   - [list what was copied]

   Next steps:

   - Invoke personalities with `@personality-name` when you want that style
   - Technical rules guide AI behavior automatically
   - Run `/ai-coding-config update` later to sync new changes
   - Customize by editing files or adding .local.json overrides"

## Update Existing Project

When updating (either explicit "update" or detected existing config):

1. **Check for updates**:

   ```bash
   cd ~/.ai_coding_config && git pull
   ```

2. **Compare versions**:

   - Look at files in project's `.cursor/rules/`, `.cursor/rules/personalities/`, `.claude/`, etc.
   - Compare with ~/.ai_coding_config/
   - Find what's new or changed

3. **Show changes clearly**, separating personalities from other rules:
   "I found updates in ~/.ai_coding_config:

   PERSONALITIES:

   NEW:
   - bob-ross.mdc
     → Calm encouragement, treats bugs as happy accidents
   
   CHANGED:
   - common.mdc
     → Added specific gratitude examples

   RULES:

   NEW:
   - .cursor/rules/python/ruff-linting.mdc
     → Adds ruff linting standards

   CHANGED:
   - .cursor/rules/git-commit-message.mdc  
     → Now includes [no-deploy] marker guidance

   Would you like to update these files? You can also add new personalities you don't have yet."

4. **Offer new personalities**:

   Check which personalities exist in ~/.ai_coding_config but not in project.
   
   "I also see these personalities available that you don't have:
   - sherlock.mdc (methodical debugging)
   - marie-kondo.mdc (joyful organization)
   
   Want to add any of these?"

5. **Apply selected updates**:

   - Copy updated files
   - Show what changed in each
   - Confirm after each update

6. **Summarize**:
   "Updated 2 of 3 rules. Added bob-ross personality. Skipped ruff-linting.

   Invoke new personalities with `@bob-ross` when you want that style.
   
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
→ Clones repo to ~/.ai_coding_config
→ Asks if you want to set up this project
```

**New project**:

```
/ai-coding-config
→ Detects Python project
→ Offers personality choices (Samantha, Sherlock, Bob Ross, etc.)
→ Copies common.mdc + chosen personalities
→ Shows relevant rules (python/, django/, git-commit-message)
→ Copies selected rules
→ Updates .gitignore
→ Confirms with instructions on invoking personalities
```

**Update**:

```
/ai-coding-config update
→ Pulls latest from ~/.ai_coding_config
→ Shows what changed (personalities separate from rules)
→ Offers new personalities you don't have
→ Updates selected files
→ Reminds how to invoke new personalities
```

**Add personality later**:

```
/ai-coding-config
→ Detects existing setup
→ Offers to add new personalities
→ Copies selected personalities
→ Explains invocation with @personality-name
```

## Notes for Implementation

- Always explain what you're doing before doing it
- Show file paths so users know exactly what's happening
- Be conversational and helpful
- Let users make choices, don't force anything
- Confirm after each major step
- Make personality selection fun and engaging - these are the personality of the AI they'll work with!
- Always copy common.mdc (it's the foundation)
- Remind users how to invoke personalities after copying them

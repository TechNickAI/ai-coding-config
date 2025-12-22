---
description: Set up or update AI coding configurations
argument-hint: [update]
version: 3.0.0
---

# AI Coding Configuration

Plugin-first AI coding configurations for Claude Code, Cursor, and other AI coding tools.
The marketplace lives at `https://github.com/TechNickAI/ai-coding-config`.

## Usage

- `/ai-coding-config` - Interactive setup for current project
- `/ai-coding-config update` - Update plugins and configs to latest versions

## Interaction Guidelines

Use AskUserQuestion when presenting discrete choices that save the user time (selecting
tools, personalities, handling conflicts). This lets users quickly click options while
still allowing free-form text via "Other".

## Shell and Tool Best Practices

**Prefer native tools over bash for file inspection.** The Read and Grep tools are more
reliable than bash commands for checking file contents and versions. They don't have
working directory issues and work consistently across environments.

**Never change working directory with `cd`.** Use absolute paths for all file
operations. Changing directories can break git hooks that expect to run from the project
root. If you need to run a command in a different directory, use a subshell or absolute
paths rather than `cd && command`.

**Avoid bash loops entirely.** For loops and while loops are fragile across different
shell environments. Instead of iterating over files in bash, use the Glob tool to list
files, then process them one at a time with Read or individual bash commands. Multiple
simple commands are more reliable than one complex loop.

**When bash fails, switch tools.** If a bash command fails due to hook errors, path
issues, or parse errors, don't retry with variations. Switch to native tools (Read,
Grep, Glob) which don't have these failure modes.

---

<setup-mode>

<tool-detection>
Detect which AI coding tools the user has. Check for:

```bash
# Detection commands
test -d .cursor && echo "cursor"
test -d .claude && echo "claude-code"
test -f .aider.conf.yml && echo "aider"
test -d .continue && echo "continue"
```

Based on detection, use AskUserQuestion to confirm which tools to set up. Pre-select
detected tools. Options:

- Claude Code (plugin marketplace - auto-updates)
- Cursor (rules + commands copied to project)
- Aider (AGENTS.md context)
- Other (explain what you're using)

If ONLY Claude Code detected (no Cursor), offer a pure plugin installation that skips
rule files entirely.

</tool-detection>

<repository-management>
Ensure `~/.ai_coding_config` exists and is up to date. Clone if missing, pull latest if
exists.

```bash
if [ -d ~/.ai_coding_config ]; then
  cd ~/.ai_coding_config && git pull
else
  git clone https://github.com/TechNickAI/ai-coding-config.git ~/.ai_coding_config
fi
```

</repository-management>

<claude-code-setup>
For Claude Code users, guide them through the plugin marketplace:

1. Explain the plugin system: "Claude Code uses a plugin marketplace. You can install
   the plugins you want, and they'll stay updated automatically."

2. Show available plugins from `~/.ai_coding_config/.claude-plugin/marketplace.json`:
   - **ai-coding-config** - Commands, agents, and skills for AI-assisted development
   - **personality-{name}** - Pick one that matches your style

3. Provide the commands to add the marketplace and install plugins:

```bash
# Add the marketplace (one time)
/plugin marketplace add https://github.com/TechNickAI/ai-coding-config

# Install the core plugin
/plugin install ai-coding-config

# Optional: Install a personality
/plugin install personality-samantha
```

4. Use AskUserQuestion to present personality options with descriptions from the
   marketplace.json file.

</claude-code-setup>

<cursor-setup>
For Cursor users, copy files to the project. Cursor needs files physically present in
the repository for portability and team collaboration.

<existing-config-detection>
Before installing, detect what already exists:

1. **Fresh project** (no existing configs)
   - Create `.cursor/rules/` and `.cursor/commands/` directories
   - Create `AGENTS.md`, symlink `CLAUDE.md` → `AGENTS.md`

2. **Existing rules, no AI coding config yet**
   - Has `.cursor/rules/` as real directory
   - Offer choice: merge new rules alongside existing OR skip rule installation
   - ALWAYS preserve existing rules and commands

3. **Already has AI coding config**
   - Check for existing copied files from `~/.ai_coding_config`
   - Proceed with update/refresh via version comparison

Detection:

```bash
test -d .cursor/rules && echo "has .cursor/rules"
test -d .cursor/commands && echo "has .cursor/commands"
test -f AGENTS.md && echo "has AGENTS.md"
```

</existing-config-detection>

<file-installation>
Copy files from `~/.ai_coding_config/` to project for portability:

- Rules: `~/.ai_coding_config/.cursor/rules/` → `.cursor/rules/`
- Commands: `~/.ai_coding_config/plugins/core/commands/` → `.cursor/commands/`
- Personality: ONE selected file → `.cursor/rules/personalities/`

Cursor does not support agents or skills directories.

Handle conflicts with AskUserQuestion: overwrite, skip, show diff.
</file-installation>

</cursor-setup>

<project-understanding>
Detect project type: Django, FastAPI, React, Next.js, etc. Look for package.json,
requirements.txt, pyproject.toml, existing configs. Understand purpose: API server, web
app, CLI tool.
</project-understanding>

<personality-selection>
Use AskUserQuestion to present personality options:

- **Samantha** - Warm, witty, emotionally intelligent, playfully flirty
- **Sherlock** - Analytical, precise, deductive reasoning
- **Bob Ross** - Calm, encouraging, treats bugs as happy accidents
- **Marie Kondo** - Organized, joyful minimalism
- **Ron Swanson** - Minimalist, anti-complexity, practical
- **Stewie** - Sophisticated, theatrical, brilliant
- **Luminous** - Heart-centered, spiritual, love-based
- **None** - Use default Claude personality

For Claude Code: Install the selected personality plugin via marketplace.

For Cursor: Copy the ONE selected personality file to `.cursor/rules/personalities/` and
set `alwaysApply: true` in its frontmatter. Only one personality should be active.

Source files are in `~/.ai_coding_config/plugins/personalities/personality-{name}/`.
</personality-selection>

<installation-verification>
Confirm files are in expected locations. For Claude Code, confirm plugins are installed.
For Cursor, confirm copied files exist in `.cursor/rules/` and `.cursor/commands/`.
</installation-verification>

<recommendations>
Provide a warm summary of what was installed.

For Claude Code users: "You're set up with the ai-coding-config plugin marketplace.
Installed: [list plugins]"

For Cursor users: "Your project is configured with [X] rules and [Y] commands."

Key commands to highlight:

- `/autotask "your task"` - Autonomous development
- `/address-pr-comments` - PR cleanup on autopilot
- `/load-rules` - Smart context loading

End with: "Run `/ai-coding-config update` anytime to get the latest improvements."
</recommendations>

</setup-mode>

---

<update-mode>
Update all configurations to latest versions.

<marketplace-update>
Update the Claude Code plugin marketplace first. This pulls the latest plugin definitions and updates any installed plugins.

The `/plugin` command is a native Claude Code CLI command that only works at the terminal level. Since this command executes within Claude Code itself, we invoke the CLI via bash using the `claude` command:

```bash
claude /plugin marketplace update ai-coding-config
```

This tells the Claude Code CLI to update the marketplace at `~/.claude/plugins/marketplaces/ai-coding-config/` and refresh all installed plugins.

</marketplace-update>

<repository-update>
For bootstrap users (Cursor-only or manual setup), pull latest from `~/.ai_coding_config`:

```bash
cd ~/.ai_coding_config && git pull
```

</repository-update>

<self-update-check>
After pulling from the repository, detect if this command file (commands/ai-coding-config.md) was updated. If it was, read the new version and continue executing with the updated instructions.
</self-update-check>

<plugin-migration-check>
Dynamically detect and clean up deprecated or renamed plugins.

**Detection method:**

1. Read `~/.claude/plugins/installed_plugins.json` to find all plugins installed from the `ai-coding-config` marketplace (keys ending in `@ai-coding-config`)

2. Read the current marketplace.json from the repo at `~/.ai_coding_config/.claude-plugin/marketplace.json` to get the list of valid plugin names

3. Compare: Any installed plugin name that doesn't exist in the current marketplace = deprecated/removed

This approach is future-proof and doesn't require maintaining a hardcoded list.

**Migration execution:**

For each deprecated plugin found:

1. Try to uninstall it: `claude plugin uninstall {plugin}@ai-coding-config`

2. If uninstall fails (plugin already gone from marketplace), manually remove the entry from `~/.claude/plugins/installed_plugins.json`

3. After cleanup, install the current plugins that aren't already installed

**Error handling:** If install fails with "Unrecognized key" errors, the plugin manifest format may be incompatible with the current Claude Code version. Report this to the user and suggest they update Claude Code or file an issue on the ai-coding-config repository.

Offer: "Clean up deprecated plugins (Recommended)" or "Skip cleanup"
</plugin-migration-check>

<local-duplicate-cleanup>
Check for local file duplication when marketplace plugins are installed.

**Detection method:** Read `~/.claude/plugins/installed_plugins.json` to see if marketplace plugins are installed (ai-coding-config, agents, skills). If plugins are installed, check if the user also has local copies in their project.

Check for these local directories:
- `.claude/commands/` (as a real directory, not symlink)
- `.claude/agents/` (as a real directory, not symlink)
- `.claude/skills/` (as a real directory, not symlink)

**Why this happens:** Some projects were set up before the marketplace approach. They have local copies of commands/agents/skills that are now outdated and create confusion because they override the marketplace versions.

**Critical constraint:** Only remove files that are duplicates of marketplace content. Preserve any custom commands, agents, or skills the user created themselves.

**Duplicate identification strategy:**

For each directory type (commands, agents, skills):
1. Use Glob to list files in the marketplace plugin install path
2. Use Glob to list files in the local project directory
3. Compare the two lists to identify exact filename matches
4. Only remove the duplicates

Example paths to check:
- Commands: `~/.claude/plugins/cache/ai-coding-config/core/*/commands/` vs `.claude/commands/`
- Agents: `~/.claude/plugins/cache/ai-coding-config/core/*/agents/` vs `.claude/agents/`
- Skills: `~/.claude/plugins/cache/ai-coding-config/core/*/skills/` vs `.claude/skills/`

Get the plugin version from installed_plugins.json to construct the correct path.

**Exception:** Never remove `.claude/commands/ai-coding-config.md` even if it's a duplicate - this file needs to stay in the project.

**User communication and choice:**

If duplicates are found, explain the situation clearly:

"I found duplicate files in your project. You have local copies of commands/agents/skills that are also available through the Claude Code plugin marketplace.

**What's the plugin marketplace?**

The Claude Code plugin marketplace is a centralized system where commands, agents, and skills are installed once globally and automatically stay up to date. Instead of copying files into each project, plugins are installed to `~/.claude/plugins/` and shared across all your projects.

Benefits:
- Auto-updates when you run `/ai-coding-config update`
- One source of truth across all projects
- No manual file copying or syncing needed

Read more: https://github.com/TechNickAI/ai-coding-config#plugin-marketplace

**Your situation:**

You have local files that duplicate marketplace content. Local files override marketplace versions, which means:
- Your local copies don't auto-update
- You might be using outdated versions
- It's confusing which version is actually running

**Found duplicates:**
[List specific duplicate files with their locations, e.g.:]
- `.claude/commands/autotask.md`
- `.claude/agents/code-reviewer.md`
- `.claude/skills/research.md`

**Custom files that will be preserved:**
[List files that exist locally but not in marketplace, e.g.:]
- `.claude/agents/logo-fetcher.md` (your custom agent)
- `.claude/commands/ai-coding-config.md` (required in project)

**Recommendation:** Remove the duplicate files and rely on the marketplace plugins. Your custom files will be preserved."

Use AskUserQuestion to present the choice:
- "Remove duplicates and use marketplace (Recommended)" - Explanation: "Delete duplicate files, keep custom files, rely on marketplace for updates"
- "Keep both" - Explanation: "Local files will continue to override marketplace versions"

If user chooses to remove duplicates:
- Use individual `rm` commands for each duplicate file
- Confirm what was removed
- Confirm what was preserved (ai-coding-config.md + any custom files)
- Remind: "You're now using marketplace plugins. Run `/ai-coding-config update` anytime to get the latest versions."

The goal is to eliminate confusion by removing duplicates while preserving custom work and educating the user about the marketplace approach.
</local-duplicate-cleanup>

<claude-code-update>
For Claude Code users with plugins installed:

1. Check which plugins are installed (list installed plugins)
2. Update all installed plugins:

```bash
# Update the core plugin
/plugin update ai-coding-config

# Update personality if installed
/plugin update personality-samantha  # or whichever is installed
```

3. Report what was updated with version changes.

</claude-code-update>

<cursor-update>
For Cursor users with copied files:

<deprecated-files-check>
Check for deprecated files in the user's PROJECT:

- `.cursor/rules/git-commit-message.mdc` → merged into `git-interaction.mdc`
- `.cursor/rules/marianne-williamson.mdc` → renamed to `luminous.mdc`

If found, offer removal/rename with explanation.
</deprecated-files-check>

<legacy-symlink-migration>
Check if the user has old symlinks from before the copy-based architecture:

- `.cursor/commands/` as symlink → should be a real directory with copied files
- `.claude/commands/` as symlink → remove if user is Cursor-only

If symlinks found, offer to migrate to copy-based architecture. Remove the symlink and
copy files from `~/.ai_coding_config/` instead.
</legacy-symlink-migration>

<file-updates>
All configuration files use `version: X.Y.Z` in YAML frontmatter. Files without version
metadata count as v0.0.0.

Compare versions for all copied files:

- Rules: `~/.ai_coding_config/.cursor/rules/` vs `.cursor/rules/`
- Commands: `~/.ai_coding_config/plugins/core/commands/` vs `.cursor/commands/`
- Personality: `~/.ai_coding_config/plugins/personalities/` vs `.cursor/rules/personalities/`

Use Grep tool to extract version metadata from source and installed files.

Identify files where source version is newer. Report updates with clear version
progression (e.g., "git-interaction.mdc: 1.0.0 → 1.1.0").

When updates available, use AskUserQuestion: Update all, Select individually, Show diffs
first, Skip updates.

When everything is current: "All files are up to date."

For personalities, preserve the user's `alwaysApply` setting when updating.
</file-updates>

</cursor-update>

<update-summary>
For Claude Code:
"Updated ai-coding-config plugin to version X.Y.Z"

For Cursor:
"Update complete:
- Rules: git-interaction.mdc 1.0.0 → 1.1.0, prompt-engineering.mdc 1.0.0 → 1.2.0
- Commands: autotask.md 1.0.0 → 1.1.0
- 15 files already current"
</update-summary>

</update-mode>

---

<execution-philosophy>
Work conversationally, not robotically. Focus on outcomes. Determine best approach for each situation. Show file paths when copying. Let users make all choices. Verify everything works before finishing.

Respect existing files - always check before overwriting. Use diff to understand
differences, then decide intelligently or ask. Better to be thoughtful than fast.

Explain choices helpfully. Don't just list files - explain what they do and why someone
might want them. </execution-philosophy>

---
description: Set up or update AI coding configurations
argument-hint: [update]
version: 2.1.0
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

- Claude Code (plugin marketplace)
- Cursor (rules + commands via symlinks)
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
   - **core** - Essential commands (autotask, troubleshoot, load-rules, etc.)
   - **agents** - Specialized AI agents (debugger, code-reviewer, autonomous-developer,
     etc.)
   - **skills** - Autonomous capabilities (research, brainstorming,
     systematic-debugging)
   - **personalities** - Pick one that matches your style

3. Provide the commands to add the marketplace and install plugins:

```bash
# Add the marketplace (one time)
/plugin marketplace add https://github.com/TechNickAI/ai-coding-config

# Install plugins
/plugin install ai-coding-config agents skills

# Optional: Install a personality
/plugin install personality-samantha
```

4. Use AskUserQuestion to present personality options with descriptions from the
   marketplace.json file.

</claude-code-setup>

<cursor-setup>
For Cursor users, set up symlinks to the plugin content.

<existing-config-detection>
Before installing, detect what already exists:

1. **Fresh project** (no existing configs)
   - Create `.cursor/rules/` directory
   - Create `AGENTS.md`, symlink `CLAUDE.md` → `AGENTS.md`

2. **Existing rules, no AI coding config yet**
   - Has `.cursor/rules/` or `rules/` as real directory
   - Offer choice: migrate to cross-tool structure OR merge alongside existing
   - ALWAYS preserve existing rules

3. **Already has AI coding config**
   - Check for symlinks pointing to `~/.ai_coding_config`
   - Proceed with update/refresh

Note: `.cursor/rules/` is the canonical location for Cursor rules. In user projects,
rules live directly in `.cursor/rules/` with no root-level symlink. In the
ai-coding-config repo itself, `rules/` exists as a symlink to `.cursor/rules/` for
visibility.

Detection:

```bash
test -d .cursor/rules && echo "has .cursor/rules"
test -L .cursor/rules && echo ".cursor/rules is symlink"
test -d rules && echo "has rules/"
test -f AGENTS.md && echo "has AGENTS.md"
```

</existing-config-detection>

<file-installation>
Copy from `~/.ai_coding_config/plugins/` to project:

Installation mapping:

- Rules → `.cursor/rules/` (copy from `~/.ai_coding_config/.cursor/rules/`)
- Commands → `.claude/commands/` symlink to `~/.ai_coding_config/plugins/core/commands/`
- Agents → `.claude/agents/` symlink to `~/.ai_coding_config/plugins/core/agents/`
- Skills → `.claude/skills/` symlink to `~/.ai_coding_config/plugins/core/skills/`
- Personalities → `.cursor/rules/personalities/` (copy selected personality, set
  `alwaysApply: true`)

For Cursor:

- `.cursor/commands/` → symlink to `.claude/commands/`

Handle conflicts with AskUserQuestion: overwrite, skip, show diff. </file-installation>

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

For Claude Code: Install the selected personality plugin. For Cursor: Copy personality
file to `.cursor/rules/personalities/` with `alwaysApply: true`.
</personality-selection>

<installation-verification>
Confirm files are in expected locations. For Claude Code, confirm plugins are installed.
For Cursor, confirm symlinks point correctly.
</installation-verification>

<recommendations>
Provide a warm summary of what was installed.

For Claude Code users: "You're set up with the ai-coding-config plugin marketplace.
Installed: [list plugins]"

For Cursor users: "Your project is configured with [X] rules, [Y] commands, and [Z]
agents."

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
# Update all plugins from the marketplace
/plugin update ai-coding-config
/plugin update agents
/plugin update skills
# Update personality if installed
/plugin update personality-samantha  # or whichever is installed
```

3. Report what was updated with version changes.

</claude-code-update>

<cursor-update>
For Cursor users with symlinks:

<architecture-check>
Check for legacy v2 architecture (rules/ at root):
- `rules/` is a real directory
- `.cursor/rules/` is a symlink to `../rules/`

If detected, offer migration back to standard architecture:

1. "Migrate to standard architecture (Recommended)" - Moves rules back to `.cursor/rules/`, removes root symlink
2. "Skip migration, just update configs" - Updates within current structure

Migration steps if accepted:
a. `rm .cursor/rules` (remove symlink)
b. `mv rules .cursor/rules` (move real directory back)
c. Update configs to point to `.cursor/rules/`

Current architecture (no migration needed):
- `.cursor/rules/` is a real directory
- No `rules/` directory at root in user projects
</architecture-check>

<deprecated-files-check>
Check for deprecated files in the user's PROJECT:

- `rules/git-commit-message.mdc` → merged into `git-interaction.mdc`
- `rules/marianne-williamson.mdc` → renamed to `luminous.mdc`

If found, offer removal/rename with explanation.

Note: Files in `~/.ai_coding_config` are updated via git pull automatically.
</deprecated-files-check>

<symlink-compatibility-check>
Existing symlinks should continue working after the 1.2.0 update because the source
repo's `.claude/` directories are now symlinks themselves (to `plugins/`).

Chain example: `project/.claude/commands/` → `~/.ai_coding_config/.claude/commands/` →
`../plugins/core/commands/`

This resolves correctly. Only check symlinks if they point directly to old paths like:

- `~/.ai_coding_config/plugins/code-review/` (deleted)
- `~/.ai_coding_config/plugins/dev-agents/` (deleted)
- `~/.ai_coding_config/plugins/skills/` (deleted)
- `~/.ai_coding_config/plugins/agents/` (deleted)

If direct symlinks to deleted paths found, offer to update:

- `.claude/commands/` → `~/.ai_coding_config/plugins/core/commands/`
- `.claude/agents/` → `~/.ai_coding_config/plugins/core/agents/`
- `.claude/skills/` → `~/.ai_coding_config/plugins/core/skills/`
  </symlink-compatibility-check>

<file-updates>
All configuration files (rules, agents, skills, commands, personalities) use `version: X.Y.Z` in YAML frontmatter. Files without version metadata count as v0.0.0.

**Version comparison strategy:** Use the Grep tool (not bash grep) to extract version
metadata. Run one Grep call for source files with an absolute path like
`~/.ai_coding_config/.cursor/rules/` and one for installed files. The Grep tool handles
file iteration internally and returns clean results without shell parsing issues.

For Cursor, compare COPIED files:
- Rules: `~/.ai_coding_config/.cursor/rules/` vs `.cursor/rules/`
- Personalities: `~/.ai_coding_config/plugins/personalities/` vs `.cursor/rules/personalities/`

Symlinked files (commands, agents, skills) are already current from repository git pull.

Identify files where source version is newer. Report updates with clear version progression (e.g., "git-interaction.mdc: 1.0.0 → 1.1.0").

When updates available, use AskUserQuestion with options: Update all, Select individually, Show diffs first, Skip updates.

When everything is current: "All files are up to date."

For personalities, preserve the user's `alwaysApply` setting. Never silently overwrite customizations.

**Copying files:** When copying updated files, use absolute paths for both source and
destination. A single `cp` command with full paths is safer than changing directories.
</file-updates>

</cursor-update>

<update-summary>
For Claude Code:
"Updated core, agents, skills plugins to version 1.2.0"

For Cursor:
"Update complete:
- git-interaction.mdc: 1.0.0 → 1.1.0
- prompt-engineering.mdc: 1.0.0 → 1.2.0
- Installed new-rule.mdc (v1.0.0)
- 12 files already current"
</update-summary>

</update-mode>

---

<execution-philosophy>
Work conversationally, not robotically. Focus on outcomes. Determine best approach for each situation. Show file paths when copying. Let users make all choices. Verify everything works before finishing.

Respect existing files - always check before overwriting. Use diff to understand
differences, then decide intelligently or ask. Better to be thoughtful than fast.

Explain choices helpfully. Don't just list files - explain what they do and why someone
might want them. </execution-philosophy>

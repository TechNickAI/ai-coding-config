---
description: Set up or update AI coding configurations
argument-hint: [update]
version: 4.1.0
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

**Important for hybrid users (Claude Code + Cursor):**
- `.cursor/commands/` must be a REAL directory, not a symlink to `.claude/commands/`
- Claude Code uses the plugin system; Cursor needs actual files
- Symlinking these directories together causes conflicts and prevents proper updates

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

For hybrid users (both Claude Code and Cursor): Do both. Install the plugin AND copy the
file. This ensures the personality works in both environments.

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

<objective>
Bring all AI coding configurations to a healthy, up-to-date state. The end result is a
working setup with the latest versions and auto-update enabled.
</objective>

<environment-detection>
Determine which AI coding tools are in use before proceeding.

Detection signals:
- Claude Code: `~/.claude/plugins/` directory exists
- Cursor: `.cursor/` directory exists in current project
- Both: proceed with both flows
- Neither: guide user to run setup mode instead

For Cursor-only users, skip all marketplace and plugin operations.
</environment-detection>

<repository-sync>
Pull latest source files regardless of environment:

```bash
git -C ~/.ai_coding_config pull
```

This updates the source repository that both Claude Code marketplace and Cursor file
copies draw from.
</repository-sync>

<self-update>
Immediately after pulling, check if this command file was updated.

Compare versions:
- Source: `~/.ai_coding_config/plugins/core/commands/ai-coding-config.md`
- Running: The version in YAML frontmatter of the file currently being executed

If the source version is newer:
1. Read the updated file from the source repository
2. If the project has a local copy at `.claude/commands/ai-coding-config.md`, update it
   with the new version (this keeps the local copy current for discoverability)
3. Continue execution using the updated instructions

This check happens before any other operations so that marketplace doctor, plugin
updates, and all subsequent steps use current instructions.
</self-update>

<marketplace-doctor>
For Claude Code users, ensure the ai-coding-config marketplace is healthy.

<health-checks>
A healthy marketplace has:
- Entry in `~/.claude/plugins/known_marketplaces.json` with source pointing to ai-coding-config
- Install location at `~/.claude/plugins/marketplaces/ai-coding-config/` with valid `.claude-plugin/marketplace.json`
- Plugins in `~/.claude/plugins/cache/ai-coding-config/` matching installed_plugins.json
- ai-coding-config plugin enabled in `~/.claude/settings.json`
- No deprecated plugins installed (see deprecated plugin check below)

Read these files to assess current state. Compare installed plugin versions against
marketplace.json versions.
</health-checks>

<deprecated-plugin-check>
Check `~/.claude/plugins/installed_plugins.json` for plugins from the ai-coding-config
marketplace that no longer exist in the current marketplace.json.

Previously, the marketplace had separate plugins that were later consolidated:
- `agents@ai-coding-config` → merged into ai-coding-config
- `skills@ai-coding-config` → merged into ai-coding-config
- `commands@ai-coding-config` → merged into ai-coding-config

If any deprecated plugins are found, the marketplace needs a reset. The reset will
remove these stale entries and install the current consolidated plugin.

This check is future-proof: compare installed plugin names against the current
marketplace.json rather than maintaining a hardcoded list.
</deprecated-plugin-check>

<major-version-check>
Compare the installed plugin version against the source marketplace.json version. If
the major version changed (e.g., 6.x.x → 7.x.x), trigger a full reset.

Major version changes often involve structural changes that `plugin update` may not
handle cleanly. A reset ensures a clean slate.

Before resetting for major version:
1. Note which plugins from this marketplace are currently installed (ai-coding-config,
   any personality plugins)
2. After reset, reinstall all of them

The reset is fast and prevents weird state from version mismatches.
</major-version-check>

<reset-to-healthy>
If any health check fails (deprecated plugins, major version change, corruption), reset
the marketplace. This is fast and reliable.

Before resetting, note which plugins from this marketplace are installed (check
installed_plugins.json for keys ending in `@ai-coding-config`). Common ones:
- ai-coding-config (core)
- personality-samantha, personality-sherlock, etc.

Execute plugin commands via subshell for reliability:

```bash
# Remove the marketplace
claude "/plugin marketplace remove ai-coding-config"

# Re-add it fresh
claude "/plugin marketplace add https://github.com/TechNickAI/ai-coding-config"

# Install the core plugin
claude "/plugin install ai-coding-config"

# Reinstall any personality plugins the user had
claude "/plugin install personality-samantha"  # if they had it before
```

Resetting takes seconds and eliminates debugging time. Use this approach when:
- Deprecated plugins detected
- Major version change (6.x → 7.x)
- Marketplace entry is missing or corrupted
- Plugin cache is incomplete or mismatched
- Version conflicts or install errors occur
- Any uncertainty about marketplace state

After reset, verify the plugin is working by checking that expected components exist in
the cache directory. Track that a restart will be needed. Then proceed to auto-update
check.
</reset-to-healthy>

<update-healthy-marketplace>
If the marketplace is healthy but potentially outdated, update it.

Execute plugin commands via subshell for reliability:

```bash
# Update marketplace catalog
claude "/plugin marketplace update ai-coding-config"

# Update installed plugins to latest versions
claude "/plugin update ai-coding-config"
```

Report version changes: "Updated ai-coding-config: 5.2.0 → 6.0.0"

If plugins were updated, track that a restart will be needed.
</update-healthy-marketplace>

<auto-update-check>
Third-party marketplaces have auto-update disabled by default. Check if the user wants
to enable it for convenience.

Auto-update means Claude Code refreshes the marketplace at startup and updates installed
plugins automatically. Users stay current without running manual updates.

Guide the user to enable auto-update through the plugin manager:
1. Run `/plugin` to open the plugin manager
2. Select the Marketplaces tab
3. Choose ai-coding-config
4. Select "Enable auto-update"

Use AskUserQuestion to offer this:
- "Enable auto-update (Recommended)" - Plugins stay current automatically
- "Keep manual updates" - Run `/ai-coding-config update` when you want updates
</auto-update-check>

<verification>
Confirm the marketplace is healthy by checking:
- ai-coding-config plugin is installed and enabled
- Expected agents are available (check for 10+ agents in cache)
- Expected commands are available (check for 10+ commands in cache)
- Expected skills are available (check for 5+ skills in cache)

Report the healthy state: "Marketplace healthy: 14 agents, 15 commands, 6 skills"
</verification>

</marketplace-doctor>

<local-duplicate-cleanup>
After marketplace is healthy, check for outdated local files that duplicate marketplace
content. Local files override marketplace versions, causing confusion and preventing
auto-updates.

**What to look for in `.claude/commands/`, `.claude/agents/`, `.claude/skills/`:**

1. Symlinks pointing to ai-coding-config plugin cache - these are duplicates
2. Copied files with same names as marketplace content - these override plugin versions

Detection:

```bash
# Find symlinks pointing to ai-coding-config cache
find .claude/commands -type l 2>/dev/null | while read f; do
  readlink "$f" | grep -q 'ai-coding-config' && echo "duplicate: $f"
done
```

**What to preserve:**
- Project-specific commands (not in marketplace)
- The ai-coding-config.md command file (stays for discoverability)
- Custom agents and skills unique to this project

**What to remove:**
- Symlinks to `~/.claude/plugins/cache/ai-coding-config/` (plugin provides these)
- Copied files that match marketplace filenames (unless intentionally customized)

Explain the situation: "Found X duplicate commands that the plugin already provides.
Removing these lets you get auto-updates from the marketplace."

Offer to remove duplicates. If user declines, warn that local files override plugin
versions and won't auto-update.
</local-duplicate-cleanup>

<cursor-update>
For Cursor users, update copied configuration files.

Pull latest from source repository, then compare versions using YAML frontmatter. Update
files where the source version is newer than the installed version.

Files to compare:
- Rules: `~/.ai_coding_config/.cursor/rules/` vs `.cursor/rules/`
- Commands: `~/.ai_coding_config/plugins/core/commands/` vs `.cursor/commands/`
- Personality: `~/.ai_coding_config/plugins/personalities/` vs `.cursor/rules/personalities/`

Report updates with version progression: "git-interaction.mdc: 1.0.0 → 1.1.0"

For personalities, preserve the user's `alwaysApply` setting when updating content.

Check for deprecated files and offer removal:
- `.cursor/rules/git-commit-message.mdc` merged into git-interaction.mdc
- `.cursor/rules/marianne-williamson.mdc` renamed to luminous.mdc

<legacy-symlink-migration>
Check if the project has old symlinks from before the copy-based architecture:

- `.cursor/commands/` as symlink → should be a real directory with copied files
- `.cursor/rules/` as symlink → should be a real directory with copied files

**Critical pattern to detect**: `.cursor/commands/` symlinked to `.claude/commands/`

This creates a mess because Claude Code and Cursor need different things:
- Claude Code: Uses plugin system, doesn't need ai-coding-config commands locally
- Cursor: Needs all commands as files (can't use plugin system)

When this pattern is found:
1. Note which files are project-specific (not symlinks to ai-coding-config cache)
2. Remove the `.cursor/commands/` symlink
3. Create `.cursor/commands/` as a real directory
4. Copy project-specific commands from `.claude/commands/`
5. Copy ai-coding-config commands from `~/.ai_coding_config/plugins/core/commands/`
6. Remove ai-coding-config symlinks from `.claude/commands/` (duplicates of plugin)

Detection:

```bash
# Check if .cursor/commands is a symlink to .claude/commands
readlink .cursor/commands | grep -q '.claude/commands' && echo "cursor-symlinked-to-claude"

# List ai-coding-config symlinks in .claude/commands
find .claude/commands -type l -exec readlink {} \; | grep -q 'ai-coding-config' && echo "has-plugin-symlinks"
```

For Claude Code users who are Cursor-only (no marketplace):
- `.claude/commands/` as symlink → remove and skip (not needed for Cursor)
- `.claude/agents/` as symlink → remove and skip
- `.claude/skills/` as symlink → remove and skip
</legacy-symlink-migration>

</cursor-update>

<update-summary>
Report what was accomplished:

For Claude Code: "Marketplace healthy. ai-coding-config v6.0.0 installed. Auto-update
enabled."

For Cursor: "Updated 3 rules, 2 commands. 12 files already current."

For both: Combine the summaries.
</update-summary>

<restart-guidance>
Tell the user to restart Claude Code when any of these occurred:
- Marketplace was reset or reinstalled
- Plugins were updated to new versions
- Auto-update setting was changed

Plugins are loaded at startup, so changes take effect after restart.

Message: "Restart Claude Code to load the updated plugins. Run `claude` in a new
terminal, or use Cmd+Shift+P → 'Claude Code: Restart' in your IDE."

If nothing changed (already up to date, no reset needed), skip the restart message.
</restart-guidance>

</update-mode>

---

<execution-philosophy>
Work conversationally, not robotically. Focus on outcomes. Determine best approach for each situation. Show file paths when copying. Let users make all choices. Verify everything works before finishing.

Respect existing files - always check before overwriting. Use diff to understand
differences, then decide intelligently or ask. Better to be thoughtful than fast.

Explain choices helpfully. Don't just list files - explain what they do and why someone
might want them. </execution-philosophy>

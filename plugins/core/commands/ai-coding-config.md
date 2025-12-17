---
description: Set up, update, or add AI coding configurations
argument-hint: [update | add]
---

# AI Coding Configuration

Plugin-first AI coding configurations for Claude Code, Cursor, Windsurf, and other AI
coding tools. The marketplace lives at
`https://github.com/TechNickAI/ai-coding-config`.

## Usage

- `/ai-coding-config` - Interactive setup for current project
- `/ai-coding-config update` - Update plugins and configs to latest versions
- `/ai-coding-config add` - Add new command/skill/agent/plugin to the repo

## Interaction Guidelines

Use AskUserQuestion when presenting discrete choices that save the user time (selecting
tools, personalities, handling conflicts). This lets users quickly click options while
still allowing free-form text via "Other".

---

<setup-mode>

<tool-detection>
Detect which AI coding tools the user has. Check for:

```bash
# Detection commands
test -d .cursor && echo "cursor"
test -d .windsurf && echo "windsurf"
test -d .claude && echo "claude-code"
test -f .aider.conf.yml && echo "aider"
test -d .continue && echo "continue"
```

Based on detection, use AskUserQuestion to confirm which tools to set up. Pre-select
detected tools. Options:

- Claude Code (plugin marketplace)
- Cursor (rules + commands via symlinks)
- Windsurf (rules via symlinks)
- Aider (AGENTS.md context)
- Other (explain what you're using)

If ONLY Claude Code detected (no Cursor/Windsurf), offer a pure plugin installation
that skips rule files entirely.

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

1. Explain the plugin system:
   "Claude Code uses a plugin marketplace. You can install the plugins you want, and
   they'll stay updated automatically."

2. Show available plugins from `~/.ai_coding_config/.claude-plugin/marketplace.json`:
   - **core** - Essential commands (autotask, troubleshoot, load-rules, etc.)
   - **agents** - Specialized AI agents (debugger, code-reviewer, autonomous-developer, etc.)
   - **skills** - Autonomous capabilities (research, brainstorming, systematic-debugging)
   - **personalities** - Pick one that matches your style

3. Provide the commands to add the marketplace and install plugins:

```bash
# Add the marketplace (one time)
/plugin marketplace add https://github.com/TechNickAI/ai-coding-config

# Install plugins
/plugin install core agents skills

# Optional: Install a personality
/plugin install personality-samantha
```

4. Use AskUserQuestion to present personality options with descriptions from the
   marketplace.json file.

</claude-code-setup>

<cursor-windsurf-setup>
For Cursor and Windsurf users, set up symlinks to the plugin content.

<existing-config-detection>
Before installing, detect what already exists:

1. **Fresh project** (no existing configs)
   - Create `rules/` as canonical, symlink `.cursor/rules/` → `../rules/`
   - Create `AGENTS.md`, symlink `CLAUDE.md` → `AGENTS.md`

2. **Existing rules, no AI coding config yet**
   - Has `.cursor/rules/` or `rules/` as real directory
   - Offer choice: migrate to cross-tool structure OR merge alongside existing
   - ALWAYS preserve existing rules

3. **Already has AI coding config**
   - Check for symlinks pointing to `~/.ai_coding_config`
   - Proceed with update/refresh

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
- Rules → `rules/` (copy from `~/.ai_coding_config/rules/`)
- Commands → `.claude/commands/` symlink to `~/.ai_coding_config/plugins/core/commands/`
- Agents → `.claude/agents/` symlink to `~/.ai_coding_config/plugins/agents/agents/`
- Skills → `.claude/skills/` symlink to `~/.ai_coding_config/plugins/skills/skills/`
- Personalities → `rules/personalities/` (copy selected personality, set `alwaysApply: true`)

For Cursor/Windsurf:
- `.cursor/rules/` → symlink to `../rules/`
- `.cursor/commands/` → symlink to `.claude/commands/`
- `.windsurf/rules/` → symlink to `../rules/` (if Windsurf)

Handle conflicts with AskUserQuestion: overwrite, skip, show diff.
</file-installation>

</cursor-windsurf-setup>

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

For Claude Code: Install the selected personality plugin.
For Cursor/Windsurf: Copy personality file to `rules/personalities/` with `alwaysApply: true`.
</personality-selection>

<installation-verification>
Confirm files are in expected locations. For Claude Code, confirm plugins are installed.
For Cursor/Windsurf, confirm symlinks point correctly.
</installation-verification>

<recommendations>
Provide a warm summary of what was installed.

For Claude Code users:
"You're set up with the ai-coding-config plugin marketplace. Installed: [list plugins]"

For Cursor/Windsurf users:
"Your project is configured with [X] rules, [Y] commands, and [Z] agents."

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

<repository-update>
First, pull latest from `~/.ai_coding_config`:

```bash
cd ~/.ai_coding_config && git pull
```
</repository-update>

<plugin-migration-check>
Check for deprecated plugins from pre-1.2.0 architecture.

Detection - check if any of these plugins are installed:
- `code-review` (consolidated into `agents`)
- `dev-agents` (consolidated into `agents`)
- `git-commits` (agent moved to `agents`)
- `python`, `react`, `django`, `code-standards` (removed - were empty placeholders)

If deprecated plugins found, explain the migration:

"The plugin architecture has been reorganized in version 1.2.0:
- **code-review**, **dev-agents**, and **git-commits** agents are now consolidated into a single `agents` plugin
- Tech-specific plugins (python, react, django) were placeholders and have been removed
- New structure: `core` (commands), `agents` (all agents), `skills` (autonomous capabilities)

You'll get MORE agents with the new structure, not fewer."

Migration commands:
```bash
# Uninstall deprecated plugins (run for each that's installed)
/plugin uninstall code-review
/plugin uninstall dev-agents
/plugin uninstall git-commits
/plugin uninstall python
/plugin uninstall react
/plugin uninstall django
/plugin uninstall code-standards

# Install new consolidated plugins
/plugin install core agents skills
```

Offer: "Migrate to new plugin structure (Recommended)" or "Skip migration"
</plugin-migration-check>

<claude-code-update>
For Claude Code users with plugins installed:

1. Check which plugins are installed (list installed plugins)
2. Update all installed plugins:

```bash
# Update all plugins from the marketplace
/plugin update core
/plugin update agents
/plugin update skills
# Update personality if installed
/plugin update personality-samantha  # or whichever is installed
```

3. Report what was updated with version changes.

</claude-code-update>

<cursor-windsurf-update>
For Cursor/Windsurf users with symlinks:

<architecture-check>
Check for legacy architecture (v1 - Cursor-first):
- `.cursor/rules/` is a real directory (not symlink)
- `CLAUDE.md` is a real file (not symlink)

If detected, offer migration:
1. "Migrate to cross-tool architecture (Recommended)" - Moves rules to `rules/`, creates symlinks
2. "Skip migration, just update configs" - Updates within current structure

Migration steps if accepted:
a. `cp -r .cursor/rules rules-backup`
b. `mv .cursor/rules rules`
c. `ln -s ../rules .cursor/rules`
d. Create AGENTS.md, symlink CLAUDE.md → AGENTS.md
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

Chain example:
`project/.claude/commands/` → `~/.ai_coding_config/.claude/commands/` → `../plugins/core/commands/`

This resolves correctly. Only check symlinks if they point directly to old paths like:
- `~/.ai_coding_config/plugins/code-review/` (deleted)
- `~/.ai_coding_config/plugins/dev-agents/` (deleted)

If direct symlinks to deleted paths found, offer to update:
- `.claude/commands/` → `~/.ai_coding_config/plugins/core/commands/`
- `.claude/agents/` → `~/.ai_coding_config/plugins/agents/agents/`
- `.claude/skills/` → `~/.ai_coding_config/plugins/skills/skills/`
</symlink-compatibility-check>

<file-updates>
For Cursor/Windsurf, update by category:

1. **Rules** (`rules/`)
   - Compare each rule file in `~/.ai_coding_config/rules/` vs project
   - Show diffs for significant changes
   - Preserve project-specific rules

2. **Commands/Agents/Skills**
   - If symlinked to `~/.ai_coding_config/plugins/`, already updated via git pull
   - If copied, compare and offer updates

3. **Personalities** (`rules/personalities/`)
   - Check if personality has updates
   - Preserve `alwaysApply` setting

Present update strategy: "Update all", "Update selectively", or custom.
Never silently overwrite project customizations.
</file-updates>

</cursor-windsurf-update>

<update-summary>
Report what was updated:
- "Updated X plugins to version Y"
- "Updated Z rule files"
- "No updates available" (if already current)
</update-summary>

</update-mode>

---

<add-mode>
Help contributors add new functionality to the ai-coding-config repo itself.

<understanding-need>
Ask for functionality description. Work through clarifying questions to determine the
right mechanism.
</understanding-need>

<mechanism-selection>
Decision framework:

- **Command**: User manually triggers, works in both Claude Code and Cursor
- **Skill**: Claude autonomously activates, Claude Code only
- **Agent**: Claude delegates focused work with isolated context
- **Personality**: Alternative interaction style

Clarifying questions:
1. Who triggers this - user manually or Claude autonomously?
2. Needs isolated context window or uses main conversation?
3. Must work in Cursor or Claude Code only acceptable?
</mechanism-selection>

<artifact-creation>
All new artifacts go in the appropriate plugin directory:

**Commands**: Create in `plugins/core/commands/command-name.md`
```yaml
---
description: Brief explanation
argument-hint: [optional args]
---
```

**Skills**: Create `plugins/skills/skills/skill-name/SKILL.md`
```yaml
---
name: skill-name
description: "Use when [trigger]. Does [what] to achieve [outcome]."
---
```

**Agents**: Create in `plugins/agents/agents/agent-name.md`
```yaml
---
name: agent-name
description: "Invoke when [trigger]"
tools: Read, Write, Edit, Grep, Glob, Bash
model: sonnet
---
```

**Personalities**: Create `plugins/personalities/personality-name/`
- `personality.mdc` - The personality definition
- `.claude-plugin/plugin.json` - Plugin manifest
- Update marketplace.json to include new personality
</artifact-creation>

<creation-verification>
Verify files are in correct locations and symlinks work. Test the new functionality.
Update marketplace.json if needed.
</creation-verification>

</add-mode>

---

<execution-philosophy>
Work conversationally, not robotically. Focus on outcomes. Determine best approach for each situation. Show file paths when copying. Let users make all choices. Verify everything works before finishing.

Respect existing files - always check before overwriting. Use diff to understand
differences, then decide intelligently or ask. Better to be thoughtful than fast.

Explain choices helpfully. Don't just list files - explain what they do and why someone
might want them. </execution-philosophy>

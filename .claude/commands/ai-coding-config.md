---
description: Set up, update, or add AI coding configurations
argument-hint: [update | add]
---

# AI Coding Configuration

Manages reusable AI configurations across machines and projects. The system lives in `~/.ai_coding_config` and contains Cursor rules, Claude commands, agents, skills, personalities, and GitHub workflows.

## Usage

- `/ai-coding-config` - Interactive setup for current project
- `/ai-coding-config update` - Update existing configs to latest versions
- `/ai-coding-config add` - Add new command/skill/agent/plugin to the repo

## Interaction Guidelines

Use AskUserQuestion when presenting discrete choices that save the user time (selecting a personality, choosing update strategy, handling file conflicts). This lets users quickly click options while still allowing free-form text via "Other". Only use when it genuinely speeds up the interaction.

---

<setup-mode>
Walk through setting up AI coding configs for the current project.

<repository-management>
Ensure `~/.ai_coding_config` exists and is up to date. Clone if missing, pull latest if exists.
</repository-management>

<project-understanding>
Detect project type and framework specifics. Django differs from FastAPI. React differs from Next.js. Look for existing configurations to avoid duplicates. Understand the project's purpose - API server, web app, CLI tool.
</project-understanding>

<configuration-presentation>
Show available configurations that match this project. Group by relevance - framework-specific first, then universal. For each option, read description from frontmatter to explain what it does.

Available configurations:
- Rules (`.cursor/rules/` subdirectories and files)
- Personalities (one or none)
- Agents (specialized AI assistants, default to all)
- Skills (intelligent selection based on project type - see skills-selection section)
- Commands (always copy all, create in `.claude/commands/` with symlinks in `.cursor/commands/`)
- Standard configs (VSCode settings, Prettier, GitHub workflows)

Use AskUserQuestion to present personality options as quick-select.
</configuration-presentation>

<skills-selection>
Walk through `~/.ai_coding_config/.claude/skills/` and evaluate each skill for relevance to the current project.

For each skill directory:
1. Read the SKILL.md frontmatter to get the description
2. Evaluate whether the skill matches this project's context
3. Categorize as: recommended (strong match), optional (might be useful), or skip (not relevant)

Skill evaluation criteria:

Universal skills (always recommend):
- brainstorming: Useful for any project - refining ideas into designs
- research: Useful for any project - web research for current information
- systematic-debugging: Useful for any project with code - root cause analysis

Project-specific skills (match against signals):
- skill-creator: Only for ai-coding-config repo itself (check if current project IS the config repo)
- youtube-transcript-analyzer: Projects with docs/, research/, or learning-focused goals

When evaluating a skill you haven't seen before:
1. Read its SKILL.md description carefully
2. Look for "Use when..." triggers in the description
3. Match triggers against project signals (package.json, file structure, existing configs)
4. When uncertain, categorize as optional and let user decide

Present skills grouped by category:
- Recommended: Strong match for this project type
- Optional: Might be useful depending on workflow
- Skipping: Not relevant (explain briefly why)

Use AskUserQuestion to confirm skill selection, showing recommended pre-selected.
</skills-selection>

<file-installation>
Copy selected configurations intelligently, respecting existing customizations. Compare files with diff when they exist. For conflicts, use AskUserQuestion to offer choices (overwrite, skip, show diff, or custom action). Never silently overwrite.

Installation mapping: Rules → `.cursor/rules/` (preserve subdirectory structure), Commands → `.claude/commands/` with symlinks in `.cursor/commands/`, Context → `.claude/context.md`, Agents → `.claude/agents/`, Skills → `.claude/skills/` (copy entire skill directories for selected skills only), Personalities → `.cursor/rules/personalities/` (common always, additional with `alwaysApply: true`), VSCode → `.vscode/`, Prettier → `.prettierrc`, GitHub workflows → `.github/workflows/`, Gitignore → `.cursor/.gitignore` and `.claude/.gitignore`, Directory context → `.cursor/AGENTS.md` and `.claude/AGENTS.md` (explains directory purpose and references prompt-engineering rules).

Report what was copied, skipped, and how conflicts were handled.
</file-installation>

<installation-verification>
Confirm files are in expected locations. List installed rules (framework-specific, then universal), commands, agents, skills. Confirm symlinks point correctly. Verify personality selection and `alwaysApply` setting. Confirm VSCode settings, Prettier config, GitHub workflows, gitignore files, and directory AGENTS.md files.

Provide clear summary without deep validation.
</installation-verification>

<recommendations>
After successful installation, provide actionable next steps.

Always recommend:
1. Generate AGENTS.md if missing at project root (run /generate-AGENTS-file)
2. List available commands (/load-cursor-rules, /personality-change, /create-prompt, /troubleshoot, /setup-environment, /handoff-context, /product-intel)

Conditional recommendations:
- Git worktrees → suggest /setup-environment
- Error monitoring detected → mention /troubleshoot
- Competitive product → suggest /product-intel

Show only genuinely useful recommendations.
</recommendations>
</setup-mode>

---

<update-mode>
Systematically update all configuration types from the repo to latest versions.

Start by pulling latest from `~/.ai_coding_config` and comparing against the current project.

Configuration categories that must be checked (in this order):

1. Personalities (`.cursor/rules/personalities/`)
   - Compare each personality file in repo vs project
   - Note: common-personality.mdc may have been deprecated or renamed in newer versions
   - Show diffs for changes to frontmatter (description, alwaysApply)

2. Top-level Rules (`.cursor/rules/`)
   - Universal rules apply to all projects regardless of framework
   - Compare: autonomous-development-workflow, code-review-standards, external-apis,
     fixing-github-actions-builds, git-commit-message, git-interaction, git-worktree-task,
     naming-stuff, prompt-engineering, user-facing-language, heart-centered-ai-philosophy,
     trust-and-decision-making
   - Preserve project-specific rules (sentry, typescript-coding-standards, testing-standards-typescript, code-comments, etc.)

3. Rule Subdirectories (`.cursor/rules/`)
   - Check each subdirectory: ai/, frontend/, observability/, django/, python/
   - For MCP/Next.js projects: prioritize ai/ and frontend/
   - For each subdirectory, compare all .mdc files in repo vs project
   - Example: ai/agent-file-format.mdc, frontend/react-components.mdc

4. Agents (`.claude/agents/`)
   - Compare all agent files: design-reviewer.md, seo-specialist.md, site-keeper.md, plus project-custom agents
   - Update repo agents (description and formatting improvements common)
   - Preserve project-specific agents

5. Commands (`.claude/commands/`)
   - Update all commands that exist in both repo and project
   - Add new commands from repo that don't exist in project
   - Preserve project-specific commands
   - Create symlinks in .cursor/commands/ for new commands

6. Other Configs
   - VSCode settings (.vscode/)
   - Prettier config (.prettierrc)
   - GitHub workflows (.github/workflows/)

For each category: use diff to identify changes. Categorize as trivial (typos, formatting)
or significant (logic, descriptions, instructions). List files new to repo or unique to project.

Present update strategy to user: "Update all", "Update selectively", or custom approach.
Show diffs for significant changes before applying. Never silently overwrite project customizations.

After copying: verify files are in correct locations, symlinks point correctly, and
descriptions in frontmatter were updated.
</update-mode>

---

<add-mode>
Help contributors add new functionality to the ai-coding-config repo itself.

<understanding-need>
Ask for functionality description. Work through clarifying questions to determine the right mechanism.
</understanding-need>

<documentation-research>
Fetch latest Claude Code documentation for the mechanism you're implementing (commands, skills, agents, or plugins). Get current implementation details including frontmatter requirements, file structure, and best practices.
</documentation-research>

<mechanism-selection>
Decision framework:

Trigger: User manually → Command, Claude autonomously → Skill, Claude delegates focused work → Agent, Bundling multiple mechanisms → Plugin

Context: Needs isolation → Agent, Uses main conversation → Command or Skill

Compatibility: Commands work in both Claude Code and Cursor, Skills are Claude Code only (create companion Command for Cursor if needed), Agents work in Claude Code (Cursor can @ mention paths), Plugins are Claude Code only

Clarifying questions:
1. Who triggers this - user manually or Claude autonomously?
2. Needs isolated context window or uses main conversation?
3. Must work in Cursor or Claude Code only acceptable?
4. Single capability or bundling multiple features?
</mechanism-selection>

<artifact-creation>
Commands: Create `.claude/commands/command-name.md` with frontmatter including description.

Skills: Create `.claude/skills/skill-name/SKILL.md` with frontmatter (name, description). Description is critical - Claude uses it to decide when to activate. Add supporting files as needed. Create companion Command for Cursor if needed.

Agents: Determine plugin location (or create new plugin). Create `plugins/plugin-name/agents/agent-name.md` with frontmatter (name, description, tools, model). Agents live in plugins.

Plugins: Create `plugins/plugin-name/` directory structure with `.claude-plugin/plugin.json` manifest. Bundle commands (via symlinks), skills, agents, hooks, MCP servers. Add README.md. Update `.claude-plugin/marketplace.json`.
</artifact-creation>

<creation-verification>
Verify files are in correct locations, frontmatter includes required fields, skill descriptions clearly define activation criteria, commands work when invoked, plugins are properly structured.

Explain what was created and how to test it.
</creation-verification>
</add-mode>

---

<execution-philosophy>
Work conversationally, not robotically. Focus on outcomes. Determine best approach for each situation. Show file paths when copying. Let users make all choices. Verify everything works before finishing.

Respect existing files - always check before overwriting. Use diff to understand differences, then decide intelligently or ask. Better to be thoughtful than fast.

Explain choices helpfully. Don't just list files - explain what they do and why someone might want them.
</execution-philosophy>

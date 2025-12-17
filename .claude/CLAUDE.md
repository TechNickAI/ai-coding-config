# AI Coding Configuration - Command Update Protocol

When a user runs /ai-coding-config update, after pulling the latest changes from this repository, check if their local command file is outdated and offer to update it.

## Self-Update Check

The ai-coding-config.md command file in the user's project may be stale. Users who ran bootstrap.sh have a copied file that doesn't automatically update when the repo is pulled.

Compare versions using the version field in YAML frontmatter. Check the user's .claude/commands/ai-coding-config.md against the repo version at ~/.ai_coding_config/.claude/commands/ai-coding-config.md. If the repo version is newer than the user's local copy, offer to update it.

Present two options: replace with the latest copy from the repo, or skip the update and keep their current version.

The goal is ensuring users can keep their command file current even when it was initially copied rather than symlinked.

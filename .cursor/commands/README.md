# Cursor Commands

This directory contains symlinks to `.claude/commands/*.md` files.

## Why Symlinks?

Cursor and Claude Code both support slash commands with the same format:

- Cursor reads from `.cursor/commands/`
- Claude Code reads from `.claude/commands/`

Both support:

- Markdown files with optional YAML frontmatter
- `description` field in frontmatter
- Standard Markdown content for the command instructions

By using symlinks, we maintain a single source of truth in `.claude/commands/` while
making the commands available to both IDEs.

## Command Format

```markdown
---
description: Brief description of what this command does
---

# Command Title

Detailed instructions for the AI to follow...
```

The YAML frontmatter is optional but recommended. Cursor will display the command in its
slash command menu, with or without frontmatter.

# Cursor Configuration

This directory contains AI coding rules and commands for Cursor IDE.

@rules/prompt-engineering.mdc

## Structure

- `rules/` - Coding standards and conventions (`.mdc` files with YAML frontmatter)
- `commands/` - Symlinks to `.claude/commands/` for shared workflows

## Rules

Rules are markdown files with `.mdc` extension containing YAML frontmatter:

```yaml
---
description: Brief explanation of when this rule applies
alwaysApply: false # true = applies to every task, false = loaded on demand
globs: ["pattern/**"] # Optional: file patterns that trigger this rule
---
```

When creating or editing rules:

- Follow prompt-engineering.mdc principles for LLM-readable content
- Use goal-focused instructions, not step-by-step prescriptions
- Show correct patterns only - never include anti-patterns
- Use XML tags for complex multi-section rules
- Keep frontmatter description concise but specific

## Commands

Commands in `.cursor/commands/` are symlinks pointing to canonical files in
`.claude/commands/`. This ensures a single source of truth while enabling both Cursor
and Claude Code to use the same workflows.

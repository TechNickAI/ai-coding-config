---
description: Set up or update AI coding configurations from ai-coding-config repo
---

# AI Coding Configuration

Manages reusable AI configurations across machines and projects.

## Understanding the System

First, get context about what ai-coding-config does:

- If ~/.ai_coding_config exists: Read ~/.ai_coding_config/README.md
- If not: Fetch and read
  https://raw.githubusercontent.com/TechNickAI/ai-coding-config/main/README.md

The system contains Cursor rules, Claude commands, personalities, and GitHub workflows
in ~/.ai_coding_config. This command helps copy relevant configurations into projects
and keeps them synced.

## Your Goals

**First time (no ~/.ai_coding_config)**: Clone the repo to ~/.ai_coding_config, then
offer to set up the current project.

**New project setup**: Detect project type (Python/TypeScript). Show available rules and
personalities. Let user choose what to copy. Copy selected files into project structure.
Update .gitignore to exclude .local.json files.

**Update existing project**: Pull latest from ~/.ai_coding_config. Compare with project
files. Show what changed. Let user choose what to update.

## Key Principles

Work conversationally, not robotically. Don't show every bash command - just say what
you're doing and report results.

Personality selection is important: users pick ONE personality (or none). Don't offer to
copy all personalities. The common-personality is always included as the baseline.

When showing available rules, group by category (Python vs TypeScript vs Universal).
Explain what each file does so users can make informed choices.

For updates, show what actually changed by comparing files, not placeholder examples.
Separate personalities from rules in your presentation.

Always add .local.json exclusions to .gitignore if not present.

## Finding Configurations

Don't use hardcoded lists. Discover what's available by reading directories:

- Explore ~/.ai_coding_config/.cursor/rules/ to find subdirectories and files
- Read ~/.ai_coding_config/.cursor/rules/personalities/ to find personality options
- Check ~/.ai_coding_config/.vscode/ for editor settings
- Match discoveries to detected project type

Files in .cursor/rules/ root (not in subdirectories) generally apply to all projects.
Let the AI decide what's relevant based on filenames and project context.

## Execution Notes

Be helpful and conversational. Show file paths when copying so users understand the
structure. Let users make all choices. Confirm what was set up at the end.

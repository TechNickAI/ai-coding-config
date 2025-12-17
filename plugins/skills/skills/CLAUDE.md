# Creating Claude Code Skills

When creating custom skill files in `.claude/skills/`, the YAML frontmatter format
matters.

## Valid Frontmatter Format

```yaml
---
name: skill-name
description: "Keep under 75 characters"
---
```

**Critical constraints:**

- **Single line only** - Claude Code doesn't parse block scalars (`>` or `|`) correctly
- **Under 75 characters** - With `description: ` prefix (13 chars), total line must be
  under 88 to prevent prettier wrapping
- **Use quotes** - Always quote descriptions to handle special characters like colons

**Valid formats:**

- `description: "Double quoted under 75 chars"` (recommended)
- `description: 'Single quoted under 75 chars'`
- `description: Plain text under 75 chars` (only if no special characters)

## Writing Concise Descriptions

Keep descriptions focused on WHEN to use the skill:

- Good: "Use when rough ideas need design before code"
- Too long: "Use when developing rough ideas into designs before writing code. Refines
  concepts through collaborative questioning..."

If you need to cut content to stay under 75 chars, move that detail into the skill body
instead.

## Example Skill

```yaml
---
name: systematic-debugging
description: "Use for bugs, test failures, or unexpected behavior needing root cause"
---

<objective>
Find the root cause before writing fixes. Understanding why something breaks leads to
correct fixes. Guessing wastes time and creates new problems.

Core principle: If you can't explain WHY it's broken, you're not ready to fix it.
</objective>

[Rest of skill content...]
```

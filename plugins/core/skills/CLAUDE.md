# Creating Claude Code Skills

When creating custom skill files in `.claude/skills/`, the YAML frontmatter format
matters.

## Valid Frontmatter Format

```yaml
---
name: skill-name
description: "Keep under 75 characters - trigger-only!"
version: 1.0.0
category: debugging
triggers:
  - "natural language phrase"
  - "another trigger"
---
```

## Field Requirements

**name**: Letters, numbers, hyphens only. Use kebab-case (e.g., `systematic-debugging`).

**description**: Trigger-only! Start with "Use when..." and describe ONLY triggering
conditions. No process details. Under 75 characters.

- Good: `"Use when rough ideas need design before code"`
- Bad: `"Use when ideas need design - explores options and validates incrementally"`

The "Description Trap": If your description contains process details, Claude follows the
short description instead of reading the full skill content.

**version**: Semantic versioning. Bump when updating the skill.

**category**: Grouping for discovery. Common categories:
- `planning` - Design, architecture, brainstorming
- `debugging` - Error investigation, root cause analysis
- `research` - Web lookups, documentation review
- `testing` - Test writing, coverage analysis
- `meta` - Skills about skills, configuration

**triggers**: Natural language phrases that activate this skill. Include:
- Keywords users naturally say ("debug", "brainstorm", "research")
- Questions ("why is this", "is this still")
- Symptoms ("not working", "test failing")
- Tool names ("youtube", "SKILL.md")

## Example Skill

```yaml
---
name: systematic-debugging
description: "Use for bugs, test failures, or unexpected behavior needing root cause"
version: 1.1.0
category: debugging
triggers:
  - "debug"
  - "investigate"
  - "root cause"
  - "why is this"
  - "not working"
  - "test failing"
---

<objective>
Find the root cause before writing fixes. Understanding why something breaks leads to
correct fixes.

Core principle: If you can't explain WHY it's broken, you're not ready to fix it.
</objective>

[Rest of skill content...]
```

## Critical Constraints

- **Single line descriptions** - Claude Code doesn't parse block scalars (`>` or `|`)
- **Under 75 characters** - With `description: ` prefix, total line must be under 88
- **Use quotes** - Always quote descriptions to handle special characters
- **Trigger-only descriptions** - No process details in the description field

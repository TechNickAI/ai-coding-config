# Creating Claude Code Skills

When creating custom skill files in `.claude/skills/`, the YAML frontmatter format
matters.

## Valid Frontmatter Format

```yaml
---
name: skill-name
# prettier-ignore
description: "Use when X, Y, or Z - include all semantic triggers that should activate this skill"
version: 1.0.0
category: debugging
triggers:
  - "natural language phrase"
  - "another trigger"
---
```

## Field Requirements

**name**: Letters, numbers, hyphens only. Use kebab-case (e.g., `systematic-debugging`).

**description**: Start with "Use when..." and include rich semantic triggers. Use
`# prettier-ignore` to allow longer descriptions. Focus on triggering conditions, not
process details.

- Good:
  `"Use when debugging test failures, unexpected behavior, or needing root cause analysis"`
- Bad: `"Finds root causes by tracing data flow and testing hypotheses"`

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
# prettier-ignore
description: "Use when debugging bugs, test failures, unexpected behavior, or needing root cause analysis before fixing"
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
- **Use `# prettier-ignore`** - Add before description to allow longer, richer triggers
- **Use quotes** - Always quote descriptions to handle special characters
- **Trigger-focused descriptions** - Focus on when to activate, not what it does

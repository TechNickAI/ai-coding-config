# Creating Claude Code Agents

When creating custom agent files in `.claude/agents/`, the YAML frontmatter format matters.

## Valid Frontmatter Format

```yaml
---
name: agent-name
description: "Keep under 75 characters"
---
```

**Critical constraints:**

- **Single line only** - Claude Code doesn't parse block scalars (`>` or `|`) correctly
- **Under 75 characters** - With `description: ` prefix (13 chars), total line must be under 88 to prevent prettier wrapping
- **Use quotes** - Always quote descriptions to handle special characters like colons

**What works:**

- `description: Plain text under 75 chars`
- `description: "Double quoted under 75 chars"`
- `description: 'Single quoted under 75 chars'`

**What does NOT work:**

- Multi-line descriptions with block scalars (`>` or `|`)
- Descriptions over 75 characters (causes wrapping: 75 + 13 = 88 line limit)

## Writing Concise Descriptions

Keep descriptions focused on WHEN to invoke the agent:

- ✅ "Invoke for design review"
- ❌ "Invoke for design review with Playwright testing checking WCAG compliance..."

If you need to cut content to stay under 75 chars, move that detail into the agent body instead.

## Example Agent

```yaml
---
name: test-runner
description: "Invoke to run tests with terse results"
---

I run tests using the specified test runner (bun, pnpm, pytest, etc) and return a terse
summary with pass count and failure details only. This preserves your context by filtering
verbose test output to just what's needed for fixes.

[Rest of agent prompt...]
```

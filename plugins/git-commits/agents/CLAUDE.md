# Creating Claude Code Agents

When creating custom agent files in `.claude/agents/`, the YAML frontmatter format
matters.

## Valid Frontmatter Format

```yaml
---
name: agent-name
description: "Keep under 88 characters to prevent prettier from wrapping"
---
```

**Critical constraints:**

- **Single line only** - Claude Code doesn't parse block scalars (`>` or `|`) correctly
- **Under 88 characters** - Prettier wraps longer lines across repos with different
  configs
- **Use quotes** - Always quote descriptions to handle special characters like colons

**What works:**

- `description: Plain text under 88 chars`
- `description: "Double quoted under 88 chars"`
- `description: 'Single quoted under 88 chars'`

**What does NOT work:**

- Multi-line descriptions with block scalars (`>` or `|`)
- Descriptions over 88 characters (will wrap in some prettier configs)

## Writing Concise Descriptions

Keep descriptions focused on WHEN to invoke the agent:

- ✅ "Invoke for design review of UI changes"
- ❌ "Invoke for design review of UI changes with Playwright testing across viewports
  checking WCAG compliance..."

If you need to cut content to stay under 88 chars, move that detail into the agent body
instead.

## Example Agent

```yaml
---
name: test-runner
description: "Invoke to run tests and return focused, context-efficient results"
---
I run tests using the specified test runner (bun, pnpm, pytest, etc) and return a terse
summary with pass count and failure details only. This preserves your context by
filtering verbose test output to just what's needed for fixes.

[Rest of agent prompt...]
```

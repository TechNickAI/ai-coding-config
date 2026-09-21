# Creating Claude Code Agents

When creating custom agent files in `.claude/agents/`, the YAML frontmatter format
matters.

## Valid Frontmatter Format

```yaml
---
name: agent-name
# prettier-ignore
description: "Use when reviewing for X, checking Y, or verifying Z - include all semantic triggers"
model: opus
---
```

**Critical constraints:**

- **Single line only** - Claude Code doesn't parse block scalars (`>` or `|`) correctly
- **Use `# prettier-ignore`** - Add before description to allow longer, richer triggers
- **Use quotes** - Always quote descriptions to handle special characters like colons

## Description Philosophy

Agents are LLM-triggered. Descriptions should match against **user requests** to enable
Claude Code to auto-select the right agent. Use "Use when..." format with rich semantic
triggers.

**Do: Match user language**

Think about what users will say:

- "review the code"
- "check if this is production ready"
- "debug this error"
- "test in the browser"

Include those exact phrases in your descriptions.

**Do: Include variations**

```yaml
# prettier-ignore
description: "Use when reviewing for production readiness, fragile code, error handling, resilience, reliability, or catching bugs before deployment"
```

This triggers on: "review for production", "check fragile code", "error handling
review", "catch bugs", etc.

**Don't: Describe what it does**

Bad: `"A code reviewer that analyzes production readiness and error handling patterns"`

This is technical documentation, not a semantic trigger.

## Example Agent

```yaml
---
name: test-runner
# prettier-ignore
description: "Use when running tests, checking test results, or verifying tests pass before committing"
model: haiku
---
I run tests using the specified test runner (bun, pnpm, pytest, etc) and return a terse
summary with pass count and failure details only. This preserves your context by
filtering verbose test output to just what's needed for fixes.

[Rest of agent prompt...]
```

## Reviewer Agent Structure

Reviewer agents (agents that analyze code and report findings) should include two
additional sections:

### Review Signals

Replace prose "What I Look For" sections with scannable bullet lists. These prime the
LLM to pattern-match against specific signals.

```markdown
## Review Signals

These patterns warrant investigation:

**Category name**

- Specific pattern to look for
- Another specific pattern
- Concrete example of the smell

**Another category**

- Pattern
- Pattern
```

Bullet structure primes the LLM to look for these specific signals. Each bullet becomes
a micro-prompt. Not exhaustive—representative signals that train attention in the right
direction.

### Handoff

Reviewer agents typically run as subagents called by an orchestrator (like
multi-review). Add context so the agent understands its output goes to another LLM, not
a human.

```markdown
## Handoff

You're a subagent reporting to an orchestrating LLM (typically multi-review). The
orchestrator will synthesize findings from multiple parallel reviewers, deduplicate
across agents, and decide what to fix immediately vs. decline vs. defer.

Optimize your output for that receiver. It needs to act on your findings, not read a
report.
```

Do NOT prescribe output format in the Handoff section. Given context about who receives
the output and what they'll do with it, the agent can determine the most effective
format itself. Avoid over-specification.

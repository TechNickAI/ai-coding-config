---
name: skill-creator
description:
  Use when creating new skills or editing existing skills - applies prompt engineering
  principles to write clear, goal-focused process documentation that trusts LLM
  intelligence
---

# Skill Creator

## Overview

Skills are reusable reference guides for proven techniques, patterns, and tools. Write
them as intelligent companions would read them - focused on goals and outcomes, not
rigid procedures.

**Core principle:** Trust the LLM's intelligence. Describe what needs to happen and why,
not step-by-step how.

## When to Create a Skill

Create skills for:

- Techniques that weren't intuitively obvious to you
- Patterns you'd reference across projects
- Broadly applicable approaches (not project-specific)

Skip skills for:

- One-off solutions
- Well-documented standard practices
- Project-specific conventions (use CLAUDE.md instead)

## Skill Structure

Every skill has YAML frontmatter and markdown content:

```markdown
---
name: skill-name-with-hyphens
description: Use when [triggering conditions] - [what it does and how it helps]
---

# Skill Name

## Overview

What is this? Core principle in 1-2 sentences.

## When to Use

Clear triggers and symptoms. When NOT to use.

## Core Pattern

Show desired approach with examples. Describe alternatives in prose.

## Common Pitfalls

What goes wrong and how to avoid it.
```

### Frontmatter Requirements

**name:** Letters, numbers, hyphens only. Use verb-first active voice (e.g.,
`creating-skills` not `skill-creation`).

**description:** Third-person, under 500 characters. Start with "Use when..." to
describe triggering conditions, then explain what it does. Include concrete symptoms and
situations, not just abstract concepts.

Good:
`Use when tests have race conditions or pass/fail inconsistently - replaces arbitrary timeouts with condition polling for reliable async tests`

Bad: `For async testing` (too vague, missing triggers)

## Writing Principles from Prompt Engineering

### Show, Don't Tell (Pattern Reinforcement)

LLMs encode patterns from what you show them. Demonstrate desired approaches with 5+
examples. Describe undesired alternatives in prose without code.

Good:

```typescript
// Use condition-based waiting for reliable async tests
await waitFor(() => element.textContent === "loaded");
await waitFor(() => user.isAuthenticated === true);
await waitFor(() => data.length > 0);
```

Then in prose: "Avoid arbitrary timeouts like setTimeout() which make tests brittle and
slow."

Bad: Showing multiple "wrong way" code examples - you're teaching the pattern you don't
want.

### Focus on Goals, Not Process

Describe outcomes and constraints. Let the LLM figure out how to achieve them.

Good: "Ensure each test has a clear failure mode that identifies what's wrong. Tests
should verify behavior, not implementation details."

Bad: "Step 1: Write test name. Step 2: Set up test data. Step 3: Call function. Step 4:
Assert result..."

### Positive Framing

Frame as "do this" not "avoid that." Focus on what success looks like.

Good: "Write minimal code to pass the test. Add features only when tests require them."

Bad: "Don't add features. Don't over-engineer. Don't anticipate requirements..."

### Trust Intelligence

Assume the LLM can handle edge cases and variations. Specify boundaries, not decision
trees.

Good: "Check if files exist before copying. If they differ, show changes and ask the
user what to do."

Bad:

```
If file exists:
  a. Run diff
  b. If identical → skip
  c. If different:
     i. Show diff
     ii. Ask user
     iii. If user says yes → copy
     iv. If user says no → skip
```

## File Organization

**Self-contained (preferred):**

```
skill-name/
  SKILL.md    # Everything inline
```

**With supporting files (when needed):**

```
skill-name/
  SKILL.md           # Overview + patterns
  reference.md       # Heavy API docs (100+ lines)
  tool-example.ts    # Reusable code to adapt
```

Only separate files for:

- Heavy reference material (comprehensive API docs)
- Reusable tools (actual code to copy/adapt)

Keep inline:

- Principles and concepts
- Code patterns under 50 lines
- Everything else

## Optimize for Discovery

Future Claude needs to find your skill. Use rich keywords:

- Error messages: "ENOTEMPTY", "race condition", "timeout"
- Symptoms: "flaky", "inconsistent", "unreliable"
- Tools: Actual command names, library names
- Synonyms: Different terms for same concept

Put searchable terms in the description and throughout the content.

## Token Efficiency

Every skill loaded costs tokens. Be concise:

- Frequently-loaded skills: under 200 words
- Other skills: under 500 words
- Reference external docs rather than duplicating them
- Use cross-references to other skills instead of repeating

## Quality Checklist

Before considering a skill complete:

**Structure:**

- Frontmatter with name and description (third-person, "Use when...")
- Clear overview with core principle
- Concrete "when to use" triggers
- Examples showing desired patterns (5+ for main approach)

**Content:**

- Goals and outcomes, not rigid procedures
- Positive framing (show what to do)
- Trust LLM intelligence (avoid over-prescription)
- Keywords for search throughout
- Common pitfalls addressed

**Organization:**

- Self-contained in SKILL.md when possible
- Supporting files only when truly needed
- Under 500 words unless it's reference material

## Common Mistakes

**Over-prescription:** Writing detailed step-by-step procedures for things the LLM can
figure out. Describe the goal, not the algorithm.

**Showing anti-patterns:** Demonstrating "wrong" code teaches that pattern. Describe
alternatives in prose instead.

**Vague triggers:** "Use when debugging" is too broad. "Use when encountering test
failures with unclear root causes" is specific.

**First person:** Skills inject into system prompts. Write "Use when..." not "I can help
when..."

**Missing keywords:** Future Claude searches for skills by symptoms and errors. Include
the terms someone would actually search for.

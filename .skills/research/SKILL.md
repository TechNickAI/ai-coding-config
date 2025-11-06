---
name: research
description: Web research skill for augmenting agent context with current information. This skill should be used when an agent needs up-to-date information beyond its knowledge cutoff, when verifying current API documentation, checking for breaking changes, or gathering comprehensive information to make informed decisions.
---

# Research

## Overview

This skill enables agents to perform web research at different depth levels, from quick fact-checking to comprehensive investigations. The research is designed to augment agent knowledge with current information, producing structured findings that inform better decisions and implementations.

## When to Offer Research

Proactively offer research when:
- Working with technologies or APIs from 2024 or later
- Encountering potential version conflicts or deprecations
- Making architectural decisions requiring current best practices
- Implementing features where standards may have evolved
- Seeing errors that suggest API changes or breaking updates

Example offering: "I should research the current NextAuth.js implementation patterns since the library has likely evolved since my knowledge cutoff. Would you like me to do that?"

## Research Depth Levels

### Quick (<1 minute)
Fast fact-checking and validation. Used for:
- Version verification: "What's the latest stable React version?"
- API changes: "Did Vite change the config format in v6?"
- Breaking changes: "Is this webpack plugin still maintained?"
- Quick validation: "Does this approach work with TypeScript 5?"

**Output**: Structured facts with source links, minimal narrative.

### Standard (5-10 minutes)
Implementation research for active coding. Used for:
- Understanding APIs: "How does Stripe webhook validation work?"
- Comparing options: "tRPC vs GraphQL for this use case"
- Getting unstuck: "Why isn't this React Server Component pattern working?"
- Current patterns: "Best practices for Next.js 14 data fetching"

**Output**: Actionable findings with code examples, gotchas, implementation notes.

### Deep (15-30+ minutes)
Comprehensive research for major decisions. Used for:
- Architecture choices: "Microservices vs monolith for our scale"
- Complex evaluations: "Auth strategy for multi-tenant SaaS"
- Emerging tech: "How do React Server Components actually work?"
- Migration planning: "Moving from Express to Fastify implications"

**Output**: Thorough analysis with multiple perspectives, trade-offs, recommendations.

## Research Process

### 1. Check Existing Research

Before starting new research, check the `research/` folder for existing findings:

```bash
# Check if research exists and when it was created
ls -la research/ | grep -i [topic]

# For quick research: reuse if <24 hours old
# For standard research: reuse if <7 days old
# For deep research: reuse if <30 days old
```

If recent relevant research exists, read it first and determine if it needs updating or can be reused.

### 2. Structure Research Output

Research findings go in `research/[topic-name].md` using lowercase with hyphens. The content structure adapts to the depth level but generally includes:

```markdown
# [Topic]

Generated: [timestamp]
Depth: [quick/standard/deep]

## Key Findings
- Critical fact or insight [source]
- Another key point [source]

## [Context-Appropriate Sections]
[Varies by research type and findings]

## Sources
[Numbered list of sources consulted]
```

### 3. Execute Research

Use WebSearch to gather information, prioritizing:
- Official documentation and changelogs
- Recent GitHub issues and discussions
- Technical blogs and tutorials (check dates)
- Stack Overflow (verify currency)

For conflicting information, note discrepancies and provide context for both viewpoints.

### 4. Process Findings

Transform raw search results into actionable intelligence:
- Extract facts relevant to the current task
- Include code snippets when applicable
- Note version dependencies and dates
- Highlight gotchas and edge cases
- Mark uncertain information clearly

## Output Guidelines

Research output is primarily for agent consumption while remaining human-readable. Follow these principles:

### Structure Over Narrative
Write scannable, structured content. Use headings, bullets, and code blocks rather than prose paragraphs. The goal is quick information extraction, not storytelling.

### Facts Over Flourish
State findings directly. Skip preambles like "After extensive research..." or "It's important to note that..." Get to the point.

### Actionable Over Abstract
Focus on what the agent needs to know to complete the task. Include specific version numbers, exact API calls, and working code examples.

### Confidence Signals
Mark uncertainty explicitly:
- "Confirmed in v5.0.0 docs"
- "Multiple sources agree"
- "Conflicting information: some sources say X, others say Y"
- "Could not verify for latest version"

## Example Usage Patterns

### Quick Research in Flow
```
User: "Fix the build error with Vite"
Agent: "Let me quickly check if this is related to Vite 6 changes"
[Quick research on Vite 6 breaking changes]
Agent: "Found it - Vite 6 changed how environment variables are handled. Here's the fix..."
```

### Standard Research for Implementation
```
User: "Add Google OAuth to the app"
Agent: "I'll research the current best practices for Google OAuth implementation"
[Standard research on OAuth patterns, latest libraries]
Agent: [Uses findings to implement correctly with 2025 patterns]
```

### Deep Research for Architecture
```
User: "Should we use GraphQL or tRPC for our API?"
Agent: "This is an important architectural decision. Let me do comprehensive research on both options for your use case"
[Deep research comparing both, checking recent developments]
Agent: [Provides thorough recommendation based on findings]
```

## References

When performing research, reference these guidelines for optimal output:

- `.cursor/rules/prompt-engineering.mdc` - For structuring effective agent prompts
- `.cursor/rules/user-facing-language.mdc` - For writing clear, scannable findings

These documents provide principles for goal-focused instructions, pattern reinforcement, and clear communication that should inform how research findings are structured.

## Notes

- Research output visibility: Show progress indicators but keep detailed findings in background unless user requests
- Source quality: Always note publication dates and prefer official sources
- Caching strategy: Reuse recent research when appropriate but refresh for critical decisions
- Format flexibility: Adapt output structure to the specific research needs rather than forcing a rigid template
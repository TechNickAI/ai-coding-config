---
name: brainstorming
description: Use when developing rough ideas into designs, before writing code or implementation plans - refines concepts through collaborative questioning and incremental validation
---

# Brainstorming Ideas Into Designs

## Overview

Turn rough ideas into fully-formed designs through natural collaborative dialogue. Understand the context, explore alternatives, validate incrementally.

**Core principle:** Ask questions to understand, present options to explore, validate sections to refine.

## When to Use

Use brainstorming when:
- You have a rough idea but unclear implementation
- Multiple approaches exist and you need to choose
- Requirements are fuzzy or incomplete
- Design decisions need validation before coding

Don't use for:
- Clear mechanical tasks with obvious solutions
- Well-defined requirements with standard implementations
- Simple bug fixes or minor changes

## Brainstorming Process

### Understanding the Context

Start by exploring the current project state. Check existing files, documentation, recent commits. Understand what's already built.

Ask questions one at a time to refine the idea. Use multiple choice when possible - easier to answer than open-ended. Focus on understanding:
- Purpose: What problem does this solve?
- Constraints: What limits the solution?
- Success criteria: How do we know it works?

One question per message. If a topic needs more exploration, break it into multiple questions. Don't overwhelm with a list of questions.

### Exploring Alternatives

Propose 2-3 different approaches with their tradeoffs. Present conversationally:

```
I see three main approaches:

1. Direct integration - Fast to implement but creates coupling. Good if this is temporary.

2. Event-driven - More flexible, better separation, but adds complexity. Worth it if we'll extend this.

3. Separate service - Maximum isolation, easier to scale, but operational overhead. Overkill unless we need independent scaling.

I'd recommend #2 (event-driven) because the requirements suggest we'll add features here, and the loose coupling will make that easier. What do you think?
```

Lead with your recommendation and reasoning. Let the human partner react and redirect.

### Presenting the Design

Once you understand what you're building, present the design in small sections. Break it into 200-300 word chunks covering:
- Architecture and component structure
- Data flow and state management
- Error handling and edge cases
- Testing approach

Ask after each section whether it looks right. Be ready to go back and clarify if something doesn't make sense.

This incremental validation catches misunderstandings early before you've written a complete design document.

### After Validation

Write the validated design to `docs/plans/YYYY-MM-DD-<topic>-design.md`. Keep it concise and focused on decisions and rationale, not implementation details.

Commit the design document to git so it's tracked with the project.

If continuing to implementation, ask whether to proceed. Set up an isolated workspace for development (git worktree or feature branch). Create a detailed implementation plan breaking the design into concrete tasks.

## Key Principles

**One question at a time.** Don't list multiple questions. Ask one, get an answer, ask the next.

**Multiple choice preferred.** "Should we use events or direct calls?" is easier than "How should components communicate?"

**YAGNI ruthlessly.** Remove unnecessary features from designs. Build what's needed, not what might be needed someday.

**Explore alternatives always.** Present 2-3 approaches before settling on one. This surfaces tradeoffs.

**Incremental validation.** Present design in sections, validate each before continuing. Don't write a complete design then ask for feedback - you might be heading the wrong direction.

**Be flexible.** When something doesn't make sense to your partner, go back and clarify. Don't defend the design, refine it.

## Example Flow

```
Partner: "We need to handle webhook retries better"

You: [Check current webhook code, recent issues]
You: "I see webhooks are currently fire-and-forget. When they fail,
we lose the event. Is the main concern reliability (making sure we
eventually process every webhook) or debugging (knowing why webhooks
failed)?"

Partner: "Mainly reliability. We're losing orders when Stripe webhooks fail."

You: "Got it. Should retries happen automatically in the background,
or should failed webhooks go to a queue for manual review?"

Partner: "Automatic retries with exponential backoff, but alert us
if they keep failing."

You: [Present 2-3 approaches: queue-based, scheduled job, webhook service]
You: [Recommend queue-based for reliability]
You: [After agreement, present design section by section]
You: [Write validated design to docs/plans/]
You: [Ask if ready to implement]
```

## Common Pitfalls

Describe anti-patterns in prose: Don't ask many questions at once. Don't present a complete design without incremental validation. Don't skip exploring alternatives. Don't add features beyond stated requirements. Don't continue with a design that confuses your partner - go back and clarify first.

## Integration with Other Skills

After brainstorming, use `test-driven-development` when implementing to ensure quality.

For complex implementations, create a detailed plan before coding.

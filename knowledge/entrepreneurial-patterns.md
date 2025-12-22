# Entrepreneurial Thinking Patterns

Created: December 2024
Source: Meta-analysis of 15+ AI coding configuration projects
Purpose: Patterns that compound entrepreneurial effectiveness

---

## Core Insight

The most effective systems encode wisdom into structure. Past-you, thinking clearly,
designs constraints that guide present-you toward right action. The system enforces what
wise-you already decided.

This works because systems don't get tired, excited, or distracted. They execute
consistently regardless of your current state.

---

## Pattern 1: Constitution Before Code

Write foundational principles before building features.

Daniel Miessler wrote 1,500 lines of principles before a single feature. His founding
principles include:

- Scaffolding > Model: Build structure first, add intelligence second
- Code Before Prompts: Code is cheaper, faster, more reliable
- As Deterministic as Possible: Consistency beats flexibility in production

Application: Before starting any significant project, write its constitution. Document
the non-negotiable principles. Decide what decisions are already made. When X happens, Y
follows. No judgment required in the moment.

---

## Pattern 2: Mandatory Over Optional

Build systems where good behavior is enforced, not available.

obra's superpowers project checks for relevant skills BEFORE any task. You cannot
proceed without completing the required steps. dotai implements a "No Rationalization"
system that explicitly addresses common excuses.

Application: For every important practice, create a gate rather than a reminder. Design
forcing functions where progress requires completion. Make the right path the only path.

---

## Pattern 3: Two-Stage Verification

Separate "did I achieve the goal" from "did I achieve it well."

superpowers uses two distinct reviews:

1. Spec compliance: Does the output match what was requested?
2. Quality review: Is the implementation sound?

Two different questions deserve two different evaluation moments.

Application: Every significant output gets evaluated twice with different criteria.
Separate the questions. Consider having different reviewers for each stage.

---

## Pattern 4: Evidence-Based Completion

Define "done" with observable proof before starting.

dotai's beforeComplete hook requires fresh evidence before claiming completion. The
standard is not effort or intention. The standard is: show me the test passing, the
metric achieved, the proof in hand.

Application: For every task, answer first: "What evidence would prove this is complete?"
Write it down. Claim completion only when holding that evidence.

---

## Pattern 5: Progressive Disclosure

Layer complexity to reduce cognitive load.

Personal_AI_Infrastructure uses three-tier context loading:

- Tier 1: Core principles (200-500 words) - always active
- Tier 2: Skill details (500-2000 lines) - on-demand
- Tier 3: Reference material - just-in-time deep dives

This achieves 70% cognitive load reduction.

Application: For any complex topic, create three versions: the tweet-length summary, the
paragraph explanation, the full document. Lead with the smallest version that's
sufficient. Layer detail as needed.

---

## Pattern 6: Session Persistence

Externalize state so future-you can resume in 30 seconds.

claude-flow saves session state for seamless continuation. Every context switch costs
momentum. Every restart loses uncaptured progress.

Capture includes:

- Current thinking and decisions made
- Next actions and open questions
- Modified state and key context

Application: End every work session with a capture ritual. Document not just what you
did, but where you are and what's next. Enable 30-second resumption.

---

## Pattern 7: Parallel Specialization

Coordinate specialists rather than context-switching between perspectives.

claude-flow uses hive-mind architecture. Queen agent coordinates specialized workers.
Each agent focuses on one domain: security, performance, architecture. Each does one
thing excellently.

Application: For complex problems, identify the perspectives required. Address them
sequentially with full focus, or delegate each to a specialist. Build a hive-mind rather
than trying to be the entire hive-mind.

---

## Pattern 8: Natural Triggers

Design environments where right behavior activates automatically.

claude-flow skills activate from natural language, not explicit commands. The right
behavior happens because context triggers it, not because you remembered to invoke it.

Application: For every desired behavior, design environmental triggers. Make the right
action the default. Encode triggers in context rather than relying on memory and
willpower.

---

## Implementation Guide

Choose one pattern based on current focus:

| Pattern | Choose when... |
|---------|----------------|
| Constitution Before Code | Starting something new, seeking clarity |
| Mandatory Over Optional | Know what to do, want consistent execution |
| Two-Stage Verification | Quality matters, want thorough evaluation |
| Evidence-Based Completion | Projects feel incomplete or drag on |
| Progressive Disclosure | Managing complexity, communicating clearly |
| Session Persistence | Working across multiple sessions |
| Parallel Specialization | Facing complex multi-faceted problems |
| Natural Triggers | Good intentions, want automatic execution |

---

## The Compound Effect

These patterns reinforce each other:

- Constitution provides the principles that mandatory gates enforce
- Evidence-based completion defines what the two-stage review verifies
- Session persistence preserves the context that natural triggers activate
- Progressive disclosure structures the information that specialists coordinate

Start with one. Let it compound. Add another when the first is solid.

---

## Related Context

- `knowledge/competitors/competitor-analysis.md` - Full technical analysis
- Daniel Miessler's CONSTITUTION.md pattern
- obra's mandatory workflow enforcement
- dotai's lifecycle hook system

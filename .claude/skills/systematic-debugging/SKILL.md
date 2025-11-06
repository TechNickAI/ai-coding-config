---
name: systematic-debugging
description: Use when encountering bugs, test failures, or unexpected behavior - ensures root cause understanding before attempting fixes, preventing wasted time on symptom patches
---

# Systematic Debugging

## Overview

Find the root cause before writing fixes. Random patches waste time and create new bugs.

**Core principle:** Understand WHY something breaks before changing it. Symptom fixes are failures.

## When to Use

Use for any technical issue:
- Test failures, build errors, integration issues
- Bugs in production or development
- Unexpected behavior, performance problems
- Especially when under time pressure or after previous fixes failed

**Don't skip when:**
- The issue seems simple (simple bugs have root causes)
- You're in a hurry (systematic is faster than thrashing)
- "One quick fix" seems obvious

## The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE UNDERSTANDING
```

If you can't explain WHY it's broken, you can't propose fixes.

## Debugging Framework

### Understand the Failure

**Read error messages completely.** Stack traces, line numbers, error codes contain the solution. Don't skim past them.

**Reproduce reliably.** If you can't trigger it consistently, gather more data before guessing. Document exact steps.

**Check recent changes.** What changed that could cause this? Review git diff, recent commits, new dependencies, config changes, environmental differences.

**Trace the data flow.** Where does the bad value originate? Work backward from the error through the call stack until you find the source. Fix at the source, not at the symptom.

### For Multi-Component Systems

When multiple components interact (CI → build → signing, API → service → database), add diagnostic instrumentation at each boundary:

```bash
# Example: Debugging a signing failure

# Layer 1: Secrets available?
echo "IDENTITY: ${IDENTITY:+SET}${IDENTITY:-UNSET}"

# Layer 2: Env vars propagated?
env | grep IDENTITY || echo "IDENTITY missing"

# Layer 3: Keychain state?
security find-identity -v

# Layer 4: Signing verbose output
codesign --sign "$IDENTITY" --verbose=4 "$APP"
```

Run once to see WHERE it breaks, then investigate that specific component. Gather evidence showing which layer fails.

### Compare Working Examples

Find similar code that works. What's different between working and broken? List every difference - don't assume "that can't matter."

Read reference implementations completely if implementing a pattern. Don't skim. Understand dependencies, settings, config, environment requirements.

### Form and Test Hypotheses

State clearly: "X is the root cause because Y." Be specific. Make the smallest possible change to test it.

One variable at a time. Don't fix multiple things at once.

If it works → implement properly with tests. If it doesn't → form a NEW hypothesis. Don't add more fixes on top.

### Fix the Root Cause

Create a failing test that reproduces the issue. Automated test if possible, one-off test script otherwise. Must have before fixing.

Implement the single fix addressing the root cause. No "while I'm here" improvements. No bundled refactoring.

Verify the fix: test passes, no other tests broken, issue actually resolved.

**If the fix doesn't work:** Count your attempts. If this is your third failed fix, STOP and question the architecture (see below).

## The Three-Fix Rule

After three failed fixes, stop attempting more fixes. The pattern indicates an architectural problem:
- Each fix reveals new shared state or coupling in a different place
- Fixes require massive refactoring to implement correctly
- Each fix creates new symptoms elsewhere

This isn't a failed hypothesis - this is wrong architecture. Question fundamentals:
- Is this pattern sound?
- Are we persisting through inertia?
- Should we refactor the architecture instead of fixing symptoms?

Discuss with your human partner before attempting more fixes.

## Common Debugging Patterns

**Good debugging looks like:**

```typescript
// Read the actual error message
// Error: Cannot read property 'id' of undefined at getUserData (user.ts:45)

// Trace back: where does user come from?
// user.ts:45 → called from api.ts:23
// api.ts:23 → user = await fetchUser(userId)
// fetchUser returns undefined when user not found

// Root cause: missing null check after fetchUser
// Fix: Handle the null case before accessing properties
```

Describe anti-patterns in prose: Avoid trying random fixes hoping one works. Avoid "quick patches for now, investigate later." Avoid fixing multiple things simultaneously without knowing which helped.

## Red Flags - Stop and Find Root Cause

If you catch yourself thinking:
- "Quick fix for now, investigate later"
- "Just try changing X and see if it works"
- "I don't fully understand but this might work"
- "Here are several things to try" (without investigation)
- "One more fix attempt" (when already tried 2+)

**ALL of these mean: STOP. Find the root cause first.**

## When You Don't Understand

Say "I don't understand X." Don't pretend to know. Ask for help or research more. Understanding before fixing isn't optional.

## Integration with Other Skills

Use `test-driven-development` for creating failing test cases before implementing fixes.

Use `verification-before-completion` to ensure the fix actually worked before claiming success.

## Real-World Impact

Systematic debugging: 15-30 minutes to fix, 95% first-time success, near-zero new bugs introduced.

Random fixes: 2-3 hours of thrashing, 40% first-time success, common new bugs.

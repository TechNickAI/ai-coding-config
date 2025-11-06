---
name: verification-before-completion
description: Use when about to claim work is complete, fixed, or passing - requires running verification commands and confirming actual output before making success claims
---

# Verification Before Completion

## Overview

Evidence before claims. Always.

**Core principle:** Run the verification command and read the actual output before claiming anything works.

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this message, you cannot claim it passes.

## When to Verify

Before claiming:
- "Tests pass" → Run the test suite, confirm 0 failures
- "Build succeeds" → Run the build command, confirm exit 0
- "Bug fixed" → Test the original symptom, confirm it's resolved
- "Linter clean" → Run the linter, confirm 0 errors
- "Requirements met" → Check each requirement, report actual status
- Any expression of success or completion

## Verification Framework

**Identify what proves the claim.** What command or check demonstrates this actually works?

**Run the full verification.** Fresh execution, complete output, not partial checks or previous runs.

**Read the actual output.** Check exit codes, count failures, read error messages completely. Don't skim.

**Confirm it matches the claim.** Does the output actually prove what you're about to say?

**Then make the claim with evidence.** Show the proof alongside the assertion.

## Examples of Proper Verification

```bash
# Claiming tests pass:
$ npm test
✓ All tests passed (34/34)

# Claiming build succeeds:
$ npm run build
Build completed successfully
Exit code: 0

# Claiming linter is clean:
$ npm run lint
✓ No linting errors found
```

Common mistakes described in prose: Don't use "should work now" or "probably passes" - run the actual command. Don't trust agent success reports without verifying the changes. Don't rely on partial verification like "linter passed" when you need to verify the build. Don't extrapolate from previous runs - verification must be fresh.

## Special Cases

### Regression Tests (TDD Red-Green Cycle)

For bug fixes with regression tests, verify the complete cycle:
1. Write test → Run (should fail initially if bug exists)
2. Fix bug → Run (should pass)
3. Revert fix → Run (MUST fail again to prove test catches the bug)
4. Restore fix → Run (should pass)

Without step 3, you haven't verified the test actually catches the bug.

### Requirements Checking

For phase completion claims, re-read the plan and create a checklist. Verify each item explicitly. Report gaps or completion with evidence.

Tests passing doesn't automatically mean requirements are met. Check the actual requirements.

### Agent Delegation

When agents report success:
1. Check version control diff to see what actually changed
2. Verify changes do what was requested
3. Run relevant tests/builds
4. Report actual state based on your verification

Agent success reports are claims that need verification, not evidence.

## Red Flags - Stop and Verify

If you catch yourself:
- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Great!", "Done!")
- About to commit or create PR without running checks
- Trusting agent reports without independent verification
- Relying on partial checks (linter when you need build)
- Tired and wanting to finish
- Thinking "just this once"

**ALL of these mean: STOP. Run verification first.**

## Why Verification Matters

Claiming success without verification:
- Breaks trust ("I don't believe you")
- Ships broken code (undefined functions, missing features)
- Wastes time on false completion followed by rework
- Violates core honesty principles

## The Bottom Line

Run the command. Read the output. Then make the claim.

No shortcuts. No exceptions. No "should work" or "probably passes."

Fresh verification evidence before every completion claim.

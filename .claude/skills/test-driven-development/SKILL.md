---
name: test-driven-development
description: Use when implementing features or fixing bugs, before writing implementation code - write the test first and watch it fail to ensure tests actually verify behavior
---

# Test-Driven Development (TDD)

## Overview

Write the test first. Watch it fail. Write minimal code to pass.

**Core principle:** If you didn't watch the test fail, you don't know if it tests the right thing.

## The Iron Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

Write code before the test? Delete it and start over. No exceptions.

## When to Use

Always use TDD for:
- New features
- Bug fixes
- Refactoring
- Behavior changes

Exceptions (ask your partner first):
- Throwaway prototypes
- Generated code
- Configuration files

Thinking "skip TDD just this once"? That's rationalization. Don't.

## The Red-Green-Refactor Cycle

### RED: Write a Failing Test

Write one minimal test showing what should happen:

```typescript
test('retries failed operations 3 times', async () => {
  let attempts = 0;
  const operation = () => {
    attempts++;
    if (attempts < 3) throw new Error('fail');
    return 'success';
  };

  const result = await retryOperation(operation);

  expect(result).toBe('success');
  expect(attempts).toBe(3);
});
```

Requirements: one behavior, clear name, real code (avoid mocks unless unavoidable).

Run the test. Confirm it fails with the expected message. Failing because the feature is missing, not because of typos or errors.

**Test passes?** You're testing existing behavior. Fix the test.

**Test errors?** Fix the error, re-run until it fails correctly.

### GREEN: Write Minimal Code

Write the simplest code to pass the test:

```typescript
async function retryOperation<T>(fn: () => Promise<T>): Promise<T> {
  for (let i = 0; i < 3; i++) {
    try {
      return await fn();
    } catch (e) {
      if (i === 2) throw e;
    }
  }
  throw new Error('unreachable');
}
```

Just enough to pass. Don't add features, refactor other code, or "improve" beyond what the test requires.

Run the test. Confirm it passes. Confirm other tests still pass. Check for clean output (no errors or warnings).

**Test fails?** Fix the code, not the test.

**Other tests fail?** Fix them now before continuing.

### REFACTOR: Clean Up

After the test is green, improve the code:
- Remove duplication
- Improve names
- Extract helpers

Keep all tests green. Don't add behavior during refactoring.

### Repeat

Write the next failing test for the next feature.

## Why Test-First Matters

**"I'll write tests after to verify it works"**

Tests written after code pass immediately. That proves nothing:
- Might test the wrong thing
- Might test implementation, not behavior
- Might miss edge cases
- You never saw it catch the bug

Test-first forces you to see the test fail, proving it actually tests something.

**"Deleting working code is wasteful"**

Sunk cost fallacy. Your choice:
- Delete and rewrite with TDD (more time, high confidence)
- Keep it and add tests after (less time, low confidence, likely bugs)

The waste is keeping code you can't trust.

**"TDD is dogmatic, being pragmatic means adapting"**

TDD IS pragmatic:
- Finds bugs before commit (faster than debugging after)
- Prevents regressions (tests catch breaks immediately)
- Documents behavior (tests show how to use code)
- Enables refactoring (change freely, tests catch breaks)

Pragmatic shortcuts create debugging work later.

## Good Test Characteristics

```typescript
// ✅ Good: Clear name, tests real behavior, one thing
test('validates email format', () => {
  expect(isValidEmail('user@example.com')).toBe(true);
  expect(isValidEmail('invalid')).toBe(false);
});

// ✅ Good: Tests actual behavior users care about
test('rejects empty email', () => {
  const result = submitForm({ email: '' });
  expect(result.error).toBe('Email required');
});

// ✅ Good: One assertion per concept
test('parses valid JSON', () => {
  const result = parseJSON('{"key": "value"}');
  expect(result).toEqual({ key: 'value' });
});
```

Describe anti-patterns in prose: Don't write vague test names like "test1" or "works correctly." Don't use mocks when you can test real code. Don't test implementation details that might change - test the behavior users care about. Don't combine multiple unrelated assertions in one test.

## Example: Bug Fix Flow

**Bug:** Empty email accepted

**RED:**
```typescript
test('rejects empty email', () => {
  const result = submitForm({ email: '' });
  expect(result.error).toBe('Email required');
});
```

Run test → See it fail with "expected 'Email required', got undefined"

**GREEN:**
```typescript
function submitForm(data: FormData) {
  if (!data.email?.trim()) {
    return { error: 'Email required' };
  }
  // ... rest of validation
}
```

Run test → See it pass → Confirm other tests still pass

**REFACTOR:**
Extract validation if needed, keep tests green

## Red Flags - Stop and Delete Code

If you catch yourself:
- Writing code before the test
- Adding tests after implementation
- Test passes immediately without seeing it fail
- Can't explain why the test failed
- Rationalizing "just this once"
- "I already manually tested it"
- "Tests after achieve the same purpose"
- "Keep as reference" or "adapt existing code"

**ALL of these mean: Delete the code. Start over with TDD.**

## Verification Checklist

Before claiming work complete:
- Every new function/method has a test
- Watched each test fail before implementing
- Each test failed for the expected reason (feature missing, not typo)
- Wrote minimal code to pass each test
- All tests pass with clean output
- Tests use real code (mocks only if unavoidable)
- Edge cases and errors covered

Can't check all boxes? You skipped TDD. Start over.

## Integration with Other Skills

Use `systematic-debugging` when bugs are found - write a failing test reproducing the bug, then fix it. The test proves the fix and prevents regression.

Use `verification-before-completion` to ensure all tests actually pass before claiming work is done.

## The Bottom Line

```
Production code → test exists and failed first
Otherwise → not TDD
```

No exceptions without your partner's permission.

# Code Review Standards

When reviewing code or triaging bot feedback, use these standards to identify
suggestions that don't apply given context bots lack.

## Core Philosophy

Address all suggestions where the bot's analysis is correct given full context. Decline
when you can articulate why the bot's reasoning doesn't hold—valid declines explain why
the analysis is incorrect, not why addressing it is inconvenient.

Simplicity is a virtue. Complexity is itself a bug vector.

## Complexity Trade-offs

Bots flag edge cases as "severe" which pressures fixes, but the fix often adds more
complexity than the risk it mitigates.

When a fix requires significant error handling, branching logic, or edge case coverage,
weigh the cure against the disease. A theoretical race condition that requires 200 lines
of mutex logic may introduce more bugs than it prevents.

Valid reasons to decline:

- The fix adds more complexity than the risk it mitigates
- The edge case requires unlikely production conditions to trigger
- The "robust" solution would obscure the happy path beyond recognition
- Simple code that fails clearly beats complex code that fails mysteriously

Don't turn 10 lines of clear code into 50 lines of defensive programming for a 0.01%
edge case. "Wontfix: increases complexity" is valid when the cure is worse than the
disease.

## When Bot Suggestions Don't Apply

These patterns describe situations where bot analysis is typically incorrect. Decline
with explanation when you can demonstrate the bot's reasoning doesn't hold.

### Single-Use Values

Bots flag inline values as "magic strings" needing extraction. This is wrong when the
value appears exactly once and context makes the meaning clear. Extracting
`METHOD_INITIALIZE = "initialize"` for a single use adds indirection without DRY
benefit. Constants exist to stay DRY across multiple uses, not to avoid inline values.

### Theoretical Race Conditions

Bots flag potential race conditions based on static analysis. This is wrong when
operations are already serialized by a queue, mutex, or transaction the bot can't see.
Add synchronization when profiling or testing reveals actual race conditions.

### Redundant Type Safety

Bots suggest stricter types or null checks. This is wrong when runtime validation
already handles the case correctly, or when the type system guarantees the condition
can't occur. TypeScript serves the code—working code with runtime safety takes priority
over compile-time type perfection.

### Premature Optimization

Bots flag performance concerns without data. This is wrong when no profiling shows
actual performance problems. Optimize based on measurements—complexity should yield
measurable performance gains.

## Case-by-Case Judgment

These require evaluation in context—sometimes the bot is right, sometimes wrong.

### Test Coverage Gaps

Bot requests for edge case tests: Address if the edge case could reasonably occur and
cause user-facing issues. Decline if you can demonstrate the scenario is already handled
by other validation or genuinely can't occur given system constraints.

### Documentation Requests

Bot requests for additional docs: Address if the code is genuinely unclear. Decline if
the documentation would merely restate what the code already says clearly.

### Accessibility Improvements

Accessibility (ARIA labels, keyboard navigation, screen reader support) is a product
priority decision that varies by project. Check project configuration for the team's
stance. If no stance is declared, ask whether to address or decline.

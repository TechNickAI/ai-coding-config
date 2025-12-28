---
description: Verify a fix actually works before claiming success
argument-hint: [description of what to verify]
version: 1.0.0
---

# Verify Fix Command

<objective>
Verify that a fix actually works before claiming success. Run tests, check live behavior,
confirm the change resolves the issue. This command prevents false "I fixed it" claims
that destroy trust.

Core principle: A fix isn't fixed until you've seen it work.
</objective>

<usage>
/verify-fix [what to verify]

- /verify-fix - Verify the most recent fix (infer from context)
- /verify-fix "login redirect works" - Verify specific behavior
- /verify-fix auth tests - Run auth-related tests
</usage>

<verification-process>
1. Identify what changed and what behavior should be different
2. Determine the appropriate verification method
3. Run the verification
4. Report results with evidence
</verification-process>

<verification-methods>
Match verification to change type:

**Tests exist:** Run the relevant test file or test suite.

```bash
# TypeScript/JavaScript
pnpm test path/to/affected.test.ts
npm test -- --testPathPattern="ComponentName"
vitest run src/component.test.tsx

# Python
pytest path/to/test_module.py -v

# Go
go test ./pkg/... -run TestAffectedFunction
```

**UI changes:** Start dev server and verify visually or fetch the page.

```bash
# Verify page loads correctly
curl -s http://localhost:3000/affected-page | head -20

# Or use MCP Playwright tools for visual verification
mcp__plugin_playwright_playwright__browser_navigate to affected URL
mcp__plugin_playwright_playwright__browser_snapshot to capture state
```

**API changes:** Hit the endpoint and check the response.

```bash
curl -X POST http://localhost:3000/api/endpoint \
  -H "Content-Type: application/json" \
  -d '{"test": "data"}'
```

**Config changes:** Verify the config loads without error.

```bash
node -e "require('./config')"
python -c "from config import settings; print(settings)"
```

**Build/compile:** Verify the build succeeds.

```bash
pnpm build
npm run build
go build ./...
```
</verification-methods>

<output-format>
**On successful verification:**

```
✓ Verified: [what was tested]
  Ran: [command]
  Result: [specific outcome - N tests passed, page loads, response correct]
  Evidence: [URL, test output, or response snippet]

Fix confirmed: [specific claim about what's now working]
```

**On failed verification:**

```
✗ Verification failed
  Ran: [command]
  Result: [what happened]
  Error: [specific error message or unexpected behavior]

The fix is NOT confirmed. [Next action: investigating X / trying Y / need more info]
```
</output-format>

<language-standards>
Before verification, use hedged language:
- "I believe this should fix..."
- "My hypothesis is..."
- "This appears to resolve..."

After successful verification, use confident language:
- "Verified: the login redirect now works correctly"
- "Fix confirmed: tests pass and the page loads"

Claim success only with specific evidence. Epistemic honesty preserves trust.
</language-standards>

<integration>
Use this command:
- After implementing any fix, before telling the user it's done
- Within autotask, before the create-pr phase
- When asked "does it work?" or "is it fixed?"
- Anytime you're tempted to say "I fixed it" without running something

If verification fails, continue debugging rather than reporting success.
</integration>

<verification-criteria>
Verification means observing the specific fixed behavior working correctly:

- Tests pass that directly exercise the changed code paths
- Live request returns the expected response through the modified code
- UI renders correctly when displaying the fixed functionality
- Build completes without errors affecting the changed files
- The specific broken behavior is now demonstrably working

The standard: observe the fix working through code paths that exercise it. A passing
test suite verifies the fix when those tests cover the changed behavior.
</verification-criteria>

<when-verification-blocked>
If verification cannot be run immediately:

- Document what verification is needed in your response
- Explain to the user what they should verify manually
- Be explicit that the fix is unverified pending these checks

Never claim the fix works without some form of verification. Stating "this should work
but I can't verify because X" preserves epistemic honesty.
</when-verification-blocked>

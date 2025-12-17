# Optimal Development Workflow

## Your Development Profile

- **Work Types**: All (bugs, features, refactoring, research/POCs)
- **Project Complexity**: Medium (multi-service, 10-100k LOC)
- **Review Style**: Fully autonomous (trust AI completely)
- **Risk Tolerance**: Aggressive (move fast, fix issues if they arise)

**Optimization Goal**: Maximum speed and autonomy with intelligent fail-fast mechanisms.

## Current Workflow Problems

1. **Sequential when could be faster**: Not using worktrees for isolation
2. **Late validation**: Finding issues in CI instead of locally
3. **Manual agent selection**: Not systematically using the right agent for the job
4. **Waiting for bot feedback**: Then manually addressing it

## The Solution: `/autotask`

One command that handles everything from task to PR-ready state.

```bash
/autotask "add user authentication with OAuth2"
```

**What you do**: Describe the task, review the PR when ready, merge when satisfied
**What AI does**: Everything else

## How `/autotask` Works

### Phase 1: Task Preparation

Analyzes task complexity:

- **Complex** (multi-step, unclear, major feature) → Run `/create-prompt` first
  - Ask clarifying questions with AskUserQuestion
  - Create structured prompt
  - Save to `.created-prompts/`
  - Get your confirmation before proceeding
- **Straightforward** → Skip directly to execution

### Phase 2: Worktree Setup

Create isolated development environment:

```bash
mkdir -p .gitworktrees
git worktree add -b feature/task-name .gitworktrees/task-name main
cd .gitworktrees/task-name
/setup-environment  # Install deps, copy env files, setup git hooks
```

### Phase 3: Autonomous Execution

LLM intelligently chooses which agents to use based on the task:

- **debugger** - Root cause analysis for bugs
- **autonomous-developer** - Implementation work
- **ux-designer** - User-facing content review
- **code-reviewer** - Architecture and security review
- **prompt-engineer** - Prompt optimization

**No forced patterns. No classification rules.** Just intelligent agent selection.

Automatically follows all `rules/*.mdc` standards.

### Phase 4: Adaptive Validation & Review

**The key insight**: Review intensity should match task complexity and risk.

**Step 1: Git hooks handle the basics**

- Your existing husky/pre-commit hooks run automatically
- Linting, formatting, type checking, unit tests
- Auto-fix what can be fixed

**Step 2: Conditional agent review based on complexity**

**Minimal Review** (trivial changes):

- Git hooks pass = good enough
- No additional review needed

**Targeted Review** (medium complexity):

- Git hooks + one relevant agent
- UI changes → ux-designer reviews UX
- Bug fixes → debugger spot-checks for edge cases
- Refactoring → code-reviewer validates architecture

**Comprehensive Review** (high risk/complexity):

- Git hooks + multiple agents
- Security changes → Full code-reviewer security review
- Major features → code-reviewer + ux-designer + debugger
- Breaking changes → Extra scrutiny

**Smart Principles**:

- Don't review what hooks already validated
- Focus on what automation can't catch (design decisions, security logic, UX)
- Skip review entirely for trivial changes that pass hooks

### Phase 5: Create PR

```bash
# Commit with proper message format
git add .
git commit -m "feat: Add OAuth2 authentication

- Implement OAuth2 flow with token refresh
- Add email/password fallback
- Session management middleware
- Test coverage: 97%

🤖 Generated with Claude Code
"

# Push to origin
git push -u origin feature/task-name

# Create PR
gh pr create \
  --title "Add OAuth2 authentication" \
  --body "Summary of changes..."
```

### Phase 6: Bot Feedback Loop

**This is the key innovation** - don't wait for you, autonomously handle bot feedback:

```bash
echo "⏳ Waiting for bot reviews..."
PR_NUMBER=$(gh pr view --json number -q .number)

# Initial wait for bots to run
sleep 120

# Loop until all bot feedback addressed
while true; do
  echo "📝 Checking for bot comments..."

  # Get unresolved bot comments
  COMMENTS=$(gh api \
    repos/{owner}/{repo}/pulls/$PR_NUMBER/comments \
    --jq '.[] | select(.user.type == "Bot") | select(.resolved != true)')

  if [ -z "$COMMENTS" ]; then
    echo "✅ All bot feedback addressed!"
    break
  fi

  echo "🤖 Analyzing bot feedback..."

  # Categorize each comment intelligently:
  # - CRITICAL: Security, bugs, breaking changes → Fix immediately
  # - VALID: Legitimate improvements → Apply fix
  # - CONTEXT-MISSING: Bot lacks project context → Mark WONTFIX with explanation
  # - FALSE-POSITIVE: Bot is wrong → Mark WONTFIX with reasoning

  # If fixes made, push and re-wait
  if git diff --quiet; then
    break  # No changes needed
  else
    git add .
    git commit -m "Address bot feedback"
    git push

    echo "⏳ Waiting for bots to re-review..."
    sleep 90
  fi
done
```

### Phase 7: Done - Handoff to You

```
✅ Development complete
✅ All validations passed
✅ PR created and bot feedback addressed
✅ Ready for your review

PR: https://github.com/user/repo/pull/123

When you're ready:
- Review the changes
- Merge when satisfied
- Worktree cleanup happens after merge
```

**You control the merge. Always.**

## Complete Example

```bash
$ /autotask "add user authentication with OAuth2"

📋 Analyzing task complexity...
🤔 This looks complex. Creating structured prompt first.

[Uses /create-prompt]
✓ Saved to .created-prompts/Add-User-Authentication-OAuth2.md

Execute this prompt? (y/n) y

🚀 Creating worktree...
✓ .gitworktrees/add-user-auth created
✓ Environment setup complete

🤖 Executing task...
- debugger analyzing existing auth patterns
- autonomous-developer implementing OAuth2 flow
- autonomous-developer writing comprehensive tests
- ux-designer reviewing user-facing error messages

🔍 Adaptive validation & review
  - Git hooks: ✓ (lint, format, type-check, tests)
  - Security review: ✓ code-reviewer found + fixed rate limiting issue
  - UX review: ✓ ux-designer improved error messages
  - Test coverage: 97%

🔄 Creating PR...
✓ Committed with proper message format
✓ Pushed to feature/add-user-auth
✓ PR created: #456

⏳ Waiting for bot reviews...

📝 Bot comments received (2m 31s later):
  🤖 CodeRabbit: 3 suggestions
    ✓ CRITICAL: Missing rate limiting on OAuth endpoint → Fixed
    ✓ VALID: Extract token expiry constant → Applied
    ✓ FALSE-POSITIVE: "Don't store tokens in memory"
       → WONTFIX: Server-side session, explained in comment

📤 Pushing fixes...
⏳ Waiting for bot re-review...

✅ All bot feedback addressed
🎉 PR ready for your review!

View: https://github.com/you/repo/pull/456

Your involvement: Wrote task description, will review and merge PR
```

## Agent Selection Strategy

Let the LLM intelligently choose. Common patterns:

**Bug Fixes**:

- debugger analyzes root cause (not just symptoms)
- autonomous-developer implements fix
- autonomous-developer adds regression test

**New Features**:

- autonomous-developer reads all cursor rules
- autonomous-developer implements feature
- ux-designer reviews if user-facing
- autonomous-developer writes comprehensive tests

**Refactoring**:

- autonomous-developer creates safety net (tests for current behavior)
- autonomous-developer refactors incrementally
- code-reviewer reviews for architectural issues
- debugger checks for subtle bugs

**Research/POCs**:

- Explore agent investigates options
- autonomous-developer implements proof-of-concept
- Document findings and recommendations

## Key Principles

1. **Single worktree per task**: Clean isolation for parallel development
2. **Adaptive review**: Review intensity matches task complexity and risk
3. **Intelligent agent selection**: Right agent for the job, no forced patterns
4. **Git hooks do validation**: Leverage your existing infrastructure
5. **Intelligent bot handling**: Distinguish valuable feedback from noise
6. **PR-centric workflow**: Everything leads to a mergeable pull request
7. **You control merge**: AI gets it ready, you decide when to ship

## What NOT To Do

- **Don't** create multiple parallel worktrees for one task - complexity disaster
- **Don't** use forced classification logic - let LLM decide intelligently
- **Don't** skip git hooks - they're already configured, use them
- **Don't** do heavy review for trivial changes - scale effort with risk

## Metrics That Matter

**Speed**:

- Bot feedback cycles: Target 0-1 (minimize back-and-forth)

**Quality**:

- First-time merge rate: Target 95%
- Bot feedback items: Target < 2 per PR
- Post-merge bugs: Track and minimize

**Autonomy**:

- Human intervention: Only task description + merge decision
- Agent utilization: Right agent for job, every time

## Next Steps

1. ✅ **Implement `/autotask` command** (`.claude/commands/autotask.md`)
2. ✅ **Update `/setup-environment`** to use existing git hooks
3. **Test with real tasks** (start simple, build confidence)
4. **Iterate and improve** (measure metrics, optimize)

## The Philosophy

**Simple beats complex**: One worktree, clear flow, no magic

**Fast feedback**: Validate locally, catch early, fix immediately

**Intelligent automation**: Right agent, right time, right decision

**Human control**: AI prepares, human decides

This is autonomous development done right - fast, reliable, and always under your
control.

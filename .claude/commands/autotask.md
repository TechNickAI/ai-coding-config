# /autotask - Autonomous Task Execution

Execute a complete development task autonomously from description to PR-ready state.

## Usage

```
/autotask "task description"
```

## What This Command Does

Takes your task description and autonomously:

1. Analyzes complexity and creates structured prompt if needed
2. Sets up isolated git worktree environment
3. Implements the solution using intelligent agent orchestration
4. Adaptive validation & review based on complexity
5. Creates PR with proper commit messages
6. Handles bot feedback autonomously
7. Delivers PR ready for your review

You only need to provide the task description and review the final PR.

## Execution Flow

<task-preparation>
First, I'll analyze your task complexity to determine the best approach.

<task-analysis>
Analyzing task: "{{TASK_DESCRIPTION}}"

Checking if this task is:

- Complex (multi-step, unclear requirements, major feature)
- Straightforward (clear requirements, single responsibility)

<use-agent-if-complex>
If the task is complex or unclear, I'll use the Task tool to run the create-prompt agent to:
- Ask clarifying questions with AskUserQuestion tool
- Create a structured prompt with clear requirements
- Save to .created-prompts/ for review
- Get your confirmation before proceeding
</use-agent-if-complex>
</task-analysis>
</task-preparation>

<worktree-setup>
Creating isolated development environment for clean, parallel work:

```bash
# Ensure worktrees directory exists
mkdir -p .gitworktrees

# Generate branch name from task
TASK_NAME="{{TASK_DESCRIPTION}}"
BRANCH_NAME=$(echo "$TASK_NAME" | \
  tr '[:upper:]' '[:lower:]' | \
  sed 's/[^a-z0-9]/-/g' | \
  sed 's/--*/-/g' | \
  sed 's/^-//' | \
  sed 's/-$//' | \
  cut -c1-60)
BRANCH_NAME="feature/${BRANCH_NAME}"

# Check if worktree already exists
if [ -d ".gitworktrees/$BRANCH_NAME" ]; then
  echo "⚠️ Worktree already exists for this task"
  echo "Options:"
  echo "1. Continue in existing worktree"
  echo "2. Remove and recreate"
  echo "3. Choose different task name"
  # Handle user choice
fi

# Create fresh worktree from main
echo "🌳 Creating worktree: $BRANCH_NAME"
git worktree add -b "$BRANCH_NAME" ".gitworktrees/$BRANCH_NAME" main

# Move to worktree
cd ".gitworktrees/$BRANCH_NAME"

# Set up environment
echo "🔧 Setting up development environment..."
```

<setup-environment>
Now running /setup-environment to configure the worktree:
- Install dependencies
- Copy environment files
- Generate project-specific validation script
- Set up git hooks
- Verify tool availability
</setup-environment>
</worktree-setup>

<autonomous-execution>
Now I'll execute the task using specialized agents selected based on the task requirements.

<intelligent-agent-orchestration>
**This is where the real value of /autotask shines** - intelligent agent selection and orchestration.

Based on task analysis, I'll deploy the right combination of agents:

**Bug Fixes**:

```
1. Dixon (dev-agents:debugger) → Root cause analysis
   - Reproduces the issue
   - Identifies the actual problem (not just symptoms)
   - Proposes fix strategy

2. Ada (dev-agents:autonomous-developer) → Implementation
   - Implements the fix
   - Adds regression tests
   - Updates documentation

3. Rivera (code-review:code-reviewer) → Validation
   - Reviews the fix for completeness
   - Checks for side effects
```

**New Features**:

```
1. Ada (dev-agents:autonomous-developer) → Primary implementation
   - Reads all .cursor/rules/*.mdc
   - Implements feature following project patterns
   - Writes comprehensive tests

2. Phil (dev-agents:ux-designer) → UX review (if user-facing)
   - Reviews all user-facing text
   - Validates accessibility
   - Ensures consistent UX patterns

3. Rivera (code-review:code-reviewer) → Architecture review
   - Validates design patterns
   - Checks security implications
```

**Refactoring**:

```
1. Ada → Safety net
   - Creates tests for current behavior
   - Ensures we can refactor safely

2. Ada → Incremental refactoring
   - Step-by-step transformation
   - Maintains green tests throughout

3. Dixon → Subtle bug detection
   - Checks for introduced edge cases
   - Validates performance implications

4. Rivera → Final review
   - Architecture improvements
   - Code quality validation
```

**Research/POCs**:

```
1. Explore (general-purpose) → Investigation
   - Researches approaches
   - Evaluates trade-offs
   - Documents findings

2. Ada → Implementation
   - Creates proof-of-concept
   - Implements minimal viable solution

3. Documentation
   - Captures decisions and reasoning
   - Creates implementation guide
```

</intelligent-agent-orchestration>

<execution>
Using the Task tool to launch agents intelligently:

```typescript
// Example agent deployment for a bug fix
await Task({
  subagent_type: "dev-agents:debugger",
  description: "Analyze root cause",
  prompt: "Find and analyze the root cause of: {{BUG_DESCRIPTION}}"
});

await Task({
  subagent_type: "dev-agents:autonomous-developer",
  description: "Fix the bug",
  prompt: "Fix the issue identified by debugger, add tests"
});

// Agents can run in parallel when appropriate
await Promise.all([
  Task({subagent_type: "code-review:code-reviewer", ...}),
  Task({subagent_type: "dev-agents:ux-designer", ...})
]);
```

**The key differentiator**: Agents aren't just running commands - they're reasoning
about the code, understanding context, and making intelligent decisions throughout the
implementation. </execution> </autonomous-execution>

<validation-and-review>
Adaptive validation and review based on task complexity:

<adaptive-review-strategy>
```typescript
// Determine review intensity based on what changed
const reviewLevel = analyzeChanges({
  riskFactors: [
    "authentication/authorization changes",
    "payment/financial logic",
    "database schema changes",
    "public API changes",
    "security-sensitive areas"
  ],
  complexity: estimatedLinesChanged > 200 ? "high" : "medium",
  userFacing: hasUIChanges || hasUserMessages
});
```

**Minimal Review** (simple fixes, small changes):

- Git hooks pass = good enough
- No additional review agents needed
- Trust the automation

**Targeted Review** (medium complexity):

- Git hooks + one relevant agent
- UI changes → Phil (ux-designer)
- Bug fixes → Dixon (debugger) spot-check
- Refactoring → Rivera (code-reviewer) for architecture

**Comprehensive Review** (high risk/complexity):

- Git hooks + multiple agents
- Security changes → Full Rivera review
- Major features → Rivera + Phil + Dixon
- Breaking changes → Extra scrutiny

</adaptive-review-strategy>

<validation-and-review>
```bash
echo "🔍 Running validation and review..."

# Step 1: Git hooks handle the basics

echo "🪝 Running pre-commit hooks..."
git add .

if [ -d ".husky" ]; then
  npx husky run pre-commit || {
    echo "❌ Pre-commit hooks failed, attempting fixes..."
    npx eslint --fix . 2>/dev/null || true
    npx prettier --write . 2>/dev/null || true
    npx husky run pre-commit
  }
elif [ -f ".pre-commit-config.yaml" ]; then
  pre-commit run --all-files || {
    echo "❌ Pre-commit hooks failed, attempting fixes..."
    pre-commit run --all-files
  }
fi

# Step 2: Conditional agent review based on complexity

echo "📊 Analyzing changes to determine review needs..."
```

Based on the analysis, I'll deploy appropriate review agents:

```typescript
// Examples of adaptive review
if (hasSecurityChanges) {
  await Task({
    subagent_type: "code-review:code-reviewer",
    description: "Security review",
    prompt: "Review security implications of auth changes"
  });
}

if (hasUIChanges && !isTrivial) {
  await Task({
    subagent_type: "dev-agents:ux-designer",
    description: "UX review",
    prompt: "Review user-facing text and accessibility"
  });
}

// Skip review entirely for trivial changes that pass hooks
if (isTrivial && hooksPass) {
  console.log("✅ Trivial change with passing hooks - skipping review");
}
````

**Smart Review Principles:**

- Don't review what hooks already validated
- Focus on what automation can't catch (design, security logic, UX)
- Scale review effort with risk and complexity
- Skip review for trivial changes that pass all hooks </validation-and-review>

<create-pr>
Creating pull request with proper commit messages:

```bash
# Stage all changes
git add .

# Create comprehensive commit message
COMMIT_MESSAGE=$(cat <<'EOF'
{{COMMIT_TYPE}}: {{COMMIT_DESCRIPTION}}

{{DETAILED_CHANGES}}

Test coverage: {{COVERAGE}}%
Performance impact: {{PERF_IMPACT}}

🤖 Generated with Claude Code

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)

# Commit changes
git commit -m "$COMMIT_MESSAGE"

# Push to remote
git push -u origin "$BRANCH_NAME"

# Create PR using gh CLI
gh pr create \
  --title "{{PR_TITLE}}" \
  --body "$(cat <<'EOF'
## Summary
{{PR_SUMMARY}}

## Changes
{{DETAILED_CHANGES_LIST}}

## Testing
{{TESTING_APPROACH}}

## Checklist
- [x] Tests pass locally
- [x] Lint/format checks pass
- [x] Build succeeds
- [x] Security audit clean
- [x] Documentation updated
- [x] Follows all project standards

## Screenshots
{{SCREENSHOTS_IF_UI}}

## Performance
{{PERFORMANCE_METRICS}}

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"

# Get PR number for tracking
PR_NUMBER=$(gh pr view --json number -q .number)
echo "📝 PR created: #$PR_NUMBER"
```

</create-pr>

<bot-feedback-loop>
Autonomously handling bot feedback without waiting for user intervention:

```bash
echo "⏳ Waiting for bot reviews to complete..."
PR_NUMBER=$(gh pr view --json number -q .number)

# Get repository info
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)

# Initial wait for bots to run
echo "⏰ Waiting 3 minutes for bots to complete initial analysis..."
sleep 180

MAX_ATTEMPTS=5
ATTEMPT=0

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
  ATTEMPT=$((ATTEMPT + 1))
  echo "🔄 Checking bot feedback (attempt $ATTEMPT/$MAX_ATTEMPTS)..."

  # Get all bot comments
  BOT_COMMENTS=$(gh api \
    "repos/$REPO/pulls/$PR_NUMBER/comments" \
    --jq '.[] | select(.user.type == "Bot" or .user.login | endswith("[bot]")) | {id: .id, body: .body, path: .path, line: .line}')

  # Also check review comments
  BOT_REVIEWS=$(gh api \
    "repos/$REPO/pulls/$PR_NUMBER/reviews" \
    --jq '.[] | select(.user.type == "Bot" or .user.login | endswith("[bot]")) | {state: .state, body: .body}')

  # Check CI status
  CI_STATUS=$(gh pr checks $PR_NUMBER --json name,status,conclusion)

  if [ -z "$BOT_COMMENTS" ] && echo "$CI_STATUS" | grep -q '"conclusion":"success"'; then
    echo "✅ All bot checks passed!"
    break
  fi

  echo "🤖 Analyzing bot feedback..."

  # Process each bot comment intelligently
  # Categories:
  # - CRITICAL: Security issues, bugs, breaking changes → Fix immediately
  # - VALID: Legitimate improvements → Apply fix
  # - CONTEXT-MISSING: Bot lacks project understanding → Add comment explaining
  # - FALSE-POSITIVE: Bot is incorrect → Add comment with reasoning

  # Make necessary fixes based on feedback
  CHANGES_MADE=false

  # [Intelligent processing of feedback and fixes here]
  # Using appropriate agents to address specific feedback

  if [ "$CHANGES_MADE" = true ]; then
    echo "📝 Committing fixes for bot feedback..."
    git add .
    git commit -m "Address automated review feedback

- Fixed: {{SPECIFIC_FIXES}}
- Explained: {{WONTFIX_ITEMS}}

🤖 Generated with Claude Code"

    git push

    echo "⏳ Waiting for bots to re-review (90 seconds)..."
    sleep 90
  else
    echo "ℹ️ No changes needed or all feedback addressed"
    break
  fi
done

if [ $ATTEMPT -eq $MAX_ATTEMPTS ]; then
  echo "⚠️ Max attempts reached. Manual review may be needed."
fi
```

</bot-feedback-loop>

<completion>
Task execution complete! Here's your summary:

```
✅ Development complete
✅ All validations passed
✅ PR created and bot feedback addressed
✅ Ready for your review

📍 PR: {{PR_URL}}
🌳 Worktree: .gitworktrees/{{BRANCH_NAME}}
⏱️ Total time: {{TOTAL_TIME}}
🤖 Agents used: {{AGENTS_USED}}
📊 Test coverage: {{COVERAGE}}%
🔄 Bot feedback cycles: {{FEEDBACK_CYCLES}}

When you're ready:
1. Review the PR at {{PR_URL}}
2. Merge when satisfied
3. Run: git worktree remove .gitworktrees/{{BRANCH_NAME}}

The PR is fully ready - all checks passing, bot feedback addressed.
You have full control over the merge decision.
```

</completion>

<error-handling>
If any phase fails critically:

```bash
# Capture error context
ERROR_PHASE="{{PHASE_NAME}}"
ERROR_DETAILS="{{ERROR_MESSAGE}}"

echo "❌ Error in $ERROR_PHASE"
echo "Details: $ERROR_DETAILS"
echo ""
echo "Options:"
echo "1. Fix and retry this phase"
echo "2. Skip to next phase (if safe)"
echo "3. Abort and clean up"
echo "4. Switch to manual mode"

# Based on error type, may automatically attempt recovery
case "$ERROR_PHASE" in
  "validation")
    echo "Attempting automatic fix..."
    # Run appropriate fixing agent
    ;;
  "bot-feedback")
    echo "Some bot feedback couldn't be addressed automatically"
    echo "Continuing with PR - you can address remaining items"
    ;;
  *)
    echo "Please choose how to proceed"
    ;;
esac
```

</error-handling>

## Key Principles

- **Single worktree per task**: Clean isolation for parallel development
- **Adaptive review**: Review intensity matches task complexity and risk
- **Intelligent agent use**: Right tool for the job, no forced patterns
- **Git hooks do validation**: Leverage your existing infrastructure
- **Autonomous bot handling**: Don't wait for human intervention
- **PR-centric workflow**: Everything leads to a mergeable pull request

## Requirements

- Git worktrees support
- GitHub CLI (`gh`) installed and authenticated
- Node.js/npm or yarn
- Project must have main/master branch
- `.cursor/rules/*.mdc` standards in place

## Configuration

The command adapts to your project structure:

- Detects test runners (jest, mocha, vitest, etc.)
- Finds linting configs (eslint, prettier, etc.)
- Uses available build scripts
- Respects project-specific conventions

## Notes

- This command creates real commits and PRs
- All work happens in isolated worktrees
- Bot feedback handling is autonomous but intelligent
- You always have the final say on merging
- Worktrees are preserved until you explicitly remove them

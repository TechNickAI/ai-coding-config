---
description: Execute complete development task autonomously from description to PR-ready state
---

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
**Goal**: Create an isolated development environment in `.gitworktrees/` with a sanitized branch name derived from the task description.

**Requirements**:
- Sanitize task description to prevent shell injection
- Generate feature branch name (lowercase, alphanumeric, max 60 chars)
- Handle existing worktree conflicts
- Run /setup-environment to install dependencies, copy configs, and set up git hooks

**Success criteria**: Clean worktree ready for development work.
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

**Execution**:

1. Stage all changes and run existing git hooks (husky/pre-commit)
2. If hooks fail, attempt auto-fix (eslint --fix, prettier --write), then retry
3. Analyze what changed to determine review intensity
4. Launch appropriate review agents using Task tool based on analysis
5. Address any feedback from review agents

**Key insight**: The review strategy above guides agent selection, but you determine what's needed based on actual changes.
</validation-and-review>

<create-pr>
**Goal**: Create a well-documented pull request ready for review.

**Requirements**:
- Commit with proper format (emoji, imperative verb, concise description)
- Include "🤖 Generated with Claude Code" and co-author line
- Push to feature branch
- Create PR with summary, changes, testing approach, and checklist
- Follow project's commit message conventions (read git-commit-message.mdc if it exists)

**Success criteria**: PR created, all information clear, ready for bot/human review.
</create-pr>

<bot-feedback-loop>
**Goal**: Autonomously address bot feedback without user intervention.

**Process**:
1. Wait 3 minutes for bots to complete initial analysis
2. Check for bot comments using GitHub API
3. Review each piece of feedback and decide:
   - Fix what's valuable (security issues, real bugs, good suggestions)
   - Reject what's not (use WONTFIX with brief explanation for context-missing or incorrect feedback)
   - **You are the ultimate decider** - trust your judgment on what matters
4. Make fixes, commit, push
5. Wait for bots to re-review (90s)
6. Repeat up to 5 times if needed

**Success criteria**: All critical issues addressed, PR ready for human review.
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

# Autotask v2.0 Overhaul Plan

## Executive Summary

Transform `/autotask` from a linear PR-creation workflow into an **orchestrator-first,
completion-verified, complexity-scaled** autonomous development system.

**Core Problems Solved:**

1. 95% of runs stop after PR creation (doesn't complete bot feedback loop)
2. Context window fills with exploratory work (should delegate)
3. No complexity scaling (same process for trivial and complex tasks)
4. No plan-phase review for complex work
5. TODOs lost on compaction (need file-based state)

---

## Complexity Levels: quick | balanced | deep

### `quick`

**When:** Single-file changes, clear requirements, no design decisions **Process:**

- Skip heavy planning
- Implement directly
- Trust git hooks for validation
- Single self-review pass
- Create PR, brief bot wait, done

**Triggers:** "quick fix", "simple change", trivial scope detected

### `balanced` (default)

**When:** Standard multi-file implementation, some design decisions **Process:**

- Light planning phase
- Delegate exploration to sub-agents
- Implement with targeted testing
- `/multi-review` with 2-3 relevant agents
- Create PR → `/address-pr-comments` → completion

**Triggers:** Default for most tasks

### `deep`

**When:** Architectural changes, new patterns, high-risk, multiple valid approaches
**Process:**

- **Plan-phase multi-review** (review the approach before implementation)
- F-thread brainstorming for hard decisions (3-5 agents, different perspectives)
- Full implementation with comprehensive testing
- `/verify-fix` to confirm behavior
- `/multi-review` with 5+ agents
- Create PR → wait for all bots → `/address-pr-comments` → iterate until clean

**Triggers:** "thorough", "deep", "ultrathink", architectural scope detected

---

## Phase 1: Environment & Planning

### 1.1 Environment Detection (unchanged)

Current logic is good:

- Clean tree → work in place
- Dirty tree + multi-repo → ask user
- Dirty tree, no multi-repo → suggest worktree
- Already in worktree → work in place

### 1.2 State File Initialization (NEW)

Create `autotask-state.md` in project root at start:

```markdown
# Autotask Session: [task-name]

Started: [timestamp] Complexity: [quick|balanced|deep]

## Phase: planning

## Requirements:

- [extracted from task description]

## Todos:

- [ ] Planning
- [ ] Implementation
- [ ] Validation
- [ ] Review
- [ ] PR Creation
- [ ] Bot Feedback
- [ ] Completion

## Decisions Made:

[populated as work progresses]

## Blockers:

[populated if encountered]
```

This survives compaction. On resume, read this file to restore context.

Placing it in root means it shows as uncommitted, which naturally prompts the LLM to
notice and read it.

### 1.3 Complexity Detection

Auto-detect OR accept user signal:

- Parse task description for scope indicators
- Count files likely affected
- Check for architectural keywords
- User override: "quick", "deep", etc.

### 1.4 Planning Phase (complexity-scaled)

**quick:** Skip to implementation

**balanced:**

- Load relevant rules with `/load-rules`
- Brief exploration via sub-agent if needed
- Create implementation outline

**deep:**

- Full exploration via sub-agents
- Create detailed plan document
- **Run `/multi-review` ON THE PLAN** with architecture-focused agents
- Incorporate feedback before proceeding
- Document design decisions with rationale

---

## Phase 2: Implementation

### 2.1 Context Preservation (CRITICAL)

```
MANDATORY DELEGATION:
- Codebase exploration → Explore agent
- Multi-file analysis → Explore agent
- Documentation research → Research agent
- Pattern searching → Explore agent

TOP-LEVEL ORCHESTRATOR DOES:
- Decision-making
- User communication
- Synthesizing agent results
- State management
- Phase transitions
```

**Why:** Sub-agents work with fresh context optimized for their task. Results return
concise. Main context stays clean for orchestration. Prevents compaction mid-task.

### 2.2 Implementation Execution

- Use appropriate agents (autonomous-developer, debugger, etc.)
- Update state file as phases complete
- Capture design decisions in state file
- Ask user only for deal-breakers (security, data loss, unclear requirements)

### 2.3 Checkpoint Updates

After each significant step, update `autotask-state.md`:

- Mark completed todos
- Record decisions made
- Note any blockers or deviations

---

## Phase 3: Validation (complexity-scaled)

### `quick`

- Trust git hooks
- If hooks pass, proceed

### `balanced`

- Run targeted tests for changed code
- Brief self-review
- Fix obvious issues

### `deep`

- `/verify-fix` to confirm behavior works from user perspective
- Comprehensive test suite
- Security scan if applicable
- Performance check if applicable

---

## Phase 4: Review (complexity-scaled)

### `quick`

- Single self-review pass
- Fix any obvious issues
- Proceed to PR

### `balanced`

- `/multi-review` with 2-3 agents selected by code domain:
  - Changed API? → security-reviewer
  - Changed UI? → ux-designer, design-reviewer
  - Changed logic? → logic-reviewer
  - Changed tests? → test-analyzer
- Fix issues found
- Proceed to PR

### `deep`

- `/multi-review` with 5+ agents covering:
  - Architecture (architecture-auditor)
  - Security (security-reviewer)
  - Performance (performance-reviewer)
  - Error handling (error-handling-reviewer)
  - Logic (logic-reviewer)
  - Domain-specific reviewers
- Synthesize conflicting recommendations
- Fix all high-priority issues
- Document any deferred items with rationale

---

## Phase 5: PR Creation

### 5.1 PR Description Format

```markdown
## Summary

- What was implemented and why
- How it addresses requirements

## Design Decisions (if any)

- Decision: [what]
- Rationale: [why]
- Alternatives considered: [what else]

## Validation Performed

- [tests run]
- [verification steps]

## Complexity Level

[quick|balanced|deep] - [why this level]
```

### 5.2 Commit Message Standards

Follow existing `git-commit-message.mdc` conventions.

---

## Phase 6: Bot Feedback Loop (MANDATORY)

**This is where 95% of runs currently fail. Make it mandatory.**

### 6.1 Wait for Bots

- After PR creation, wait for initial bot analysis
- Quick: 1-2 minutes for fast bots
- Balanced: Up to 5 minutes
- Deep: Wait for all configured bots

### 6.2 Execute Address-PR-Comments

```
/address-pr-comments [PR-number]
```

This is NOT optional. Autotask is NOT complete until this runs.

### 6.3 Iterate Until Clean

- Fix valuable feedback
- Decline with rationale where bot lacks context
- Re-run if new issues appear
- Continue until critical issues resolved

### 6.4 Update State File

Mark bot feedback phase complete in `autotask-state.md`

---

## Phase 7: Completion Verification (NEW)

### 7.1 Completion Checklist

Autotask is NOT complete until ALL are true:

- [ ] PR created with proper description
- [ ] Bot feedback bots have run
- [ ] `/address-pr-comments` executed
- [ ] All "Fix" items resolved or documented
- [ ] State file shows all phases complete

### 7.2 Final Report Format

```
## Autotask Complete

**PR:** #[number] - [title]
**Branch:** [branch-name]
**Worktree:** [path if applicable]

**Complexity:** [quick|balanced|deep]

**What was accomplished:**
- [summary]

**Design decisions made:**
- [list with rationale]

**Bot feedback addressed:**
- Fixed: [count]
- Declined: [count with reasons]

**State file:** autotask-state.md
```

---

## New/Modified Components

### 1. Autotask v2.0 (this plan)

Major rewrite incorporating all above.

### 2. Multi-Review Enhancement

Add complexity awareness:

- Accept `--depth quick|balanced|deep` or infer from context
- Auto-select reviewer count based on depth
- Better synthesis of conflicting recommendations

### 3. Address-PR-Comments Enhancement

- Return structured result (fixed count, declined count, remaining)
- Support iteration detection (don't re-process same comments)

### 4. New: Plan-Review Pattern (for deep)

When complexity=deep, run multi-review on the PLAN before implementation:

- architecture-auditor reviews approach
- Relevant domain experts review design
- Incorporate feedback before writing code

### 5. New: Brainstorm-Synthesis Skill (future consideration)

F-thread pattern for hard decisions:

- Launch N agents with different perspectives
- Each returns: approach + trade-offs + complexity
- Synthesize best unified solution
- Use for architectural decisions in deep mode

---

## Files to Modify

1. **`plugins/core/commands/autotask.md`** - Major rewrite
2. **`plugins/core/commands/multi-review.md`** - Add depth scaling
3. **`plugins/core/commands/address-pr-comments.md`** - Add structured return

## Files to Create

1. **`autotask-state.md`** - Template (created per-session in project root)
2. **`plugins/core/skills/brainstorm-synthesis/`** - Future (optional)

---

## Migration Path

### Phase A: Core Autotask Rewrite

- Implement complexity levels
- Add state file management
- Add mandatory completion verification
- Add context preservation rules

### Phase B: Multi-Review Integration

- Depth-aware reviewer selection
- Plan-phase review for deep mode

### Phase C: Address-PR-Comments Enforcement

- Make it mandatory in autotask flow
- Add iteration support

### Phase D: Optional Enhancements

- Brainstorm-synthesis skill
- Additional automation

---

## Success Criteria

1. **Completion rate**: 95%+ of autotask runs complete through bot feedback
2. **Context preservation**: No compaction mid-task due to exploration bloat
3. **Appropriate effort**: Quick tasks complete fast, deep tasks get thorough review
4. **Plan quality**: Deep mode catches architectural issues before implementation
5. **State recovery**: Can resume after compaction via state file

---

## Questions for Nick

1. ~~Should state file go in `.llm/` or somewhere else?~~ **Resolved: project root**
2. Any specific bot wait times to configure?
3. Want brainstorm-synthesis as part of this or future work?
4. Any complexity level keywords beyond quick/balanced/deep?

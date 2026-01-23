# BMAD-METHOD + ai-coding-config: Complete Development Lifecycle

A two-phase development system combining BMAD's structured planning methodology with ai-coding-config's autonomous execution engine—from initial idea to merged PR.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           Your Project Repository                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  .bmad/                              .ai-coding-config/                     │
│  └── (forked submodule)              └── (forked submodule)                 │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                     PHASE 1: PLANNING (BMAD)                        │   │
│  │                                                                     │   │
│  │  8 Specialized Agents │ 50+ Workflows │ 60+ Ideation Techniques    │   │
│  │                                                                     │   │
│  │  Analysis → Planning → Solutioning → Handoff                       │   │
│  │                                                                     │   │
│  │  OUTPUT: docs/                                                      │   │
│  │  ├── product-brief.md      ├── architecture.md                     │   │
│  │  ├── prd.md                ├── epic-*.md                           │   │
│  │  ├── ux-design.md          ├── story-*.md                          │   │
│  │  └── tech-decisions.md     └── PLANNING_COMPLETE.md                │   │
│  └─────────────────────────────┬───────────────────────────────────────┘   │
│                                │                                            │
│                                │ Document Handoff                           │
│                                ▼                                            │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                   PHASE 2: EXECUTION (ai-coding-config)             │   │
│  │                                                                     │   │
│  │  21 Commands │ 24 Review Agents │ Git Worktrees │ PR Automation    │   │
│  │                                                                     │   │
│  │  Setup → Implement → Review → PR → Iterate → Merge → Cleanup       │   │
│  │                                                                     │   │
│  │  OUTPUT: src/                                                       │   │
│  │  ├── components/           ├── Pull Requests                       │   │
│  │  ├── services/             ├── Automated Reviews                   │   │
│  │  └── tests/                └── Merged Code                         │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Core Principle

**Complete isolation. Document-based handoff. Full automation.**

- BMAD produces comprehensive planning documentation
- ai-coding-config consumes those docs and executes autonomously
- Each framework lives in its own submodule, pulls upstream updates independently
- The entire lifecycle—from idea to merged PR—can run with minimal human intervention

---

## Phase 1: Planning (BMAD)

BMAD provides structured methodology with specialized AI agents that guide you through rigorous planning before any code is written.

### The BMAD Agent Team

| Agent | Name | Specialty |
|-------|------|-----------|
| **Analyst** | Mary | Discovery, research, brainstorming, market analysis, brownfield documentation |
| **PM** | John | PRDs, requirements definition, epic/story creation, acceptance criteria |
| **Architect** | Winston | System design, ADRs, technical standards, implementation readiness |
| **UX Designer** | Sally | User journeys, wireframes, design systems, accessibility |
| **Scrum Master** | Bob | Sprint planning, story prep, retrospectives, course correction |
| **Developer** | Amelia | Implementation guidance, code review, pattern enforcement |
| **Test Architect** | Murat | Test strategy, automation framework, NFR assessment, quality gates |
| **Quick Flow Dev** | Barry | Rapid solo development for small changes (spec → dev → review) |

### Development Tracks

BMAD adapts planning depth to project complexity:

| Track | Scope | Planning Depth | When to Use |
|-------|-------|----------------|-------------|
| **Quick Flow** | Bug fixes, small features | Tech spec only | Single focused change |
| **BMad Method** | Products, platforms | Full PRD + Architecture | New features, refactors |
| **Enterprise** | Compliance-heavy systems | Extended analysis + research | Regulated industries |

### BMAD Workflow Phases

#### Phase 1: Analysis (Optional)

```
/bmad:brainstorm         → 60+ ideation techniques for solution exploration
/bmad:research           → Market, technical, competitive analysis
/bmad:product-brief      → Strategic vision with problem statement
```

**Capabilities:**
- 60+ brainstorming techniques (First Principles, 5 Whys, Socratic Questioning)
- Expert panels and stakeholder round tables
- Tree of Thoughts and Graph of Thoughts frameworks
- Red Team vs Blue Team analysis

#### Phase 2: Planning (Required)

```
/bmad:prd                → Product Requirements Document (scale-adaptive)
/bmad:ux-design          → User journeys, wireframes, design system
/bmad:nfr-assess         → Non-functional requirements evaluation
```

**Output Artifacts:**
- `prd.md` — Functional requirements, user stories, acceptance criteria
- `ux-design.md` — UX specification with journeys and wireframes
- `nfr-assessment.md` — Security, performance, reliability evaluation

#### Phase 3: Solutioning (Track-Dependent)

```
/bmad:architecture       → System design with Architecture Decision Records
/bmad:epics-and-stories  → Work breakdown structure
/bmad:test-design        → Risk assessment and coverage strategy
/bmad:implementation-readiness → Gate validation before coding
```

**Output Artifacts:**
- `architecture.md` — System design, component diagrams, data flows, ADRs
- `epic-N.md` — Epic breakdown with stories and acceptance criteria
- `story-{id}.md` — Individual stories with implementation details
- `test-design-*.md` — Test strategy per epic

#### Phase 4: Handoff

```
/bmad:finalize           → Validate completeness, generate handoff summary
```

**Output:**
- `PLANNING_COMPLETE.md` — Summary of all decisions, ready for execution

### BMAD Special Capabilities

#### Party Mode
Multi-agent collaboration where the BMad Master orchestrates 2-3 relevant agents per topic for real-time multi-perspective analysis.

```
/bmad:party-mode         → Launch collaborative session with multiple agents
```

#### Advanced Elicitation
50+ reasoning methods for LLM re-examination of generated content:
- First Principles Analysis
- Stakeholder Round Tables
- Expert Panels
- Red Team vs Blue Team
- Tree of Thoughts frameworks

#### Context Auto-Discovery
Automatically analyzes `package.json`, `requirements.txt`, `go.mod` to detect:
- Project stack and dependencies
- Existing patterns and conventions
- Test frameworks and code style

---

## Phase 2: Execution (ai-coding-config)

ai-coding-config provides autonomous execution with 21 commands, 24 review agents, and full PR lifecycle automation.

### The Execution Pipeline

```
┌──────────────────────────────────────────────────────────────────────────┐
│                        AUTONOMOUS EXECUTION FLOW                          │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐                  │
│  │   SETUP     │    │  IMPLEMENT  │    │   REVIEW    │                  │
│  │             │───→│             │───→│             │                  │
│  │ /setup-     │    │ /autotask   │    │ /multi-     │                  │
│  │ environment │    │             │    │ review      │                  │
│  └─────────────┘    └─────────────┘    └──────┬──────┘                  │
│        │                                       │                         │
│        ▼                                       ▼                         │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐                  │
│  │  WORKTREE   │    │   CREATE    │    │  ADDRESS    │                  │
│  │  CREATION   │    │     PR      │───→│  COMMENTS   │◄─────┐           │
│  │             │    │             │    │             │      │           │
│  │ Isolated    │    │ Auto-commit │    │ Fix issues  │      │           │
│  │ environment │    │ Auto-push   │    │ Decline bad │   Iterate       │
│  └─────────────┘    └─────────────┘    │ suggestions │      │           │
│                                        └──────┬──────┘      │           │
│                                               │             │           │
│                                               ▼             │           │
│                     ┌─────────────┐    ┌─────────────┐      │           │
│                     │   CLEANUP   │    │   BOT RE-   │      │           │
│                     │             │◄───│   ANALYSIS  │──────┘           │
│                     │ /wrap-up    │    │             │                  │
│                     │ /cleanup-   │    │ Cursor      │                  │
│                     │ worktree    │    │ Claude      │                  │
│                     └─────────────┘    │ Codex       │                  │
│                                        │ Greptile    │                  │
│                                        └─────────────┘                  │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
```

### Pre-Implementation: Environment Setup

#### Git Worktree Workflow

ai-coding-config uses git worktrees for isolated, parallel development:

```
/setup-environment       → Initialize worktree with full dev environment
```

**What it does:**
- Detects project type (Node.js, Python, Ruby, Go, Rust, Java, .NET)
- Identifies package manager (pnpm, yarn, bun, npm)
- Creates isolated worktree from main
- Installs dependencies with locked versions
- Copies environment files (.env, .env.local, secrets)
- Sets up git hooks (Husky, pre-commit)
- Runs code generation (Prisma, GraphQL, TypeScript)
- Validates environment is ready

**Why worktrees:**
- Work on multiple features simultaneously
- Keep main branch clean
- Isolated dependencies per feature
- Easy cleanup after merge

### Implementation: Autonomous Task Execution

```
/autotask "Implement user authentication per docs/architecture.md"
```

**Complexity Levels:**

| Level | Scope | Planning | Review | Bot Handling |
|-------|-------|----------|--------|--------------|
| **quick** | Single file, clear requirements | Skip | Self-review | 2 min wait |
| **balanced** | Multi-file, some design | /load-rules | 2-3 agents | 5 min wait |
| **deep** | Architectural, high-risk | Full exploration | 5+ agents | 15 min wait |

**The /autotask Pipeline:**

1. **Analyze** — Determine complexity, load relevant rules
2. **Explore** — Delegate codebase exploration to sub-agents
3. **Plan** — Create implementation outline (deep: review plan with agents first)
4. **Implement** — Execute with autonomous-developer agent
5. **Validate** — Run tests, verify behavior
6. **Review** — Multi-agent code review
7. **Create PR** — Auto-commit, push, create PR with full description
8. **Bot Feedback** — Wait for CI bots, then address feedback
9. **Iterate** — Fix valid issues, decline incorrect suggestions
10. **Complete** — PR ready for human review

### Review: Multi-Agent Code Analysis

```
/multi-review deep       → Run 5+ parallel review agents
```

**The 24 Review Agents:**

| Category | Agents | Focus |
|----------|--------|-------|
| **Correctness** | logic-reviewer, error-handling-reviewer, security-reviewer, robustness-reviewer | Bugs, exceptions, OWASP top 10, production readiness |
| **Performance** | performance-reviewer, simplifier | N+1 queries, complexity, optimization |
| **UX** | empathy-reviewer, ux-designer, design-reviewer, mobile-ux-reviewer | User experience, accessibility, responsive design |
| **Architecture** | architecture-auditor, style-reviewer, observability-reviewer | Design patterns, conventions, logging |
| **Quality** | comment-analyzer, test-analyzer, seo-specialist | Comment accuracy, test coverage, SEO |
| **Development** | autonomous-developer, test-engineer, debugger | Implementation, testing, root cause analysis |
| **Specialized** | git-writer, prompt-engineer, library-advisor | Commits, prompts, dependencies |

### PR Automation: Full Lifecycle

#### Creating the PR

```
/autotask creates PR with:
- Proper branch from worktree
- Conventional commits
- Full description with:
  - Summary of changes
  - Design decisions with rationale
  - Complexity level and why
  - Validation performed
```

#### Addressing Bot Feedback

```
/address-pr-comments     → Autonomous bot feedback triage
```

**What it handles:**
- Fetches comments from all code review bots (Claude, Cursor, Codex, Greptile)
- Triages each comment:
  - **Fix** — Valid issue, implements the fix
  - **Incorrect** — Bot lacks context, explains why with 👎 reaction
  - **WONTFIX** — Technically correct but unwanted, declines with explanation
  - **GitHub Issue** — Valid but out of scope, creates trackable issue
- Adds reactions to train bot behavior (👍, ❤️, 👎, 🚀)
- Pushes fixes, waits for re-analysis, iterates until clean
- Tracks processed comments to avoid re-processing

**Iteration Protocol:**
1. Poll for bot completion (2-15 min based on complexity)
2. Process available feedback immediately
3. Fix valid issues, commit, push
4. Bots re-analyze
5. Repeat until no new actionable feedback
6. Report summary: Fixed (N), Declined (N), Issues Created (N)

#### Merging and Cleanup

```
/wrap-up                 → Merge PR, sync local, clean up branch
/cleanup-worktree        → Remove worktree after merge verification
```

**What /wrap-up does:**
- Verifies PR is mergeable (no conflicts, checks pass)
- Merges with `gh pr merge --merge --delete-branch`
- Checks out main, pulls latest
- Deletes local feature branch
- Reports clear state for context-switching

**What /cleanup-worktree does:**
- Verifies branch was merged to main
- Removes worktree directory
- Preserves all branches for git history
- Returns to primary repo on main

### Session Management: Context Preservation

```
/session save            → Persist context, decisions, progress
/session resume          → Restore exactly where you left off
/handoff-context         → Generate context transfer documentation
```

**Survives:**
- Context compaction
- Tool restarts
- Multi-day work sessions
- Team handoffs

### Additional Commands

| Command | Purpose |
|---------|---------|
| `/do-issue 123` | Full issue lifecycle: triage → implement → PR → merge |
| `/troubleshoot` | Connect to error tracking, analyze, fix bugs |
| `/verify-fix` | Confirm solutions work from user perspective |
| `/load-rules` | Load stack-specific coding standards |
| `/repo-tooling` | Configure linting, formatting, CI/CD |
| `/product-intel` | Competitive research and analysis |
| `/polish-sweep` | Final quality pass before release |
| `/upgrade-deps` | Safe dependency updates |

---

## The Complete Lifecycle

### From Idea to Merged PR

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              COMPLETE WORKFLOW                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  IDEA                                                                       │
│    │                                                                        │
│    ▼                                                                        │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  BMAD PLANNING                                                      │   │
│  │                                                                     │   │
│  │  /bmad:brainstorm        "What if we add real-time collaboration?" │   │
│  │         │                                                          │   │
│  │         ▼                                                          │   │
│  │  /bmad:research          Market analysis, competitor features      │   │
│  │         │                                                          │   │
│  │         ▼                                                          │   │
│  │  /bmad:prd               Requirements, user stories, acceptance    │   │
│  │         │                                                          │   │
│  │         ▼                                                          │   │
│  │  /bmad:architecture      WebSocket vs SSE, data sync strategy      │   │
│  │         │                                                          │   │
│  │         ▼                                                          │   │
│  │  /bmad:epics-and-stories Work breakdown: 3 epics, 12 stories       │   │
│  │         │                                                          │   │
│  │         ▼                                                          │   │
│  │  /bmad:finalize          All docs ready, handoff complete          │   │
│  │                                                                     │   │
│  │  OUTPUT: docs/architecture.md, docs/prd.md, docs/epic-*.md         │   │
│  └─────────────────────────────┬───────────────────────────────────────┘   │
│                                │                                            │
│                        Document Handoff                                     │
│                                │                                            │
│                                ▼                                            │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  AI-CODING-CONFIG EXECUTION                                         │   │
│  │                                                                     │   │
│  │  /setup-environment      Create worktree, install deps, setup env  │   │
│  │         │                                                          │   │
│  │         ▼                                                          │   │
│  │  /autotask "Implement story-1 per docs/epic-1.md"                  │   │
│  │         │                                                          │   │
│  │         ├── Explores codebase via sub-agents                       │   │
│  │         ├── Implements with autonomous-developer                    │   │
│  │         ├── Writes tests with test-engineer                        │   │
│  │         ├── Runs /multi-review (5 agents)                          │   │
│  │         ├── Creates PR #47                                          │   │
│  │         ├── Waits for bots (Claude, Cursor, Codex)                 │   │
│  │         └── Runs /address-pr-comments                               │   │
│  │                  │                                                  │   │
│  │                  ├── Fixes 3 valid issues                          │   │
│  │                  ├── Declines 2 incorrect suggestions               │   │
│  │                  └── Creates 1 follow-up issue                      │   │
│  │         │                                                          │   │
│  │         ▼                                                          │   │
│  │  PR #47 ready for human review                                      │   │
│  │         │                                                          │   │
│  │         ▼                                                          │   │
│  │  /wrap-up                Merge, sync main, delete branch            │   │
│  │         │                                                          │   │
│  │         ▼                                                          │   │
│  │  /cleanup-worktree       Remove worktree, preserve history          │   │
│  │                                                                     │   │
│  │  OUTPUT: Merged code in main, clean git state                      │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│  SHIPPED                                                                    │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Submodule Installation

### 1. Fork Both Repos

```bash
# Fork to your organization
# bmad-code-org/BMAD-METHOD    → your-org/bmad-method
# Light-Brands/ai-coding-config → your-org/ai-coding-config
```

### 2. Add as Submodules

```bash
# Add BMAD
git submodule add https://github.com/your-org/bmad-method .bmad
git submodule update --init --recursive

# Add ai-coding-config
git submodule add https://github.com/your-org/ai-coding-config .ai-coding-config
git submodule update --init --recursive
```

### 3. Configure Upstream Remotes

```bash
# In .bmad/
cd .bmad
git remote add upstream https://github.com/bmad-code-org/BMAD-METHOD
cd ..

# In .ai-coding-config/
cd .ai-coding-config
git remote add upstream https://github.com/Light-Brands/ai-coding-config
cd ..
```

### 4. Directory Structure

```
your-project/
├── .bmad/                          # BMAD submodule (forked)
│   ├── agents/                     # 8 specialized planning agents
│   ├── workflows/                  # 50+ guided workflows
│   ├── tasks/                      # Reusable task definitions
│   └── templates/                  # Document templates
├── .ai-coding-config/              # ai-coding-config submodule (forked)
│   ├── commands/                   # 21 automation commands
│   ├── agents/                     # 24 review agents
│   ├── rules/                      # 33 coding standards
│   ├── skills/                     # 6 multi-step capabilities
│   └── personalities/              # 7 communication styles
├── docs/                           # BMAD writes here
│   ├── product-brief.md
│   ├── prd.md
│   ├── architecture.md
│   ├── epic-*.md
│   ├── story-*.md
│   └── PLANNING_COMPLETE.md
├── src/                            # ai-coding-config builds here
└── .gitworktrees/                  # Isolated development environments
```

### 5. Pulling Upstream Updates

```bash
# Update BMAD
cd .bmad
git fetch upstream
git merge upstream/main
cd ..
git add .bmad && git commit -m "🔄 Update BMAD submodule"

# Update ai-coding-config
cd .ai-coding-config
git fetch upstream
git merge upstream/main
cd ..
git add .ai-coding-config && git commit -m "🔄 Update ai-coding-config submodule"
```

---

## Command Reference

### BMAD Commands (Planning)

| Command | Phase | Output |
|---------|-------|--------|
| `/bmad:brainstorm` | Analysis | Ideas, themes, action plans |
| `/bmad:research` | Analysis | Market/technical findings |
| `/bmad:product-brief` | Analysis | Strategic vision document |
| `/bmad:prd` | Planning | Product Requirements Document |
| `/bmad:ux-design` | Planning | UX specification |
| `/bmad:nfr-assess` | Planning | Non-functional requirements |
| `/bmad:architecture` | Solutioning | System design with ADRs |
| `/bmad:epics-and-stories` | Solutioning | Work breakdown structure |
| `/bmad:test-design` | Solutioning | Test strategy and coverage |
| `/bmad:implementation-readiness` | Solutioning | Gate validation |
| `/bmad:party-mode` | Any | Multi-agent collaboration |
| `/bmad:finalize` | Handoff | PLANNING_COMPLETE.md |

### ai-coding-config Commands (Execution)

| Command | Stage | Purpose |
|---------|-------|---------|
| `/setup-environment` | Setup | Initialize worktree with deps |
| `/load-rules` | Setup | Load stack-specific standards |
| `/autotask` | Implement | Full autonomous implementation |
| `/do-issue` | Implement | Issue → PR lifecycle |
| `/troubleshoot` | Debug | Error analysis and fixing |
| `/verify-fix` | Validate | Confirm behavior works |
| `/multi-review` | Review | Parallel multi-agent review |
| `/address-pr-comments` | PR | Triage and fix bot feedback |
| `/wrap-up` | Merge | Merge PR, sync, cleanup |
| `/cleanup-worktree` | Cleanup | Remove worktree post-merge |
| `/session save` | Persist | Save context and progress |
| `/session resume` | Persist | Restore previous session |
| `/handoff-context` | Persist | Generate transfer docs |

---

## The Mental Model

```
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│   "What are we building?"          "How do we build it?"      │
│                                                                │
│         BMAD                         ai-coding-config          │
│                                                                │
│   • Strategy & vision              • Environment setup         │
│   • Requirements                   • Implementation            │
│   • Architecture                   • Testing                   │
│   • User stories                   • Code review               │
│   • Test strategy                  • PR automation             │
│   • Brand guidelines               • Bot feedback              │
│                                    • Merge & cleanup           │
│                                                                │
│        /bmad:*                         /build:*                │
│                                                                │
│   OUTPUT: Documentation            OUTPUT: Shipped Code        │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

---

## Summary

| Dimension | BMAD | ai-coding-config |
|-----------|------|------------------|
| **Phase** | Planning | Execution |
| **Agents** | 8 planning specialists | 24 review specialists |
| **Workflows** | 50+ structured processes | 21 automation commands |
| **Input** | Ideas, requirements | Planning documentation |
| **Output** | PRD, architecture, stories | Merged, tested code |
| **Special Powers** | Party mode, 60+ ideation techniques | Git worktrees, PR automation |

**Together they provide:**

- Structured planning that prevents "just start coding" mistakes
- Comprehensive documentation before implementation
- Autonomous execution with full test coverage
- Multi-agent code review from 24 perspectives
- Full PR lifecycle automation with iterative bot feedback
- Clean git workflow with worktrees and proper cleanup

**One plans. One executes. Documentation is the contract.**

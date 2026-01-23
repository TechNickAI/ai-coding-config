# BMAD-METHOD + ai-coding-config: Unified Development Lifecycle

A two-phase development system where BMAD handles planning and ai-coding-config handles execution—completely isolated, connected only by documentation.

---

## The Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         Your Project Repository                         │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│   .bmad/                          .ai-coding-config/                    │
│   └── (submodule)                 └── (submodule)                       │
│       ↓                               ↓                                 │
│       Fork of BMAD-METHOD             Fork of ai-coding-config          │
│       github.com/you/bmad             github.com/you/ai-coding-config   │
│                                                                         │
│   docs/                           src/                                  │
│   ├── strategy.md        ───→     ├── components/                       │
│   ├── architecture.md    ───→     ├── services/                         │
│   ├── brand-guidelines.md         └── ...                               │
│   ├── user-stories.md                                                   │
│   └── tech-decisions.md                                                 │
│                                                                         │
│         BMAD WRITES                    AI-CODING-CONFIG READS           │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### Core Principle

**Complete isolation. Document-based handoff.**

- BMAD and ai-coding-config never communicate directly
- BMAD produces documentation artifacts
- ai-coding-config consumes those artifacts to guide implementation
- Each framework lives in its own submodule, pulls upstream updates independently

---

## Phase 1: Planning (BMAD)

BMAD owns everything before code gets written.

### What BMAD Produces

| Document | Purpose |
|----------|---------|
| `docs/strategy.md` | Project vision, goals, success metrics |
| `docs/requirements.md` | User stories, acceptance criteria |
| `docs/architecture.md` | System design, data models, tech stack decisions |
| `docs/brand-guidelines.md` | Voice, tone, visual identity, naming conventions |
| `docs/api-contracts.md` | Endpoint definitions, request/response schemas |
| `docs/tech-decisions.md` | ADRs (Architecture Decision Records) |

### BMAD Workflow

```
/bmad:start              → Scale assessment, project classification
/bmad:analyze            → Requirements gathering, user research
/bmad:plan               → Sprint structure, milestones, priorities
/bmad:architect          → Tech stack, data models, system design
/bmad:brand              → Guidelines, voice, naming conventions
/bmad:finalize           → Review all docs, mark planning complete
```

### Planning Complete Checklist

Before handing off to ai-coding-config:

- [ ] Strategy document defines clear success metrics
- [ ] All user stories have acceptance criteria
- [ ] Architecture decisions are documented with rationale
- [ ] Tech stack is chosen and justified
- [ ] Data models are defined
- [ ] API contracts are specified
- [ ] Brand/style guidelines exist (if applicable)

---

## Phase 2: Execution (ai-coding-config)

ai-coding-config owns everything once code starts.

### What ai-coding-config Consumes

The execution phase reads BMAD's output:

```typescript
// ai-coding-config looks for planning docs in standard locations
const PLANNING_DOCS = [
  'docs/architecture.md',    // Tech decisions guide implementation
  'docs/requirements.md',    // User stories become tasks
  'docs/api-contracts.md',   // Contracts enforce interfaces
  'docs/brand-guidelines.md' // Style guides inform UI code
];
```

### ai-coding-config Workflow

```
/build:load-context      → Ingest planning docs, understand project
/build:autotask          → Implement features per requirements
/build:review            → Multi-agent code review
/build:troubleshoot      → Debug issues using documented architecture
/session:save            → Persist progress
/session:resume          → Continue work with full context
```

### Execution Standards

ai-coding-config enforces:

- Code standards from `.ai-coding-config/rules/`
- Commit conventions
- PR review checklists
- Test coverage requirements
- Security review gates

---

## Submodule Setup

### Initial Installation

```bash
# Fork both repos to your org first, then:

# Add BMAD as submodule
git submodule add https://github.com/YOUR-ORG/bmad-method .bmad
git submodule update --init --recursive

# Add ai-coding-config as submodule
git submodule add https://github.com/YOUR-ORG/ai-coding-config .ai-coding-config
git submodule update --init --recursive
```

### Directory Structure

```
your-project/
├── .bmad/                      # BMAD submodule (forked)
│   ├── agents/
│   ├── workflows/
│   └── ...
├── .ai-coding-config/          # ai-coding-config submodule (forked)
│   ├── commands/
│   ├── agents/
│   ├── rules/
│   └── ...
├── docs/                       # BMAD writes here
│   ├── strategy.md
│   ├── architecture.md
│   └── ...
├── src/                        # ai-coding-config builds here
└── ...
```

### Pulling Upstream Updates

```bash
# Update BMAD from upstream
cd .bmad
git fetch upstream
git merge upstream/main
cd ..
git add .bmad
git commit -m "🔄 Update BMAD submodule"

# Update ai-coding-config from upstream
cd .ai-coding-config
git fetch upstream
git merge upstream/main
cd ..
git add .ai-coding-config
git commit -m "🔄 Update ai-coding-config submodule"
```

---

## The Handoff

The transition from planning to execution is explicit and documented.

### Handoff Trigger

When BMAD completes planning:

```
/bmad:finalize
```

This command:
1. Validates all required docs exist
2. Runs completeness checks
3. Generates a `docs/PLANNING_COMPLETE.md` summary
4. Signals readiness for execution phase

### Handoff Artifact

```markdown
<!-- docs/PLANNING_COMPLETE.md -->
# Planning Phase Complete

## Summary
- Project: [Name]
- Scale Level: [0-4]
- Tech Stack: [Chosen technologies]

## Documents Ready
- [x] strategy.md
- [x] requirements.md
- [x] architecture.md
- [x] api-contracts.md

## Key Decisions
1. Using PostgreSQL for persistence (see tech-decisions.md#database)
2. React + TypeScript frontend (see tech-decisions.md#frontend)
3. REST API with OpenAPI spec (see api-contracts.md)

## Ready for Execution
Planning is complete. Run `/build:load-context` to begin implementation.
```

### Starting Execution

```
/build:load-context docs/
```

ai-coding-config:
1. Reads all planning documents
2. Extracts requirements as actionable tasks
3. Loads appropriate rules for the tech stack
4. Begins implementation following documented architecture

---

## Why This Works

### Complete Isolation

| Aspect | Benefit |
|--------|---------|
| Separate submodules | Each framework updates independently |
| No runtime coupling | No complex integration code to maintain |
| Forked repos | Customize without losing upstream connection |
| Document contract | Clear interface between phases |

### Clear Responsibilities

| Phase | Owner | Artifacts |
|-------|-------|-----------|
| Planning | BMAD | Markdown docs in `docs/` |
| Execution | ai-coding-config | Code in `src/`, tests, PRs |

### Upstream Maintenance

Both frameworks evolve independently:

- Pull BMAD updates for new planning workflows
- Pull ai-coding-config updates for new review agents
- Your forks let you customize while staying connected
- Submodules pin to specific commits for stability

---

## Unified Command Namespace

While the systems are isolated, the developer experience is unified through namespaced commands:

### Planning Commands (BMAD)

```
/bmad:help               → Show available planning workflows
/bmad:start              → Begin new project planning
/bmad:analyze            → Requirements and analysis phase
/bmad:plan               → Sprint and milestone planning
/bmad:architect          → Technical architecture
/bmad:brand              → Brand and style guidelines
/bmad:finalize           → Complete planning, prepare handoff
```

### Execution Commands (ai-coding-config)

```
/build:load-context      → Ingest planning docs
/build:autotask          → Autonomous implementation
/build:review            → Code review workflow
/build:troubleshoot      → Debugging assistance
/session:save            → Persist current state
/session:resume          → Restore previous session
/load-rules              → Load stack-specific rules
```

### The Mental Model

```
Am I deciding WHAT to build?     → /bmad:*
Am I writing HOW to build it?    → /build:*
```

---

## Getting Started

### 1. Fork Both Repos

- Fork `bmad-code-org/BMAD-METHOD` → `your-org/bmad-method`
- Fork `Light-Brands/ai-coding-config` → `your-org/ai-coding-config`

### 2. Add Submodules to Your Project

```bash
git submodule add https://github.com/your-org/bmad-method .bmad
git submodule add https://github.com/your-org/ai-coding-config .ai-coding-config
```

### 3. Start Planning

```
/bmad:start
```

### 4. Complete Planning Docs

Work through BMAD workflows until all docs are ready.

### 5. Finalize and Hand Off

```
/bmad:finalize
```

### 6. Begin Execution

```
/build:load-context docs/
/build:autotask "Implement user authentication per docs/architecture.md"
```

---

## Summary

| Question | Answer |
|----------|--------|
| Are they integrated? | No—completely isolated |
| How do they communicate? | Through documentation only |
| Can I update them independently? | Yes—separate submodules, forked repos |
| What's the handoff? | BMAD writes docs, ai-coding-config reads them |
| When do I use BMAD? | Before writing code |
| When do I use ai-coding-config? | When writing code |

**BMAD answers:** "What are we building and why?"

**ai-coding-config answers:** "How do we build it correctly?"

One plans. One executes. Documentation is the contract.

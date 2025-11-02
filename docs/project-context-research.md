# Project Context File Research & Recommendations

## Executive Summary

The AI coding tools ecosystem has evolved from fragmented tool-specific configurations
(`.cursorrules`, `CLAUDE.md`, `GEMINI.md`) toward a unified standard: **AGENTS.md**.
This research examines the current landscape, best practices, and provides
recommendations for implementing a single source of truth for project context across
multiple AI coding assistants.

**Key Finding**: AGENTS.md has emerged as the vendor-neutral standard, supported by
OpenAI, GitHub Copilot, Sourcegraph Amp, and increasingly by other tools. It's currently
used in 20k+ open source projects.

---

## The Landscape: Tool-Specific vs Universal Standards

### Historical Context

Different AI coding tools developed proprietary context file formats:

| Tool                  | Primary File                      | Status                             |
| --------------------- | --------------------------------- | ---------------------------------- |
| **Claude Code**       | `CLAUDE.md`                       | Active, but migrating to AGENTS.md |
| **Cursor**            | `.cursorrules` → `.cursor/rules/` | Deprecated → Modern                |
| **GitHub Copilot**    | `.github/copilot-instructions.md` | Active + AGENTS.md support         |
| **Gemini CLI**        | `GEMINI.md`                       | Active                             |
| **Sourcegraph Amp**   | `AGENTS.md`                       | Native support                     |
| **Continue**          | `.continuerules`                  | Active                             |
| **JetBrains (Junie)** | `.junie/guidelines.md`            | Active                             |

### The Convergence: AGENTS.md

In July 2025, OpenAI introduced AGENTS.md as an open standard:

> "AGENTS.md — a simple, open format for guiding coding agents"

**Why it matters:**

- **Cross-tool compatibility**: One file works across Claude Code, Cursor, GitHub
  Copilot, and others
- **Team consistency**: Contributors can use different tools but share the same context
- **Future-proof**: Vendor-neutral standard reduces lock-in
- **Widespread adoption**: 160k+ GitHub repositories already using related formats

### Migration Strategy

The recommended approach for existing tool-specific files:

```bash
# Create AGENTS.md as the primary source
mv CLAUDE.md AGENTS.md

# Create symlinks for backward compatibility
ln -s AGENTS.md CLAUDE.md
ln -s AGENTS.md GEMINI.md
```

This ensures existing tool integrations continue working while transitioning to the
universal standard.

---

## What Goes in a Project Context File?

### Core Philosophy

A project context file serves as **onboarding documentation for your AI teammate**.
Unlike README (which targets human developers), it contains:

- **Detailed technical context** that AI needs to make correct decisions
- **Specific commands and conventions** to avoid hallucination
- **Project-specific constraints** and preferences
- **Iterative refinements** based on actual AI behavior

### Essential Sections

Based on Anthropic's recommendations and community best practices:

#### 1. **Tech Stack & Dependencies**

Be specific about versions to prevent version mismatches:

```markdown
## Tech Stack

- Node.js 20.x
- TypeScript 5.3
- React 18.2 with Next.js 14
- MUI v3 (important: not v4 or v5)
- Emotion for styling
- MobX for state management
```

**Why**: AI models may default to more common versions or patterns if not specified.
Explicit versions prevent hours of debugging incompatible code.

#### 2. **Project Structure**

Help the AI navigate your codebase efficiently:

```markdown
## Project Structure

- `src/components/` - React components, organized by feature
- `src/lib/` - Shared utility functions
- `src/styles/` - Design tokens in `DynamicStyles.tsx`
- `scripts/` - Build and deployment automation
- `.claude/` - Claude Code configuration and commands
```

**Why**: Reduces token waste from the AI exploring the wrong directories. Speeds up task
completion.

#### 3. **Commands**

Critical for preventing the AI from guessing or using wrong commands:

```markdown
## Common Commands

**Development**:

- `pnpm dev` - Start dev server (use pnpm, not npm)
- `pnpm test:watch` - Run tests in watch mode
- `pnpm lint` - Run ESLint
- `pnpm type-check` - Run TypeScript compiler check only

**Build**:

- `pnpm build` - Production build
- `pnpm preview` - Preview production build locally

**Per-file testing** (faster than full builds):

- `pnpm test:file <path>` - Test single file
```

**Why**: Avoids expensive mistakes like running `npm install` in a `pnpm` project, or
attempting full rebuilds when testing a single file.

#### 4. **Code Style & Conventions**

Be opinionated and specific:

```markdown
## Code Style

**DO**:

- Use Emotion `css={{}}` prop format for styling
- Import design tokens from `DynamicStyles.tsx` - never hardcode colors, spacing, or
  breakpoints
- Use MobX stores for state management, not useState for shared state
- Follow conventional commits format for commit messages
- Write tests for all new features

**DON'T**:

- Don't use inline styles with hardcoded values
- Don't create new CSS files (use Emotion)
- Don't install new dependencies without discussion
- Don't modify files in `/generated` directory
```

**Why**: This section typically has the highest ROI. Real example: Without specifying
MUI version and Emotion format, AI generated v4 code with different APIs, requiring
complete rewrites.

#### 5. **Testing Instructions**

Clear guidance on test requirements and execution:

```markdown
## Testing

- All new features require tests
- Tests live in `__tests__/` directories next to source files
- Run full suite: `pnpm test`
- Run specific test: `pnpm test:file src/components/Button/__tests__/Button.test.tsx`
- CI runs on all PRs - must pass before merge
- Minimum coverage: 80%
```

**Why**: Establishes quality expectations and prevents the "write code but skip tests"
pattern.

#### 6. **Repository Etiquette**

How to work with version control:

```markdown
## Repository Guidelines

**Commits**:

- Use conventional commits: `feat:`, `fix:`, `docs:`, `refactor:`, etc.
- Keep commits atomic and focused
- Reference issues: `feat: add dark mode toggle (#123)`

**Branches**:

- Main branch: `main` (protected)
- Feature branches: `feature/description`
- Bug fixes: `fix/description`

**PRs**:

- All changes require PR review
- Include tests and documentation
- Ensure CI passes
```

**Why**: Maintains git history quality and prevents merge conflicts from poor branching
strategies.

#### 7. **Warnings & Gotchas**

Document unexpected behaviors or sharp edges:

```markdown
## Important Warnings

- Build process requires 4GB RAM minimum
- The `/legacy` directory uses old patterns - don't replicate its style
- WebSocket connections timeout after 5 minutes - implement reconnection logic
- Dark mode tokens are separate from light mode - test both themes
```

**Why**: Saves hours of debugging mysterious failures that are already known issues.

### Optional Advanced Sections

For larger or more complex projects:

#### 8. **Architecture & Design Patterns**

```markdown
## Architecture

- Use composition over inheritance
- Follow React Hooks patterns (no class components)
- API calls go through `src/lib/api/` client
- Error boundaries at route level
```

#### 9. **Development Environment**

```markdown
## Environment Setup

- Requires `.env.local` with: `NEXT_PUBLIC_API_URL`, `DATABASE_URL`
- Optional: `.env.local.example` shows required variables
- Use Docker for local database: `docker-compose up -d`
```

#### 10. **Performance Considerations**

```markdown
## Performance

- Images must use Next.js `<Image>` component
- Lazy load components below fold
- API routes should respond in <200ms
- Use React.memo for expensive list renders
```

---

## What NOT to Include

Equally important is knowing what to exclude:

### ❌ Avoid Long Prose

**Bad**:

> "Our project uses a modern, cutting-edge approach to state management that leverages
> the power of MobX, a battle-tested library that has been proven in production
> environments..."

**Good**:

> "Use MobX for state management"

**Why**: Every character consumes tokens. AI needs facts, not marketing copy.

### ❌ Avoid Duplicating README

**Don't repeat**:

- Project description
- Installation instructions for end users
- License information
- Contributing guidelines (unless AI-specific)

**Why**: README already covers this for humans. Context files should focus on
AI-specific needs.

### ❌ Avoid Vague Guidance

**Bad**:

> "Write good code and follow best practices"

**Good**:

> "All functions must have JSDoc comments. Use TypeScript strict mode."

**Why**: Vague guidance doesn't change AI behavior. Specific rules do.

### ❌ Avoid Overly Restrictive Rules

**Bad**:

> "Never use any dependencies. Never create new files. Never refactor."

**Why**: This hamstrings the AI's ability to help. Be opinionated about conventions, not
paralyzed.

---

## File Locations & Hierarchy

### Repository Root (Recommended)

**File**: `AGENTS.md` at project root

**Benefits**:

- Discoverable by all tools
- Committed to git for team sharing
- Single source of truth
- Works with monorepos using nested files

**Example**:

```
my-project/
├── AGENTS.md           # Main project context
├── CLAUDE.md           # Symlink → AGENTS.md
├── .cursor/
│   └── rules/          # Cursor-specific rules (if needed)
└── packages/
    ├── frontend/
    │   └── AGENTS.md   # Frontend-specific context
    └── backend/
        └── AGENTS.md   # Backend-specific context
```

### Home Directory (Global)

**File**: `~/.claude/CLAUDE.md` or `~/.config/agents/AGENTS.md`

**Use case**:

- Personal preferences (e.g., "always use pnpm")
- Cross-project conventions
- Tool-specific settings

**Should NOT contain**:

- Project-specific information
- Team conventions (these belong in repo)

### Local Overrides

**File**: `AGENTS.local.md` or `CLAUDE.local.md` (gitignored)

**Use case**:

- Personal workflow preferences
- Local development shortcuts
- Experimental rules

**Example .gitignore**:

```
*.local.md
AGENTS.local.md
CLAUDE.local.md
```

---

## Iterative Refinement Strategy

### Start Small

Don't try to write the perfect context file upfront. Start with:

1. **Tech stack** (frameworks, versions)
2. **Key commands** (dev, build, test)
3. **3-5 most important conventions**

### Observe & Refine

Track patterns in AI behavior:

- **When AI makes mistakes**: Add a rule to prevent it
- **When you repeat instructions**: Add them to the file
- **When code quality improves**: Keep the rule

### Use Real Feedback Loops

Many tools support dynamic updates:

- **Claude Code**: Use `#` keyboard shortcut to add current instruction to context file
- **Cursor**: Project rules can be edited and take effect immediately
- **Manual**: Keep a scratch file of "rules to add" during sessions

### Test Changes

After updates:

1. Start fresh conversation/session
2. Give AI a representative task
3. Evaluate if behavior improved
4. Iterate

### Version Control Best Practices

```bash
# Commit context file changes with descriptive messages
git add AGENTS.md
git commit -m "docs: add MobX state management requirement to AGENTS.md"

# Review changes in PRs
# Treat AGENTS.md changes like code - they affect output quality
```

---

## Tool-Specific Considerations

### Claude Code

**Native support**: `CLAUDE.md` files at multiple levels

**Locations checked** (in order):

1. Current directory and parents
2. Project root
3. `~/.claude/CLAUDE.md` (global)

**Best practice**: Create `AGENTS.md` and symlink `CLAUDE.md → AGENTS.md`

**Directory structure**:

```
.claude/
├── context.md              # Base context (optional, legacy)
├── commands/              # Slash commands
│   ├── commit.md
│   └── review.md
└── agents/                # Sub-agents (if using agent framework)
    └── reviewer.md
```

### Cursor

**Modern approach**: `.cursor/rules/` directory

**Benefits**:

- Multiple rule files
- Path-based scoping
- Version controlled

**Migration**:

```bash
# Old way
.cursorrules

# New way
.cursor/
└── rules/
    ├── typescript.md      # TypeScript-specific rules
    ├── react.md          # React-specific rules
    └── testing.md        # Testing rules
```

**Also supports**: Reading `AGENTS.md` automatically

### GitHub Copilot

**Primary**: `.github/copilot-instructions.md`

**Also supports**: `AGENTS.md` (as of August 2025)

**Recommendation**: Use `AGENTS.md` and optionally symlink Copilot file

### Sourcegraph Amp

**Native support**: `AGENTS.md`

**Also reads**: `AGENT.md` (backward compatibility)

---

## Size & Token Considerations

### The Token Tax

Every character in your context file consumes tokens on **every** AI interaction:

- **Small file** (1KB): ~250 tokens per request
- **Medium file** (4KB): ~1000 tokens per request
- **Large file** (10KB): ~2500 tokens per request

Over a 100-message session:

- Small: 25k tokens (affordable)
- Large: 250k tokens (expensive, may hit limits)

### Optimization Strategies

1. **Be concise**: Bullet points, not paragraphs
2. **Use code blocks**: Clear examples, minimal explanation
3. **Avoid redundancy**: Don't repeat information
4. **Split by scope**: Use nested files in subdirectories for subsystem-specific rules
5. **Link, don't duplicate**: Reference other docs when appropriate

### When to Split

Consider multiple context files when:

- **Monorepo**: Different packages have different conventions
- **Polyglot project**: Backend and frontend use different stacks
- **Large codebase**: >100k LOC with distinct subsystems

**Example hierarchy**:

```
AGENTS.md                    # Shared conventions (1KB)
frontend/AGENTS.md           # React-specific (2KB)
backend/AGENTS.md            # Node.js-specific (2KB)
mobile/AGENTS.md             # React Native-specific (2KB)
```

Total per context: 3KB instead of 7KB monolithic file.

---

## Recommendations for This Project (ai-coding-config)

### Current State Analysis

This project currently has:

- `.claude/context.md` - Contains identity and rule loading instruction
- `.claude/commands/` - Slash commands
- Multiple personality directories with `claude/` subdirectories
- Extensive plugin architecture

### Recommended Structure

```
AGENTS.md                    # New: Universal project context
CLAUDE.md                    # Symlink → AGENTS.md
.claude/
├── context.md              # Keep for identity/personality (or merge into AGENTS.md)
├── commands/              # Keep as-is
└── agents/                # Keep as-is
```

### What Should Go in AGENTS.md for This Project

Based on this project's unique characteristics:

1. **Project Identity**
   - This is a meta-project: AI coding configuration repository
   - Purpose: Manage AI coding configurations across tools
   - Plugin architecture with dynamic loading

2. **Tech Stack**
   - Shell scripts (bash)
   - Markdown-based configuration
   - Git-based distribution

3. **Key Concepts**
   - Plugin system architecture
   - Personality system
   - Slash command structure
   - Cursor rules organization

4. **Common Commands**
   - Installation commands
   - Plugin management
   - Testing approaches

5. **Critical Conventions**
   - Markdown format for configs
   - Plugin directory structure requirements
   - Cursor rule loading system
   - Commit message format

6. **Warnings**
   - Don't modify core system files directly
   - Test personality changes before committing
   - Respect plugin boundaries

---

## Migration & Command Strategy

### Phase 1: Create Initial AGENTS.md

Command should:

1. Analyze project to understand tech stack
2. Generate initial AGENTS.md with core sections
3. Create symlinks for tool compatibility
4. Prompt user to review and customize

### Phase 2: Update Mechanism

Command should:

1. Detect if AGENTS.md exists
2. Analyze recent commits/changes to understand updates needed
3. Suggest additions based on:
   - New dependencies
   - New conventions observed in code
   - Repeated AI mistakes (if trackable)
4. Show diff and ask for approval before updating

### Implementation Considerations

**Avoid**:

- Overwriting user customizations
- Generating generic boilerplate
- Creating overly long files

**Include**:

- Project-specific intelligence (scan package.json, tech stack)
- Interactive prompts for ambiguous choices
- Diff preview before changes
- Backup mechanism

---

## Key Insights from Research

### 1. **The Virtuous Cycle**

> "When we set up a good context file, the agent's performance gets better. As it gets
> better, we tend to use it more, which helps us further improve and refine the
> context."

Investment in context files compounds over time.

### 2. **Specificity Over Generality**

Projects with specific, actionable rules see dramatically better AI output than those
with vague guidance.

### 3. **The README Question**

Some argue: "If you need to tell AI this, your README is incomplete."

**Counter-argument**: Context files serve a different purpose:

- README: Human onboarding, project description
- AGENTS.md: AI-specific conventions, commands, gotchas

Both can coexist and complement each other.

### 4. **Tool Consolidation Trend**

The ecosystem is moving toward AGENTS.md as the standard. Early adoption positions
projects well for future tool compatibility.

### 5. **Don't Over-Engineer Early**

Start small. Real project usage reveals what rules matter. Premature optimization wastes
time on rules that don't affect behavior.

---

## Final Recommendation

### The File: AGENTS.md

**Primary recommendation**: Use `AGENTS.md` as the single source of truth.

**Rationale**:

1. ✅ Vendor-neutral standard
2. ✅ Growing ecosystem support (20k+ projects)
3. ✅ Works with Claude Code, Cursor, GitHub Copilot, and others
4. ✅ Future-proof naming
5. ✅ Clear semantic meaning

### Compatibility Layer

**Create symlinks** for tool-specific names:

```bash
ln -s AGENTS.md CLAUDE.md
ln -s AGENTS.md .cursorrules  # If needed for legacy support
```

### This Project's Approach

For `ai-coding-config` specifically:

1. **Create** `AGENTS.md` with project-specific context
2. **Symlink** `CLAUDE.md → AGENTS.md`
3. **Keep** `.claude/context.md` for identity/personality (or merge)
4. **Keep** `.claude/commands/` and `.claude/agents/` structure
5. **Document** the convention in this project's docs

### Command Design

Create `/init-agents` command that:

- Generates intelligent AGENTS.md by analyzing project
- Creates compatibility symlinks
- Prompts for customization decisions
- Supports update/refresh mode

---

## Open Questions for Design Decisions

Before implementing the command, clarify:

1. **Identity & Personality**: Should personality instructions live in AGENTS.md or
   remain in `.claude/context.md`?

2. **Scope**: Should the command:
   - Generate generic templates, or
   - Intelligently analyze the codebase and create project-specific content?

3. **Update Strategy**: When AGENTS.md exists, should updates:
   - Be fully manual (user edits directly)?
   - Be AI-assisted (command suggests additions)?
   - Be automated (command syncs with detected changes)?

4. **Multi-tool Strategy**: Should we generate tool-specific files or just use symlinks?

5. **Monorepo Handling**: For projects with plugins, should we create:
   - One AGENTS.md at root?
   - Nested AGENTS.md per plugin?
   - Both with inheritance?

6. **Content Philosophy**: Prioritize:
   - Comprehensive documentation (larger file), or
   - Minimal essential context (smaller file, lower token cost)?

---

## References

- [AGENTS.md Official Specification](https://github.com/openai/agents.md)
- [Anthropic Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Builder.io Guide to AGENTS.md](https://www.builder.io/blog/agents-md)
- [AGENTS.md Announcement](https://pnote.eu/notes/agents-md/)
- [Community Context File Examples](https://gist.github.com/0xdevalias/f40bc5a6f84c4c5ad862e314894b2fa6)

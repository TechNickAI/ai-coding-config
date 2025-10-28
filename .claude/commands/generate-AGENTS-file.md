---
description: Generate or update AGENTS.md with essential project context for AI coding assistants
---

# Generate AGENTS.md

Creates or updates `AGENTS.md` - a universal project context file for AI coding assistants (Claude Code, Cursor, GitHub Copilot, etc.).

## Philosophy

AGENTS.md should be:
- **Concise** - Every character consumes tokens on every AI interaction
- **Non-redundant** - Don't repeat what's in README or obvious from code
- **Actionable** - Specific commands, conventions, and constraints
- **Valuable** - Only include what genuinely improves AI output

Think: "What do I keep repeating to the AI that would prevent mistakes?"

## Generation Process

### Step 1: Analyze Project Structure

Detect what kind of project this is:
- Check `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, etc.
- Identify frameworks (Django vs FastAPI, React vs Next.js, etc.)
- Find test frameworks and build tools
- Locate key directories (`src/`, `tests/`, etc.)

### Step 2: Extract "Always Apply" Rules

**Critical**: Scan `.cursor/rules/` for rules with `alwaysApply: true` in frontmatter.

These are the MOST IMPORTANT conventions - they apply to every task. Extract:
- Core principle or constraint from each rule
- Key DO/DON'T points
- Critical commands or patterns

**Important**: Be selective - extract the essence, not the entire rule content. Focus on:
- Non-obvious constraints that prevent mistakes
- Specific commands or patterns to follow
- Project-specific conventions that differ from defaults

**Skip**: Generic best practices that any AI already knows (like "write tests" unless there's a specific test approach).

### Step 3: Extract Key Context

Read these sources for essential project-specific context:

**From README.md**:
- Project tech stack and versions (be specific: "Next.js 14" not just "Next.js")
- Key commands (dev, build, test)
- **Skip**: Project description, installation steps for end users, contributing guides

**From .claude/context.md** (if exists):
- Identity or personality instructions (if project uses custom personality)
- Any project-specific AI behavior guidelines

**From recent git commits** (last 10):
- Observe commit message style and conventions
- Identify patterns (emoji usage, conventional commits, etc.)

### Step 4: Generate/Update AGENTS.md

Create a structured file with these sections (omit sections with no valuable content):

```markdown
# Project Context for AI Assistants

Brief 1-2 sentence description of what this project is.

## Tech Stack

- Framework/language with specific versions
- Key dependencies that affect how code should be written
- Build tools and their commands

## Project Structure

- `dir/` - Brief purpose (only if non-obvious)
- Focus on where AI should look for specific types of files

## Commands

List only PROJECT-SPECIFIC commands. Skip generic commands like `git status` or `npm install`.

**Good examples**:
- `pnpm dev` - Start dev server (use pnpm not npm)
- `pytest tests/unit` - Run only unit tests (integration tests are slow)
- `/load-cursor-rules` - Load relevant rules for current task

**Bad examples** (too generic, cut these):
- `git status` - Check git status
- `npm test` - Run tests
- `ls -la` - List files

## Code Conventions

**DO**:
- Specific patterns to follow
- Required practices unique to this project
- Non-obvious constraints that prevent mistakes

**DON'T**:
- Specific anti-patterns to avoid
- Project-specific constraints
- Explicitly forbidden practices (like --no-verify if that's a rule)

## Git Workflow

- Commit message format (if specific convention exists)
- **Important**: Include critical git constraints from always-apply rules
- Skip generic emoji lists - one example is enough
- Skip restating the full commit format if it's standard

## Important Notes

- Non-obvious gotchas or warnings
- Critical context that prevents mistakes
- Dependencies between systems
- Unique aspects of this project that AI must understand
```

### Step 5: Optimize for Token Usage

After generating content, review and optimize:

1. **Remove redundancy**: If tech stack mentions "Node 20", don't repeat it elsewhere
2. **Be concise**: "Use pnpm not npm" instead of paragraph explaining why
3. **Cut obvious fluff**: Remove generic advice like "write good code"
4. **Use examples sparingly**: Only when they clarify non-obvious patterns
5. **Cut generic commands**: Remove `git status`, `git diff`, basic npm/pip commands
6. **Skip emoji lists**: One example format is enough, don't list all possible emojis
7. **Remove meta-commentary**: Cut self-referential notes about token usage or file purpose
8. **Question each bullet**: Ask "Would removing this cause AI to make a mistake?" If no, cut it.

Target: 2-3KB for most projects (500-750 tokens per interaction). 4KB maximum.

### Step 6: Create CLAUDE.md Pointer File

Instead of creating a symlink, create a SHORT `CLAUDE.md` file that explains why we use AGENTS.md:

```markdown
# This project uses AGENTS.md

We use `AGENTS.md` as our universal project context file instead of tool-specific files.

**Why AGENTS.md**: It's a vendor-neutral standard (from OpenAI, July 2025) that works across Claude Code, Cursor, GitHub Copilot, and other AI coding assistants. Contributors can use different tools while sharing the same context.

**For project context**: See `AGENTS.md`

**Learn more**: https://github.com/openai/agents.md
```

This educates about the standard while adding minimal tokens (~150) compared to duplicating all content.

### Step 7: Report

Show the user:
1. The generated content
2. File size and estimated token cost per interaction
3. What was included and what was deliberately omitted

## Update Mode

When `AGENTS.md` already exists:

1. Read existing file to understand current content
2. Analyze project for changes:
   - New dependencies in package files
   - New "always apply" rules added
   - Updated commands or conventions
3. Suggest additions or updates with rationale
4. Show diff of proposed changes
5. Let user approve before updating

**Never** silently overwrite - always show what's changing and why.

## Key Principles

**Be surgical, not comprehensive**: Extract only what AI needs that isn't obvious. Skip generic best practices.

**Prioritize always-apply rules**: These are gold - they represent project-critical conventions.

**Token economics matter**: A 10KB file costs 2500 tokens/interaction. Over 100 messages, that's 250K tokens. Be ruthless about value-per-byte.

**Test the hypothesis**: Ask yourself "Would this prevent a mistake I've seen AI make?" If no, cut it.

**Avoid restating README**: If README explains it well, don't duplicate it here.

## What NOT to Include

- Project description and marketing copy (that's for README)
- Installation instructions for end users
- License and contribution guidelines (unless AI-specific)
- Complete rule content (extract essence only)
- Generic best practices AI already knows
- Obvious directory purposes (like `tests/` contains tests)
- Complete API documentation (link to it instead)
- Generic git commands (`git status`, `git diff`, `git log`)
- Emoji reference lists (one example format is sufficient)
- Meta-commentary about token usage or AGENTS.md purpose
- Commit message co-author footers (unless project requires them on ALL commits)
- Redundant notes that restate what's already clear from other sections

## Output

Final checklist:

- [ ] File is concise (2-3KB target, 4KB max)
- [ ] No redundancy with README
- [ ] Includes essence of always-apply rules (not full content)
- [ ] Commands are PROJECT-SPECIFIC (no generic git/npm commands)
- [ ] DO/DON'T lists have actionable items
- [ ] Removed all generic fluff and meta-commentary
- [ ] Cut emoji lists, generic commands, obvious notes
- [ ] No commit co-author footers unless project requires on all commits
- [ ] Created CLAUDE.md pointer file (not symlink)
- [ ] Each section passes "would removing this cause a mistake?" test

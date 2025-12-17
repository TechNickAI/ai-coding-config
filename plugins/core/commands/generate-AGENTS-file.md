---
description: "Generate or update AGENTS.md with project context for AI assistants"
model: opus
version: 0.2.0
---

# Generate AGENTS.md

Creates or updates `AGENTS.md` - a universal project context file for AI coding
assistants (Claude Code, Cursor, GitHub Copilot, etc.).

<philosophy>
AGENTS.md provides domain knowledge and constraints that AI assistants can't infer from
code alone. It is NOT documentation. It is NOT a README.

Purpose: Prevent mistakes by providing context the AI would otherwise lack.

What belongs in AGENTS.md:

- Domain knowledge that isn't obvious from code structure
- Constraints that cause silent failures if violated
- Architectural decisions that affect how code should be written
- References to detailed rules via @ imports

What does NOT belong:

- Commands (LLMs know how to run pnpm, npm, pytest, etc.)
- Generic best practices (LLMs already know these)
- Project descriptions (that's what README is for)
- Anything an LLM would figure out from reading the code

The test: "Would an AI make a mistake without this specific piece of context?" If no,
cut it. </philosophy>

<workflow>
<analyze-project>
Detect project type by checking `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, etc. Identify frameworks (Django vs FastAPI, React vs Next.js). Find test frameworks and build tools. Locate key directories (`src/`, `tests/`, etc.).
</analyze-project>

<include-always-apply-rules>
Critical: Scan `rules/` for rules with `alwaysApply: true` in frontmatter. These are the most important conventions - they apply to every task. Instead of extracting content, reference them directly.

Add an "Always Apply Rules" section at the top with @ references:

```markdown
## Always Apply Rules

Core project rules that apply to all tasks:

@rules/git-interaction.mdc @rules/typescript-coding-standards.mdc
```

Why use @ references instead of extraction:

- AI coding assistants load the full rule when they see `@path/to/rule.mdc`
- Ensures rules stay up-to-date without AGENTS.md edits
- No token overhead from duplicating rule content
- Single source of truth for all conventions

When to still extract (rare):

- Only if a rule has a specific command or constraint worth highlighting elsewhere
- Don't duplicate - reference in "Always Apply Rules" section instead
  </include-always-apply-rules>

<extract-key-context>
Read these sources for essential project-specific context:

From README.md:

- Project tech stack and versions (be specific: "Next.js 14" not just "Next.js")
- Key commands (dev, build, test)
- Skip: Project description, installation steps for end users, contributing guides

From .claude/context.md (if exists):

- Identity or personality instructions (if project uses custom personality)
- Any project-specific AI behavior guidelines

From recent git commits (last 10):

- Observe commit message style and conventions
- Identify patterns (emoji usage, conventional commits, etc.) </extract-key-context>

<generate-structure>
Create a structured file with these sections (omit sections with no valuable content):

```markdown
# Project Context for AI Assistants

## Always Apply Rules

Core project rules that apply to all tasks:

[@ references to your alwaysApply: true rules]

## Project Overview

Brief description of what this project is.

## Tech Stack

- Framework/language with specific versions
- Key dependencies that affect how code should be written
- Build tools and their commands

## Project Structure

- `dir/` - Brief purpose (only if non-obvious)
- Focus on where AI should look for specific types of files

## Code Conventions

DO:

- Specific patterns to follow
- Required practices unique to this project
- Non-obvious constraints that prevent mistakes

DON'T:

- Specific anti-patterns to avoid
- Project-specific constraints
- Explicitly forbidden practices (like --no-verify if that's a rule)

## Git Workflow

- Commit message format (if specific convention exists)
- Important: Include critical git constraints from always-apply rules
- Skip generic emoji lists - one example is enough
- Skip restating the full commit format if it's standard

## Important Notes

- Non-obvious gotchas or warnings
- Critical context that prevents mistakes
- Dependencies between systems
- Unique aspects of this project that AI must understand
```

</generate-structure>

<optimize-for-tokens>
After generating content, review and optimize:

1. Remove redundancy: If tech stack mentions "Node 20", don't repeat it elsewhere
2. Be concise: "Use pnpm not npm" instead of paragraph explaining why
3. Cut obvious fluff: Remove generic advice like "write good code"
4. Use examples sparingly: Only when they clarify non-obvious patterns
5. Cut generic commands: Remove `git status`, `git diff`, basic npm/pip commands
6. Skip emoji lists: One example format is enough, don't list all possible emojis
7. Remove meta-commentary: Cut self-referential notes about token usage or file purpose
8. Question each bullet: Ask "Would removing this cause AI to make a mistake?" If no,
   cut it.

Target conciseness over arbitrary size limits. </optimize-for-tokens>

<create-symlink>
Create a symlink from `CLAUDE.md` to `AGENTS.md`:

```bash
ln -sf AGENTS.md CLAUDE.md
```

This ensures both filenames work while maintaining a single source of truth without any
token overhead. </create-symlink>

<report>
After creating the root AGENTS.md, STOP. Show the user what was created. Then use
AskUserQuestion to ask if they want to review subdirectories. Do not proceed to
subdirectory review without explicit approval.

If yes, proceed to <subdirectory-agents> and follow the interactive flow there.
</report> </workflow>

<update-mode>
When `AGENTS.md` already exists:

1. Read existing file to understand current content
2. Analyze project for changes:
   - New dependencies in package files
   - New "always apply" rules added
   - Updated commands or conventions
3. Suggest additions or updates with rationale
4. Show diff of proposed changes
5. Let user approve before updating

Never silently overwrite - always show what's changing and why. </update-mode>

<key-principles>
Be surgical, not comprehensive: Extract only what AI needs that isn't obvious. Skip generic best practices.

Prioritize always-apply rules: These are gold - they represent project-critical
conventions.

Token economics matter: Be ruthless about value-per-byte.

Test the hypothesis: Ask yourself "Would this prevent a mistake I've seen AI make?" If
no, cut it.

Avoid restating README: If README explains it well, don't duplicate it here.
</key-principles>

<exclusion-list>
What does NOT belong in AGENTS.md:
- Generic commands (LLMs know how to run npm install, git status, pytest, etc.)
- Project descriptions and marketing copy (that's for README)
- Installation instructions
- Generic best practices AI already knows
- Obvious directory purposes (like `tests/` contains tests)
- API documentation (link to it instead)
- Emoji reference lists
- Meta-commentary about the AGENTS.md file itself
- Anything an LLM would figure out from reading the code

Exception: Project-specific tooling choices that prevent mistakes DO belong:

- "Use pnpm not npm" (prevents lockfile conflicts)
- "Use bun drizzle-kit not npx drizzle-kit" (project convention) </exclusion-list>

<subdirectory-agents>
This section only runs if the user approves subdirectory review after root AGENTS.md is
created.

Subdirectory AGENTS.md files provide domain knowledge for directories with specific
constraints that differ from root context.

## Discovery Process

Scan for candidates by checking:

1. **Directory-scoped cursor rules**: Rules in `rules/` with `globs` patterns targeting
   specific directories (e.g., `globs: ["tests/**"]`, `globs: ["src/db/**"]`)

2. **High-risk directories**: Places where AI mistakes are costly or common:
   - `migrations/`, `drizzle/migrations/`, `prisma/migrations/` - Never edit manually
   - `generated/`, `__generated__/` - Don't modify generated code
   - `vendor/`, `node_modules/` - External dependencies
   - `.github/workflows/` - CI/CD with specific syntax requirements

3. **Directories with their own tooling**: Subdirectories that have independent:
   - Package files (`package.json`, `pyproject.toml`)
   - Config files suggesting different conventions
   - README files with directory-specific instructions

4. **Test directories**: If project has testing-specific cursor rules, the test
   directory benefits from an AGENTS.md referencing those rules

## Interactive Flow

After root AGENTS.md, offer subdirectory review. Present candidates one at a time with
proposed content. Get user approval before creating each file. Use AskUserQuestion for
decisions to minimize typing.

## Subdirectory AGENTS.md Structure

Keep these minimal. They inherit root context, so only include:

```markdown
# [Directory Purpose]

[One sentence: what this contains and why AI needs to know]

[The critical constraint or domain knowledge - often a warning about what NOT to do]

@rules/relevant-rule.mdc
```

No commands. No generic descriptions. Just the context that prevents mistakes.

Example for migrations directory:

```markdown
# Database Migrations

Auto-generated files tracked by Drizzle's journal system.

**NEVER manually create or edit migration files.** They must be generated via
`drizzle-kit generate` from schema changes in `lib/db/schema.ts`. Manually created files
exist but never run — they fail silently.

@rules/drizzle-database-migrations.mdc
```

## Matching Rules to Directories

When a cursor rule has `globs` patterns, map them to directories:

- `globs: ["tests/**", "**/*.test.ts"]` → `tests/AGENTS.md`
- `globs: ["src/components/**"]` → `src/components/AGENTS.md`
- `globs: ["*.sql", "drizzle/**"]` → `drizzle/AGENTS.md`

Include the rule as an @ reference in that subdirectory's AGENTS.md.

## Skip If

Don't create subdirectory AGENTS.md when:

- The constraint is already clear from filenames/structure
- Root AGENTS.md already covers the directory adequately
- The directory is rarely touched by AI
- Adding context wouldn't prevent any realistic mistake
- `.cursor/` or `.claude/` already have AGENTS.md from ai-coding-config (these explain
  how to write rules/commands and reference prompt-engineering.mdc)

## Symlinks

Create `CLAUDE.md` symlink in each subdirectory too:

```bash
cd path/to/subdir && ln -sf AGENTS.md CLAUDE.md
```

</subdirectory-agents>

<final-checklist>
- Contains only domain knowledge and constraints AI can't infer from code
- No commands (LLMs know how to run tools)
- No generic descriptions or README-style content
- @ references to rules rather than duplicating content
- Each item passes: "Would AI make a mistake without this?"
- Created CLAUDE.md symlink
- Offered subdirectory review
</final-checklist>

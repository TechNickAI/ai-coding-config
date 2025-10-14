# AI Coding Configuration - Implementation Plan

> **Updated**: Reflects proper understanding of Cursor vs Claude Code, rules vs
> commands, and agentic approach.

## 🎯 Vision

Create an **agentic AI coding infrastructure** that:

- Works seamlessly across N machines and N repositories
- Supports **Cursor (IDE + CLI)** and **Claude Code**
- Uses **AI to guide setup and updates** (not complex scripts)
- Focuses on **Python and TypeScript**
- Runs on **macOS and Linux** only

## 🧭 Key Principles

1. **Agentic First**: AI prompts guide setup, not bash scripts
2. **Rules ≠ Commands**: They serve completely different purposes
3. **Focus Matters**: Deep support for 2 tools + 2 languages, not shallow support for
   everything
4. **Single Source**: `~/.ai_coding_config` on every machine
5. **Git for Updates**: Pull changes, AI propagates them
6. **User Choice**: Always ask, never force

## 📚 Understanding the Ecosystem

**Before implementing, read**: [docs/coding-ecosystem.md](docs/coding-ecosystem.md)

### The Tools We Support

**Cursor IDE**:

- AI-powered code editor (VS Code fork)
- Uses `.cursor/rules/*.mdc` - context/guidelines (HOW to code)
- Rules are passive - guide AI decisions
- Invocation: `@rule-name` or auto-applied

**Cursor CLI**:

- Command-line interface for CI/CD
- Uses same `.cursor/rules/` as IDE
- Same context, different interface
- Non-interactive operations

**Claude Code**:

- Anthropic's agentic command-line tool
- Uses `.claude/commands/*.md` - executable workflows (WHAT to do)
- Commands are active - run tests, lint, deploy
- Invocation: `/command-name`
- MCP server support

**Critical**: Rules and commands are NOT interchangeable! See
[docs/tools-and-configs.md](docs/tools-and-configs.md)

## 🏗️ Repository Architecture

```
~/.ai_coding_config/          # Cloned on every machine
├── .cursor/
│   ├── rules/                # Context for Cursor (IDE + CLI)
│   │   ├── python/          # Existing: coding standards, patterns
│   │   ├── django/          # Existing: framework conventions
│   │   └── ...              # Existing: git, observability, etc.
│   └── settings.json        # NEW: IDE & CLI preferences
│
├── .claude/                  # NEW: Claude Code configs
│   ├── commands/            # Executable workflows (test, lint, etc.)
│   ├── agents/              # Agent definitions (frontmatter)
│   └── settings.json        # Extension preferences
│
├── .mcp/                     # NEW: MCP server management
│   ├── servers/
│   │   ├── development/     # Dev tools (filesystem, github)
│   │   ├── data/            # Data sources (postgresql, sqlite)
│   │   └── external/        # External services (brave-search)
│   └── templates/           # Config templates
│
├── .github/workflows/        # NEW: Reusable workflows
│   ├── python-quality.yml
│   ├── python-test.yml
│   ├── typescript-quality.yml
│   └── typescript-test.yml
│
├── prompts/                  # NEW: AI setup prompts
│   ├── bootstrap.md         # Initial setup guidance
│   ├── project-setup.md     # New project configuration
│   ├── sync-updates.md      # Update existing projects
│   └── select-features.md   # Feature selection helper
│
├── scripts/                  # NEW: Minimal automation
│   ├── bootstrap.sh         # Entry point (downloads, runs AI)
│   └── install-tools.sh     # Tool installation helpers
│
├── templates/                # NEW: Project templates
│   ├── python/              # Django, FastAPI, pytest setup
│   ├── typescript/          # React, Node, Jest setup
│   └── .env.template        # Environment variable template
│
└── docs/                     # Documentation
    ├── coding-ecosystem.md  # Which tools? What's supported?
    ├── tools-and-configs.md # Rules vs Commands explained
    └── ...                  # Additional guides
```

## 🚀 The Agentic Approach

### Why AI-Guided Setup?

**Old Way** (complex scripts):

```bash
# Try to handle every case with bash
./setup.sh --python --typescript --mcp=github,postgresql --workflows=ci,cd
# 500 lines of bash, still breaks on edge cases
```

**New Way** (AI prompts):

```bash
# Minimal bootstrap
curl -fsSL .../bootstrap.sh | bash
# → AI reads prompts and guides you through setup
```

**Benefits**:

- **Flexible**: AI handles edge cases naturally
- **Interactive**: You make choices, AI executes
- **Self-documenting**: Prompts explain as they go
- **Evolving**: Prompts improve over time
- **Consistent**: Same prompts work everywhere

### The Three Workflows

#### 1. New Machine Setup

```bash
curl -fsSL https://raw.githubusercontent.com/TechNickAI/ai-coding-config/main/scripts/bootstrap.sh | bash
```

**Bootstrap script** (minimal):

1. Detect OS (macOS/Linux - NO Windows)
2. Check for AI coding tools:
   - **Cursor CLI**: Check if `cursor` command exists
   - **Claude Code**: Check if `claude` command exists
   - If missing, show installation instructions
3. Check required tools (node, python, git)
4. Install missing dependencies (with permission)
5. Clone repo to `~/.ai_coding_config`
6. Run AI with `prompts/bootstrap.md`

**Installation Instructions** (if tools missing):

For **Cursor CLI**:

```bash
# macOS
brew install --cask cursor

# Then enable CLI from Cursor IDE:
# Cmd+Shift+P → "Shell Command: Install 'cursor' command in PATH"

# Or download from: https://cursor.com
```

For **Claude Code**:

```bash
# Install via npm (requires Node.js)
npm install -g @anthropic-ai/claude-code

# Or download from: https://www.anthropic.com/claude/code
```

**Note**: User doesn't need both tools. Script should:

- Detect which tools they have
- Ask which tools they want to use
- Only require tools they plan to use
- Proceed if at least one is installed

**AI guides you** through:

- Tool detection: Which AI tools are installed?
- Tool preference: Which do you want to configure?
- Primary language (Python/TypeScript/both)
- API key setup (based on tools chosen):
  - Anthropic API key (required for Claude Code)
  - OpenAI API key (optional for Cursor)
  - GitHub token (for MCP servers)
- MCP server selection
- Validation and testing

#### 2. New Project Setup

```bash
cd ~/your-new-project
cursor chat < ~/.ai_coding_config/prompts/project-setup.md
# or
claude code < ~/.ai_coding_config/prompts/project-setup.md
```

**AI helps you**:

- Detect project type (Python/TypeScript/both)
- Select Cursor rules to include
- Select Claude Code commands to include
- Configure MCP servers for this project
- Set up GitHub workflows
- Create environment files
- Initialize git if needed

#### 3. Update Existing Projects

```bash
# Update config repo
cd ~/.ai_coding_config && git pull

# Sync to your project
cd ~/your-project
cursor chat < ~/.ai_coding_config/prompts/sync-updates.md
```

**AI shows you**:

- What changed in config repo
- Which changes are relevant to this project
- Applies updates selectively
- Validates everything works
- Optionally commits changes

## 📋 Implementation Features

### 1. Cursor Configurations ✅ (Mostly Exists)

**What we have**:

- ✅ Comprehensive rules in `.cursor/rules/`
- ✅ Python standards, Django patterns, git conventions
- ✅ Observability, testing, frontend rules

**What we need**:

- [ ] `.cursor/settings.json` with best practices
- [ ] Document Cursor CLI usage patterns
- [ ] Add more language-specific rules as needed

**Deliverables**:

- Create `cursor/settings.json` template
- Document IDE vs CLI usage
- Add examples for common workflows

---

### 2. Claude Code Configurations 🆕 (New)

**Commands to create** (`.claude/commands/*.md`):

**Python**:

- `python-test.md` - Run pytest with coverage
- `python-lint.md` - Run ruff check
- `python-format.md` - Run ruff format
- `python-type.md` - Run mypy
- `django-migrate.md` - Run migrations
- `django-shell.md` - Open Django shell

**TypeScript**:

- `typescript-test.md` - Run Jest/Vitest
- `typescript-lint.md` - Run ESLint
- `typescript-format.md` - Run Prettier
- `typescript-type.md` - Run tsc
- `typescript-build.md` - Build project

**Universal**:

- `review-code.md` - AI code review
- `explain-code.md` - Explain complex code
- `generate-docs.md` - Create documentation
- `security-scan.md` - Check for vulnerabilities

**Agents to create** (`.claude/agents/*.md`):

- `test-writer.md` - Generate comprehensive tests
- `code-reviewer.md` - Review code quality
- `doc-writer.md` - Write documentation
- `refactorer.md` - Suggest refactorings

**Format** (markdown with frontmatter):

```markdown
---
name: python-test
description: Run Python tests with pytest
languages: [python]
requires: [pytest]
---

# Run Python Tests

Execute your test suite with pytest and show coverage.

## What this does

1. Activates virtual environment if present
2. Runs pytest with coverage
3. Shows coverage report
4. Highlights failed tests

## Usage

Type `/python-test` to run all tests.

Options:

- `/python-test --file path/to/test.py` - Run specific file
- `/python-test --verbose` - Show detailed output
```

**Deliverables**:

- Create 20-30 commands (10-15 per language)
- Create 5-10 agent definitions
- Test all commands work
- Document command patterns

---

### 3. MCP Server Management 🆕 (New)

**Server Categories**:

**Development** (`.mcp/servers/development/`):

- `filesystem.json` - File system operations
- `github.json` - GitHub integration
- `memory.json` - Persistent memory

**Data** (`.mcp/servers/data/`):

- `postgresql.json` - PostgreSQL database
- `sqlite.json` - SQLite database
- `redis.json` - Redis cache

**External** (`.mcp/servers/external/`):

- `brave-search.json` - Web search
- `slack.json` - Slack integration

**Config Format**:

```json
{
  "description": "GitHub repository operations",
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-github"],
  "env": {
    "GITHUB_TOKEN": "${GITHUB_TOKEN}"
  },
  "platforms": ["macos", "linux"],
  "languages": ["python", "typescript"],
  "required": false,
  "docs": "https://github.com/modelcontextprotocol/servers"
}
```

**Aggregation**:

```bash
# Generate claude_desktop_config.json from selected servers
~/.ai_coding_config/scripts/generate-mcp-config.py \
  --servers filesystem,github,postgresql \
  --output ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

**Deliverables**:

- Add 10-15 popular MCP servers
- Create aggregation script
- Add to bootstrap and project-setup prompts
- Document each server's purpose

---

### 4. AI Prompts System 🆕 (New - Critical!)

**`prompts/bootstrap.md`**:

```markdown
# AI Coding Configuration - Bootstrap

You are helping set up ai-coding-config for the first time.

## Context

- OS: {{OS_TYPE}}
- Tools Found: {{TOOLS_INSTALLED}}
  - Cursor CLI: {{CURSOR_CLI_VERSION}} or "Not installed"
  - Claude Code: {{CLAUDE_CODE_VERSION}} or "Not installed"
- Location: ~/.ai_coding_config

## Your Tasks

1. Welcome and explain (1-2 min setup)

2. Check tool availability:
   - If no tools installed: Show installation instructions and pause
   - If one tool: Configure that tool
   - If both tools: Ask which to configure (can do both)

3. Ask about usage:
   - Primary language? (Python/TypeScript/both)
   - Use cases? (personal/work/both)

4. Guide API key setup (based on tools detected):
   - Anthropic API key (required if using Claude Code)
   - OpenAI API key (optional if using Cursor)
   - GitHub token (for MCP servers)
   - Show how to get each key
   - Test keys work before proceeding

5. Configure MCP servers (if using Claude Code):
   - Based on language choice
   - Based on use case
   - Let user select

6. Validate:
   - Test API keys work
   - Test MCP servers connect
   - Test tools can access config

7. Next steps:
   - Show which tools are configured
   - Offer to set up first project
   - Show quick reference card
   - Explain update process
   - Point to relevant docs based on tools chosen

Be conversational, helpful, and encouraging!
```

**`prompts/project-setup.md`**:

```markdown
# Project Configuration Setup

Help configure this project with ai-coding-config.

## Analyze Project

1. Detect:
   - Language (Python/TypeScript/both)
   - Framework (Django/FastAPI/React/etc)
   - Existing config (if any)

2. Check:
   - Git repository?
   - Virtual environment?
   - Package files?

## Ask User

1. Cursor rules:
   - Show recommendations for detected stack
   - Let user add/remove

2. Claude Code commands:
   - Show relevant commands
   - Explain what each does

3. MCP servers:
   - Based on stack (e.g., PostgreSQL for Django)
   - Based on needs

4. GitHub workflows:
   - Testing, quality, security
   - Can add later

## Execute

1. Create directories
2. Symlink or copy selected files
3. Create .env templates
4. Set up .gitignore
5. Configure MCP if using Claude Code

## Validate

1. Test configuration loads
2. Try a rule/command
3. Check secrets aren't committed

## Guide Next Steps

- Show how to use rules (`@rule-name`)
- Show how to use commands (`/command-name`)
- Explain how to update later
- Point to documentation
```

**`prompts/sync-updates.md`**:

```markdown
# Sync Configuration Updates

Help update this project with latest changes from ai-coding-config.

## Check Status

1. Compare versions:
   - Config repo version
   - Project version
   - What changed?

2. Analyze changes:
   - New rules/commands
   - Updated rules/commands
   - Deleted rules/commands
   - Changed MCP servers

## Present Changes

For each change:

1. Explain what it is
2. Why it might be useful
3. Whether it's relevant to this project
4. Recommend apply/skip

## Apply Updates

1. Backup current config
2. Apply selected changes
3. Merge carefully (preserve customizations)
4. Update version marker

## Validate

1. Test everything still works
2. Run a command
3. Check MCP servers
4. Offer to commit

## Report

- Summary of changes
- What was skipped and why
- Suggested actions
```

**Deliverables**:

- Write all three core prompts
- Add helper prompts (select-features, troubleshoot, etc.)
- Test prompts with real workflows
- Iterate based on usage

---

### 5. GitHub Workflows 🆕 (New)

**Python Workflows**:

`.github/workflows/python-quality.yml`:

```yaml
name: Python Quality

on: [push, pull_request]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
      - name: Install dependencies
        run: |
          pip install ruff mypy
      - name: Lint with ruff
        run: ruff check .
      - name: Type check with mypy
        run: mypy .
```

`.github/workflows/python-test.yml`:

```yaml
name: Python Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ["3.11", "3.12"]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
      - name: Install dependencies
        run: |
          pip install -e ".[dev]"
      - name: Run tests
        run: |
          pytest --cov --cov-report=xml
      - name: Upload coverage
        uses: codecov/codecov-action@v4
```

**TypeScript Workflows**:

`.github/workflows/typescript-quality.yml`:

```yaml
name: TypeScript Quality

on: [push, pull_request]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "20"
      - name: Install dependencies
        run: npm ci
      - name: Lint
        run: npm run lint
      - name: Type check
        run: npm run type-check
```

**Deliverables**:

- Create 5-7 reusable workflows
- Make them customizable (matrix builds, etc.)
- Add examples for each
- Document usage patterns

---

### 6. Environment Management 🆕 (New)

**Templates**:

`.env.template` (Python):

```bash
# AI API Keys
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...

# MCP Servers
GITHUB_TOKEN=ghp_...

# Python Development
DATABASE_URL=postgresql://localhost/dbname
REDIS_URL=redis://localhost:6379
SECRET_KEY=your-secret-key

# Django Specific (if using Django)
DJANGO_SETTINGS_MODULE=config.settings
DEBUG=True
```

`.env.template` (TypeScript):

```bash
# AI API Keys
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...

# MCP Servers
GITHUB_TOKEN=ghp_...

# Node.js Development
NODE_ENV=development
DATABASE_URL=postgresql://localhost/dbname
REDIS_URL=redis://localhost:6379

# API Keys
JWT_SECRET=your-jwt-secret
```

**Deliverables**:

- Create language-specific templates
- Document all variables
- Add validation in prompts
- Include in project-setup

---

### 7. Documentation 📚 (Ongoing)

**Existing**:

- ✅ coding-ecosystem.md - Tool comparison
- ✅ tools-and-configs.md - Rules vs commands
- ✅ architecture-summary.md - System overview

**Need to create**:

- [ ] getting-started.md - Quick start guide
- [ ] cursor-guide.md - Using Cursor effectively
- [ ] claude-code-guide.md - Using Claude Code effectively
- [ ] mcp-guide.md - Setting up MCP servers
- [ ] python-setup.md - Python project setup
- [ ] typescript-setup.md - TypeScript project setup
- [ ] troubleshooting.md - Common issues
- [ ] faq.md - Frequently asked questions

**Deliverables**:

- Write all core documentation
- Add examples throughout
- Keep updated with changes
- Make it scannable (headers, bullets)

---

## 🎯 Implementation Phases

### Phase 1: Foundation

**Goal**: Get basic agentic setup working

**Tasks**:

- [ ] Create directory structure
- [ ] Write bootstrap.sh (minimal)
- [ ] Write prompts/bootstrap.md
- [ ] Write prompts/project-setup.md
- [ ] Write prompts/sync-updates.md
- [ ] Test on macOS and Linux

**Success**: Can run bootstrap and AI guides setup

### Phase 2: Cursor Enhancements

**Goal**: Enhance existing Cursor support

**Tasks**:

- [ ] Create .cursor/settings.json template
- [ ] Document Cursor CLI usage
- [ ] Add any missing Python/TypeScript rules
- [ ] Test rules with real projects

**Success**: Cursor works great with our configs

### Phase 3: Claude Code Support

**Goal**: Full Claude Code integration

**Tasks**:

- [ ] Create 20-30 commands in .claude/commands/
- [ ] Create 5-10 agents in .claude/agents/
- [ ] Create .claude/settings.json template
- [ ] Test all commands work
- [ ] Integrate with prompts

**Success**: Claude Code has full command library

### Phase 4: MCP & Workflows

**Goal**: Complete the ecosystem

**Tasks**:

- [ ] Add 10-15 MCP server configs
- [ ] Create aggregation script
- [ ] Create GitHub workflow templates
- [ ] Create environment templates
- [ ] Test everything together

**Success**: Full stack works end-to-end

### Phase 5: Documentation & Polish

**Goal**: Make it accessible to others

**Tasks**:

- [ ] Complete all documentation
- [ ] Add examples for everything
- [ ] Test on fresh machines
- [ ] Test across multiple projects
- [ ] Refine based on real usage

**Success**: Others can use it successfully

---

## 📊 Success Criteria

### Setup Experience

- New machine: < 10 minutes
- New project: < 5 minutes
- Update project: < 3 minutes
- All guided by AI, not scripts

### Consistency

- Same setup across all machines
- Easy to keep projects in sync
- Minimal manual intervention
- Git tracks everything

### Quality

- Rules guide good code
- Commands automate workflows
- MCP servers enhance capabilities
- CI/CD catches issues

### Usability

- Clear documentation
- Helpful error messages
- Easy to customize
- Works reliably

---

## 🔑 Key Design Decisions

### 1. Agentic > Scripts

AI prompts guide setup instead of complex bash scripts. More flexible, self-documenting,
handles edge cases.

### 2. Rules ≠ Commands

Cursor rules provide context (HOW to code). Claude commands execute workflows (WHAT to
do). Never confuse them.

### 3. Cursor IDE + CLI Share Config

Both use `.cursor/rules/`. CLI is just non-interactive interface to same AI.

### 4. Focus on 2 Tools + 2 Languages

Deep support for Cursor + Claude Code + Python + TypeScript. Not shallow support for
everything.

### 5. macOS + Linux Only

No Windows support. Keep it simple, we use Unix systems.

### 6. Single Source on Each Machine

`~/.ai_coding_config` contains everything. Git pull updates it. AI propagates changes to
projects.

### 7. User Choice Always

Never force configurations. AI always asks before applying changes.

---

## 🚫 What We're NOT Doing

- ❌ Windows support (complexity)
- ❌ Enterprise features (not needed)
- ❌ Web dashboard (silly)
- ❌ CLI management tool (just bootstrap + prompts)
- ❌ Windsurf support (too similar to Cursor)
- ❌ Generic VS Code (different ecosystem)
- ❌ Many languages (focused on Python/TypeScript)
- ❌ Complex scripts (AI prompts instead)

---

## 📝 Next Steps

1. **Review this plan**
   - Does it make sense?
   - Anything missing?
   - Priorities correct?

2. **Start Phase 1**
   - Create directories
   - Write bootstrap script
   - Write AI prompts
   - Test on real machine

3. **Iterate**
   - Use it ourselves
   - Fix what breaks
   - Improve prompts
   - Add features as needed

---

## 📚 Related Documentation

- [coding-ecosystem.md](docs/coding-ecosystem.md) - Which tools? What's supported?
- [tools-and-configs.md](docs/tools-and-configs.md) - Rules vs Commands
- [architecture-summary.md](docs/architecture-summary.md) - System architecture
- [plan-summary.md](docs/plan-summary.md) - Quick overview
- [README.md](README.md) - Repository front page

---

_This plan reflects our understanding as of October 2025. It will evolve as we build and
learn._

# Setting Up /troubleshoot Command

## Quick Start

### 1. Configure MCP Server

Create `.mcp.json` in your project root:

```json
{
  "mcpServers": {
    "sentry": {
      "url": "https://mcp.sentry.dev/mcp"
    }
  }
}
```

(Or use `"honeybadger"` with `https://mcp.honeybadger.io/mcp`)

### 2. Symlink for Cursor Compatibility

If you use both Claude Code and Cursor:

```bash
ln -s ../.mcp.json .cursor/mcp.json
```

This ensures both tools share the same MCP configuration.

### 3. Connect Error Monitoring Service

- **Sentry:** https://mcphubby.ai/integrations/sentry
- **HoneyBadger:** https://mcphubby.ai/integrations/honeybadger

Click "Connect" and authorize MCP Hubby to access your account.

### 4. Install the Command

From ai-coding-config repo:

```bash
ln -s ../ai-coding-config/.claude/commands/troubleshoot.md .claude/commands/troubleshoot.md
```

### 5. Run It

```bash
/troubleshoot
```

The AI will autonomously fix production errors!

## What Happens

1. AI detects which error monitoring service is connected
2. Fetches all unresolved errors
3. Groups errors by root cause (cluster analysis)
4. Calculates priority scores (recency + frequency + impact + blast radius)
5. Fixes highest priority errors in isolated git worktrees
6. Operates in parallel (multiple fixes simultaneously)
7. Submits PRs with full context
8. Monitors deployment and verifies fixes

## Advanced Usage

```bash
/troubleshoot auto 5   # Fix top 5 bugs in parallel
/troubleshoot watch    # Continuous monitoring mode
/troubleshoot analyze  # Pattern analysis only
/troubleshoot 3        # Fix specific bug by priority rank
```

## Architecture

```
Project Root/
├── .mcp.json                          # MCP server config (source of truth)
├── .cursor/
│   └── mcp.json -> ../.mcp.json      # Symlink for Cursor
├── .claude/
│   └── commands/
│       └── troubleshoot.md -> ...     # Command symlink
└── .cursor/rules/
    ├── git-worktree-task.mdc         # Worktree workflow
    └── git-commit-message.md         # Commit standards
```

## Why This Approach

**Unified Configuration:** `.mcp.json` is the single source. Both Claude Code and Cursor
symlink to it.

**AI-First Design:** The command trusts the AI to make intelligent decisions.
Goal-focused, not prescriptive.

**Parallel Workflows:** Multiple bugs fixed simultaneously in isolated worktrees. Much
faster than sequential fixing.

**Pattern Recognition:** AI clusters related errors and fixes root causes, not just
symptoms.

**Autonomous Operation:** No hand-holding needed. AI operates continuously until
production is clean.

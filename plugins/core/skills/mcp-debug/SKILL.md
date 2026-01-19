---
name: mcp-debug
# prettier-ignore
description: "Debug and test MCP servers directly from Claude Code - call tools, list capabilities, diagnose issues without going through the full LLM stack"
version: 1.0.0
---

<objective>
Enable Claude to directly test and debug MCP servers during development sessions. This
skill bypasses the full Carmenta LLM stack to call MCP tools directly, see raw responses,
and diagnose issues in real-time.
</objective>

<when-to-use>
Use this skill when:
- Testing an MCP server during development (like machina)
- Debugging why an MCP tool isn't returning expected data
- Exploring what operations an MCP server supports
- Verifying MCP server connectivity and auth
- Working across both Carmenta and MCP server repos simultaneously
</when-to-use>

<prerequisites>
This skill uses `mcptools` (https://github.com/f/mcptools) for MCP communication.

Before using MCP debug commands, ensure mcptools is installed:

```bash
# Check if installed
which mcp || which mcpt

# Install via Homebrew (macOS)
brew tap f/mcptools && brew install mcp

# Or via Go
go install github.com/f/mcptools/cmd/mcptools@latest
```

If mcptools is not found, install it first before proceeding. </prerequisites>

<config-discovery>
MCP server configs can come from multiple sources:

1. **Claude Code config**: `~/.config/claude/claude_desktop_config.json`
2. **Direct URL**: `http://localhost:9900` with optional auth
3. **mcptools aliases**: Previously saved with `mcp alias add`

To find available servers:

```bash
# Scan all known config locations
mcp configs scan

# List saved aliases
mcp alias list
```

</config-discovery>

<commands>

## List Tools

See what tools/operations an MCP server provides:

```bash
# HTTP server with bearer auth
mcp tools http://localhost:9900 --headers "Authorization=Bearer $MACHINA_TOKEN"

# Using an alias
mcp tools machina

# Pretty JSON output
mcp tools --format pretty http://localhost:9900
```

## Call a Tool

Execute an MCP tool directly with parameters:

```bash
# Call with JSON params
mcp call describe --params '{"action":"describe"}' http://localhost:9900 \
  --headers "Authorization=Bearer $MACHINA_TOKEN"

# Gateway-style (single tool with action param)
mcp call machina --params '{"action":"messages_recent","params":{"limit":5}}' \
  http://localhost:9900 --headers "Authorization=Bearer $MACHINA_TOKEN"

# Format output as pretty JSON
mcp call tool_name --params '{}' --format pretty http://localhost:9900
```

## Interactive Shell

Open persistent connection for multiple commands:

```bash
mcp shell http://localhost:9900 --headers "Authorization=Bearer $MACHINA_TOKEN"

# Then in shell:
# mcp> tools
# mcp> call describe --params '{"action":"describe"}'
```

## Web Interface

Visual debugging in browser:

```bash
mcp web http://localhost:9900 --headers "Authorization=Bearer $MACHINA_TOKEN"
# Opens http://localhost:41999
```

</commands>

<machina-specific>

## Machina MCP Server

Machina runs on Nick's Mac and exposes macOS capabilities via MCP.

**Default endpoint**: `http://localhost:9900` (or via Tailscale) **Auth**: Bearer token
from `MACHINA_TOKEN` env var

### Gateway Pattern

Machina uses progressive disclosure - single `machina` tool with `action` parameter:

```bash
# List all operations
mcp call machina --params '{"action":"describe"}' http://localhost:9900 \
  --headers "Authorization=Bearer $MACHINA_TOKEN"

# Call specific operation
mcp call machina --params '{"action":"messages_recent","params":{"limit":5}}' \
  http://localhost:9900 --headers "Authorization=Bearer $MACHINA_TOKEN"
```

### Available Operations (31 total)

**Messages**: send, read, recent, search, conversations **Notes**: list, read, create,
search **Reminders**: list, create, complete **Contacts**: search, get **WhatsApp**:
send, chats, messages, search, contacts, status, raw_sql **System**: update, status
**Advanced**: raw_applescript

### Common Debug Commands

```bash
# Check if machina is responding
curl -s http://localhost:9900/health

# List all tools via mcptools
mcp tools http://localhost:9900 --headers "Authorization=Bearer $MACHINA_TOKEN"

# Get operation descriptions
mcp call machina --params '{"action":"describe"}' --format pretty \
  http://localhost:9900 --headers "Authorization=Bearer $MACHINA_TOKEN"

# Test messages (requires Full Disk Access)
mcp call machina --params '{"action":"messages_recent","params":{"limit":3}}' \
  --format pretty http://localhost:9900 --headers "Authorization=Bearer $MACHINA_TOKEN"

# Test contacts (requires Contacts permission)
mcp call machina --params '{"action":"contacts_search","params":{"query":"Mom"}}' \
  --format pretty http://localhost:9900 --headers "Authorization=Bearer $MACHINA_TOKEN"
```

</machina-specific>

<troubleshooting>

## Common Issues

**Connection refused**

- Check if server is running: `curl http://localhost:9900/health`
- Check LaunchD: `launchctl list | grep machina`
- Check logs: `tail -20 ~/machina/logs/gateway-stderr.log`

**401 Unauthorized**

- Verify token: `echo $MACHINA_TOKEN`
- Check mcptools header syntax: `Authorization=Bearer` (mcptools uses `=`, HTTP uses
  `:`)

**Tool not found**

- Machina uses gateway pattern - call `machina` tool with `action` param
- Not direct tool names like `messages_send`

**Empty/error results**

- Check macOS permissions (Full Disk Access, Automation)
- Run `~/machina/test-permissions.ts` to diagnose
- Check server logs for AppleScript errors

**mcptools not found**

- Install: `brew tap f/mcptools && brew install mcp`
- Or: `go install github.com/f/mcptools/cmd/mcptools@latest`

</troubleshooting>

<workflow>

## Typical Debug Session

1. **Verify connectivity**

   ```bash
   curl -s http://localhost:9900/health
   ```

2. **List available tools**

   ```bash
   mcp tools http://localhost:9900 --headers "Authorization=Bearer $MACHINA_TOKEN"
   ```

3. **Get operation descriptions**

   ```bash
   mcp call machina --params '{"action":"describe"}' --format pretty \
     http://localhost:9900 --headers "Authorization=Bearer $MACHINA_TOKEN"
   ```

4. **Test specific operation**

   ```bash
   mcp call machina --params '{"action":"messages_recent","params":{"limit":3}}' \
     --format pretty http://localhost:9900 --headers "Authorization=Bearer $MACHINA_TOKEN"
   ```

5. **If issues, check logs**
   ```bash
   tail -50 ~/machina/logs/gateway-stderr.log
   ```

</workflow>

<output-interpretation>

## Reading MCP Results

MCP tools return JSON with this structure:

```json
{
  "content": [
    {
      "type": "text",
      "text": "{ ... actual result as JSON string ... }"
    }
  ]
}
```

The inner `text` field contains the actual result, often as a JSON string that needs
parsing. Use `jq` to extract:

```bash
mcp call machina --params '...' --format json http://localhost:9900 \
  --headers "Authorization=Bearer $MACHINA_TOKEN" \
  | jq -r '.content[0].text' | jq .
```

</output-interpretation>

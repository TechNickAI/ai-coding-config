#!/bin/bash
# SessionStart hook: Detect multiple active Claude Code sessions
# Touches a session file and counts active sessions (modified in last 2 hours)
# When 3+ active, outputs a reminder to re-ground context in responses

# Read JSON input from stdin
INPUT=$(cat)

# Extract session_id
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty')

if [ -z "$SESSION_ID" ]; then
    exit 0
fi

# Session tracking directory
SESSION_DIR="$HOME/.claude/sessions"
mkdir -p "$SESSION_DIR"

# Sanitize session_id to prevent path traversal — use only the basename
SESSION_FILE="$SESSION_DIR/$(basename "$SESSION_ID")"
touch "$SESSION_FILE"

# Count sessions modified in last 2 hours (find -mmin works on both macOS and Linux)
ACTIVE_COUNT=$(find "$SESSION_DIR" -type f -mmin -120 2>/dev/null | wc -l | tr -d ' ')

# Clean up sessions older than 24 hours
find "$SESSION_DIR" -type f -mmin +1440 -delete 2>/dev/null

# Threshold: 3+ sessions is where context-juggling becomes error-prone.
# Below 3, a user can reasonably track what each window is doing.
if [ "$ACTIVE_COUNT" -ge 3 ]; then
    echo "Multi-session mode: $ACTIVE_COUNT active Claude Code sessions detected. The user is juggling multiple windows — always include explicit context (repo name, branch, what we're working on) when reporting status or completing work."
fi

exit 0

#!/bin/bash
# PostToolUse hook for TodoWrite: Save todos in human-readable format
# Saves to Claude's existing project directory for restoration after compaction

# Read JSON input from stdin
INPUT=$(cat)

# Extract fields
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')

# Only process TodoWrite calls
if [ "$TOOL_NAME" != "TodoWrite" ]; then
    exit 0
fi

# Extract todos array from tool_input
TODOS=$(echo "$INPUT" | jq -r '.tool_input.todos // empty')

if [ -z "$TODOS" ] || [ "$TODOS" = "null" ] || [ -z "$TRANSCRIPT_PATH" ]; then
    exit 0
fi

# Use Claude's existing project directory (parent of transcript file)
PROJECT_DIR=$(dirname "$TRANSCRIPT_PATH")

# Convert to readable markdown
{
    echo "# Saved Todos"
    echo ""
    echo "Updated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
    echo ""

    # Group by status
    for status in "in_progress" "pending" "completed"; do
        items=$(echo "$TODOS" | jq -r --arg s "$status" '.[] | select(.status == $s) | .content')
        if [ -n "$items" ]; then
            case $status in
                in_progress) echo "## In Progress" ;;
                pending) echo "## Pending" ;;
                completed) echo "## Completed" ;;
            esac
            echo ""
            echo "$items" | while read -r item; do
                [ -n "$item" ] && echo "- $item"
            done
            echo ""
        fi
    done
} > "$PROJECT_DIR/todos.md"

exit 0

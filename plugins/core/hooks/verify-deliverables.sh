#!/bin/bash
# SubagentStop hook: verify-deliverables
#
# Cross-references the subagent's recent activity against its completion claims.
# When the subagent says it finished work but the tool-call record or filesystem
# disagree, this hook surfaces the discrepancy to the parent agent via
# hookSpecificOutput.additionalContext.
#
# Always advisory, never blocks. Exits 0 in every path so a hook bug cannot
# break the harness. See plugins/core/hooks/README.md for design notes.
#
# Issue: https://github.com/TechNickAI/ai-coding-config/issues/51

set -u

# Kill switch for opt-out without uninstalling.
[ "${VERIFY_DELIVERABLES_DISABLED:-}" = "1" ] && exit 0

# Hook depends on jq for JSON parsing. If jq is missing, fail open silently
# rather than producing a non-zero exit that disrupts the harness.
command -v jq >/dev/null 2>&1 || exit 0

# --- Read input ---

INPUT=$(cat)
[ -z "$INPUT" ] && exit 0

TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty' 2>/dev/null)
STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false' 2>/dev/null)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty' 2>/dev/null)
[ -z "$CWD" ] && CWD="$(pwd)"

# Escape hatch: hook already fired this stop cycle. Prevents loops.
[ "$STOP_HOOK_ACTIVE" = "true" ] && exit 0

# Fail-open: no readable transcript -> silent pass.
[ -z "$TRANSCRIPT_PATH" ] && exit 0
[ ! -r "$TRANSCRIPT_PATH" ] && exit 0

# --- Slice recent activity ---

# 200 entries handles subagents that ran many Read calls between an early
# Write and a final summary, while still bounding parse time.
RECENT=$(tail -n 200 "$TRANSCRIPT_PATH" 2>/dev/null)
[ -z "$RECENT" ] && exit 0

# --- Extract signals ---

LAST_ASSISTANT=$(echo "$RECENT" | jq -c 'select(.type == "assistant")' 2>/dev/null | tail -n 1)
LAST_MSG=$(echo "$LAST_ASSISTANT" | jq -r '.message.content[]? | select(.type == "text") | .text' 2>/dev/null)

# Mutating tool calls in the recent slice.
MUTATING_CALLS=$(echo "$RECENT" | jq -r '
    select(.type == "assistant")
    | .message.content[]?
    | select(.type == "tool_use")
    | select(.name == "Write" or .name == "Edit" or .name == "MultiEdit" or .name == "NotebookEdit")
    | .name
' 2>/dev/null | wc -l | tr -d ' ')

# File paths from those tool calls. Hedge between .input and .tool_input
# since transcript shape can differ from hook-payload shape across versions.
# Strip embedded newlines so the read loop iterates one path per line.
CALLED_PATHS=$(echo "$RECENT" | jq -r '
    select(.type == "assistant")
    | .message.content[]?
    | select(.type == "tool_use")
    | select(.name == "Write" or .name == "Edit" or .name == "MultiEdit" or .name == "NotebookEdit")
    | (.input.file_path // .tool_input.file_path // empty)
    | gsub("[\\n\\r]"; " ")
' 2>/dev/null | sort -u)

# --- Check A: completion claim with zero mutations ---

ISSUES=""

if [ -n "$LAST_MSG" ] && [ "$MUTATING_CALLS" = "0" ]; then
    # Conservative completion patterns. False positives are noisier than
    # false negatives, so we only fire on strong signals. Trailing
    # boundary keeps "fixed it" from matching inside "fixed itself"
    # and "all tests pass" from matching inside "passenger".
    if echo "$LAST_MSG" | grep -qiE '(^|[^a-z])(✅|done\.|complete\.|completed\.|finished\.|implemented |fixed it|created the |wrote the |added the |saved the |all tests pass(ed)?)([^a-zA-Z]|$)'; then
        # Reject negated phrasing — "not all tests pass" should not trigger.
        if ! echo "$LAST_MSG" | grep -qiE '(not|n.?t|cannot|couldn.?t|didn.?t|haven.?t|hasn.?t|wasn.?t)([[:space:]]+(yet|fully|quite|all|even))?[[:space:]]+(✅|done|complete|completed|finished|implemented|fixed|added|wrote|created|saved|all tests pass)'; then
            # Require a file-path-shaped token. Pure analysis output
            # ("found 3 patterns in the codebase") shouldn't trigger.
            if echo "$LAST_MSG" | grep -qE '[a-zA-Z0-9_/-]+\.[a-zA-Z]{1,5}'; then
                ISSUES="${ISSUES}- Subagent claims completion but made no file changes (Write/Edit/MultiEdit/NotebookEdit count: 0).\n"
            fi
        fi
    fi
fi

# --- Check B: tool-call paths that don't exist on disk ---

if [ -n "$CALLED_PATHS" ]; then
    while IFS= read -r path; do
        [ -z "$path" ] && continue
        case "$path" in
            /*) full_path="$path" ;;
            *)  full_path="$CWD/$path" ;;
        esac
        # `-e` follows symlinks; a broken symlink would falsely flag.
        # `-L` catches the symlink itself — tool created it successfully
        # even if the target moved.
        if [ ! -e "$full_path" ] && [ ! -L "$full_path" ]; then
            ISSUES="${ISSUES}- Tool call recorded Write/Edit to '$path' but the file is not present on disk.\n"
        fi
    done <<EOF
$CALLED_PATHS
EOF
fi

# --- Emit advisory or pass silently ---

if [ -z "$ISSUES" ]; then
    exit 0
fi

MESSAGE=$(printf "[verify-deliverables] Subagent completion check found discrepancies:\n%bReview before treating the subagent's result as final." "$ISSUES")

# Wrap so a jq failure (OOM, missing binary slipping past the early guard)
# cannot leak a non-zero exit to the harness.
jq -n --arg msg "$MESSAGE" '{
  "continue": true,
  "hookSpecificOutput": {
    "hookEventName": "SubagentStop",
    "additionalContext": $msg
  }
}' 2>/dev/null || true

exit 0

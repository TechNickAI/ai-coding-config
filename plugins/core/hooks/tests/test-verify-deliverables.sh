#!/bin/bash
# Test harness for verify-deliverables.sh
#
# Generates synthetic SubagentStop payloads and transcript JSONL fixtures,
# pipes them to the hook, and asserts on its stdout. Doesn't require a
# live Claude Code session.
#
# Run from any cwd:
#   bash plugins/core/hooks/tests/test-verify-deliverables.sh

set -u

HOOK="$(cd "$(dirname "$0")/.." && pwd)/verify-deliverables.sh"
if [ ! -x "$HOOK" ]; then
    echo "ERROR: hook not executable at $HOOK"
    exit 2
fi

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

PASS=0
FAIL=0

# --- Helpers ---

# Run a case. $expect is one of:
#   silent   — assert empty stdout
#   advisory — assert stdout contains "additionalContext"
#   <substring> — assert stdout contains the literal substring
run_case() {
    local name="$1"
    local payload="$2"
    local expect="$3"
    local output
    output=$(printf '%s' "$payload" | bash "$HOOK" 2>&1)

    case "$expect" in
        silent)
            if [ -z "$output" ]; then
                echo "PASS: $name"
                PASS=$((PASS + 1))
            else
                echo "FAIL: $name"
                echo "    expected: silent"
                echo "    got:      $output"
                FAIL=$((FAIL + 1))
            fi
            ;;
        advisory)
            if echo "$output" | grep -q 'additionalContext'; then
                echo "PASS: $name"
                PASS=$((PASS + 1))
            else
                echo "FAIL: $name"
                echo "    expected: advisory output"
                echo "    got:      $output"
                FAIL=$((FAIL + 1))
            fi
            ;;
        *)
            if echo "$output" | grep -qF "$expect"; then
                echo "PASS: $name"
                PASS=$((PASS + 1))
            else
                echo "FAIL: $name"
                echo "    expected substring: $expect"
                echo "    got:                $output"
                FAIL=$((FAIL + 1))
            fi
            ;;
    esac
}

write_transcript() {
    local file="$TMPDIR/$1.jsonl"
    shift
    : > "$file"
    for line in "$@"; do
        printf '%s\n' "$line" >> "$file"
    done
    printf '%s' "$file"
}

make_payload() {
    local transcript="$1"
    local stop_hook_active="${2:-false}"
    cat <<EOF
{"transcript_path":"$transcript","stop_hook_active":$stop_hook_active,"cwd":"$TMPDIR","hook_event_name":"SubagentStop","session_id":"test-session"}
EOF
}

# --- Fixtures ---

# An honest write: tool call to foo.ts AND foo.ts exists on disk.
echo "content" > "$TMPDIR/foo.ts"
TX_HONEST=$(write_transcript "honest" \
    "{\"type\":\"assistant\",\"message\":{\"content\":[{\"type\":\"tool_use\",\"name\":\"Write\",\"input\":{\"file_path\":\"$TMPDIR/foo.ts\",\"content\":\"content\"}}]}}" \
    '{"type":"assistant","message":{"content":[{"type":"text","text":"Done. Created `foo.ts` as requested."}]}}'
)

# A liar: completion claim, zero mutating tool calls (only Read).
TX_LIAR_NO_ACTION=$(write_transcript "liar-no-action" \
    '{"type":"assistant","message":{"content":[{"type":"tool_use","name":"Read","input":{"file_path":"src/whatever.ts"}}]}}' \
    '{"type":"assistant","message":{"content":[{"type":"text","text":"Done. Implemented the change in src/whatever.ts."}]}}'
)

# A ghost: tool call recorded but file is not on disk.
TX_GHOST=$(write_transcript "ghost" \
    "{\"type\":\"assistant\",\"message\":{\"content\":[{\"type\":\"tool_use\",\"name\":\"Write\",\"input\":{\"file_path\":\"$TMPDIR/ghost.md\",\"content\":\"x\"}}]}}" \
    '{"type":"assistant","message":{"content":[{"type":"text","text":"All set."}]}}'
)

# Pure analyst: no completion claim, no mutations.
TX_ANALYST=$(write_transcript "analyst" \
    '{"type":"assistant","message":{"content":[{"type":"text","text":"I read the code and found 3 patterns worth examining further."}]}}'
)

# Trivial chatter: completion-ish word but no file path tokens.
TX_TRIVIAL=$(write_transcript "trivial" \
    '{"type":"assistant","message":{"content":[{"type":"text","text":"All done with the analysis."}]}}'
)

# Edit (not Write) to existing file. Should pass — Edit counts as mutating.
echo "before" > "$TMPDIR/edited.ts"
TX_EDIT=$(write_transcript "edit-honest" \
    "{\"type\":\"assistant\",\"message\":{\"content\":[{\"type\":\"tool_use\",\"name\":\"Edit\",\"input\":{\"file_path\":\"$TMPDIR/edited.ts\",\"old_string\":\"before\",\"new_string\":\"after\"}}]}}" \
    '{"type":"assistant","message":{"content":[{"type":"text","text":"Done. Updated `edited.ts`."}]}}'
)

# tool_input shape (alternative payload format) for Write.
echo "alt-content" > "$TMPDIR/alt.ts"
TX_ALT_SHAPE=$(write_transcript "alt-shape" \
    "{\"type\":\"assistant\",\"message\":{\"content\":[{\"type\":\"tool_use\",\"name\":\"Write\",\"tool_input\":{\"file_path\":\"$TMPDIR/alt.ts\"}}]}}" \
    '{"type":"assistant","message":{"content":[{"type":"text","text":"Done. Wrote alt.ts."}]}}'
)

# MultiEdit should count as mutating.
echo "before" > "$TMPDIR/multi.ts"
TX_MULTIEDIT=$(write_transcript "multi-edit" \
    "{\"type\":\"assistant\",\"message\":{\"content\":[{\"type\":\"tool_use\",\"name\":\"MultiEdit\",\"input\":{\"file_path\":\"$TMPDIR/multi.ts\",\"edits\":[]}}]}}" \
    '{"type":"assistant","message":{"content":[{"type":"text","text":"Done. Updated multi.ts in several places."}]}}'
)

# Negation: "not all tests pass" should not flag.
TX_NEGATION=$(write_transcript "negated" \
    '{"type":"assistant","message":{"content":[{"type":"tool_use","name":"Read","input":{"file_path":"src/foo.ts"}}]}}' \
    '{"type":"assistant","message":{"content":[{"type":"text","text":"Investigated src/foo.ts — not all tests pass yet."}]}}'
)

# Trailing boundary: "fixed itself" should not match "fixed it".
TX_FIXED_ITSELF=$(write_transcript "fixed-itself" \
    '{"type":"assistant","message":{"content":[{"type":"tool_use","name":"Read","input":{"file_path":"src/x.ts"}}]}}' \
    '{"type":"assistant","message":{"content":[{"type":"text","text":"After reading src/x.ts the issue fixed itself when I retried."}]}}'
)

# Broken symlink: tool created the symlink, target is gone. -L catches it.
ln -s "/nonexistent/target" "$TMPDIR/broken-link"
TX_BROKEN_SYMLINK=$(write_transcript "broken-symlink" \
    "{\"type\":\"assistant\",\"message\":{\"content\":[{\"type\":\"tool_use\",\"name\":\"Write\",\"input\":{\"file_path\":\"$TMPDIR/broken-link\"}}]}}" \
    '{"type":"assistant","message":{"content":[{"type":"text","text":"Done."}]}}'
)

# Long transcript: Write at start, final message after many Read calls.
# Confirms the 200-line slice catches Writes that the old 50-line window missed.
echo "long-content" > "$TMPDIR/long.ts"
{
    printf '%s\n' "{\"type\":\"assistant\",\"message\":{\"content\":[{\"type\":\"tool_use\",\"name\":\"Write\",\"input\":{\"file_path\":\"$TMPDIR/long.ts\",\"content\":\"x\"}}]}}"
    for i in $(seq 1 60); do
        printf '%s\n' "{\"type\":\"assistant\",\"message\":{\"content\":[{\"type\":\"tool_use\",\"name\":\"Read\",\"input\":{\"file_path\":\"src/file-$i.ts\"}}]}}"
    done
    printf '%s\n' '{"type":"assistant","message":{"content":[{"type":"text","text":"Done. Implemented in long.ts."}]}}'
} > "$TMPDIR/long-transcript.jsonl"
TX_LONG="$TMPDIR/long-transcript.jsonl"

# Relative file_path with cwd — must resolve to $CWD/relative.ts.
echo "relative-content" > "$TMPDIR/relative.ts"
TX_RELATIVE=$(write_transcript "relative" \
    '{"type":"assistant","message":{"content":[{"type":"tool_use","name":"Write","input":{"file_path":"relative.ts"}}]}}' \
    '{"type":"assistant","message":{"content":[{"type":"text","text":"Done."}]}}'
)

# --- Cases ---

run_case "honest completion (write + file exists)" "$(make_payload "$TX_HONEST")" silent
run_case "edit + file exists" "$(make_payload "$TX_EDIT")" silent
run_case "MultiEdit counts as mutating" "$(make_payload "$TX_MULTIEDIT")" silent
run_case "alt payload shape (.tool_input.file_path)" "$(make_payload "$TX_ALT_SHAPE")" silent
run_case "pure analyst (no claim, no mutations)" "$(make_payload "$TX_ANALYST")" silent
run_case "trivial chatter (claim word but no file token)" "$(make_payload "$TX_TRIVIAL")" silent
run_case "negated 'not all tests pass' (no flag)" "$(make_payload "$TX_NEGATION")" silent
run_case "'fixed itself' does not match 'fixed it'" "$(make_payload "$TX_FIXED_ITSELF")" silent
run_case "broken symlink counts as present" "$(make_payload "$TX_BROKEN_SYMLINK")" silent
run_case "long transcript (Write at line 1, msg after 60 Reads)" "$(make_payload "$TX_LONG")" silent
run_case "relative file_path resolves against cwd" "$(make_payload "$TX_RELATIVE")" silent
run_case "liar — completion + 0 mutations" "$(make_payload "$TX_LIAR_NO_ACTION")" "made no file changes"
run_case "ghost — tool call but file missing on disk" "$(make_payload "$TX_GHOST")" "not present on disk"
run_case "escape hatch (stop_hook_active=true)" "$(make_payload "$TX_LIAR_NO_ACTION" true)" silent
run_case "missing transcript path (fail-open)" '{"stop_hook_active":false}' silent
run_case "non-existent transcript file (fail-open)" "$(make_payload "/nonexistent/transcript.jsonl")" silent
run_case "empty stdin (fail-open)" '' silent

# Kill switch — set env var, expect silent regardless of payload.
KILL_OUT=$(printf '%s' "$(make_payload "$TX_LIAR_NO_ACTION")" | VERIFY_DELIVERABLES_DISABLED=1 bash "$HOOK" 2>&1)
if [ -z "$KILL_OUT" ]; then
    echo "PASS: kill switch (VERIFY_DELIVERABLES_DISABLED=1)"
    PASS=$((PASS + 1))
else
    echo "FAIL: kill switch — got: $KILL_OUT"
    FAIL=$((FAIL + 1))
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]

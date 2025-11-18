---
description:
  Generate comprehensive context handoff and copy to clipboard for continuing work
---

# Handoff Context

Generate a comprehensive context handoff for the current conversation that can be
cleanly copied and pasted to continue work in a new session.

## Instructions

1. **Generate the handoff** - Create a complete context handoff following the
   XML-structured format
2. **Save to temp file** - Use Write tool to save to a unique timestamped file
3. **Copy to clipboard automatically** - Use pbcopy without asking
4. **Show brief confirmation** - Just `📋 Copied to clipboard`

## Process

### Step 1: Generate the Handoff

Create the handoff in this exact format (don't output to user yet, you'll save it
directly to file):

```markdown
# Context Handoff

<context_handoff>

<original_task> [State the original, specific request or task] </original_task>

<work_completed> [List everything successfully accomplished with file paths and line
numbers] </work_completed>

<work_remaining> [Detail work that still needs to be done with priorities]
</work_remaining>

<attempted_approaches> [Document approaches that didn't work and why]
</attempted_approaches>

<critical_context> [Preserve essential technical, project, and business context]
</critical_context>

<current_state> [Describe exact state of deliverables and system] </current_state>

<recommendations>
[Provide actionable next steps in priority order]
</recommendations>

</context_handoff>
```

### Step 2: Save and Copy (Fast & Automatic)

**DO NOT ASK** - Just do it:

1. Generate a unique filename: `/tmp/context_handoff_TIMESTAMP.md` where TIMESTAMP is the current Unix timestamp
2. Use **Write tool** to save the handoff content to that unique filename
3. Use **Bash** to copy the file you just created: `pbcopy < /tmp/context_handoff_TIMESTAMP.md`
4. Confirm: `📋 Copied to clipboard`

**Implementation:** First run `date +%s` to get the timestamp, then use that value in both the Write and Bash commands.

**Why Write tool instead of heredoc?**

- Avoids triggering git hooks (heredoc with `<<` can trigger branch protection)
- Cleaner, no escaping issues
- Faster execution
- Timestamp-based filename prevents collisions between sessions

## Important Guidelines

**For Clean Copy/Paste:**

- Start output with `# Context Handoff` and nothing else
- End with `</context_handoff>` and nothing else
- No "Here's your handoff:" or "I've generated:" preambles
- No "This handoff documents..." summaries after
- Just the pure handoff content

**For Comprehensive Documentation:**

- Include specific file paths with line numbers (e.g., `src/auth.ts:45-67`)
- Document ALL work completed, even minor changes
- Include failed attempts to prevent repetition
- Preserve error messages and stack traces
- Note time-sensitive information
- Include git status and branch info

**For Clipboard Operation:**

1. First run `date +%s` to get current Unix timestamp
2. Use Write tool to save to `/tmp/context_handoff_[timestamp].md`
3. Run: `pbcopy < /tmp/context_handoff_[timestamp].md`
4. Show: `📋 Copied to clipboard` (brief confirmation)

## Example Usage Flow

User: `/handoff-context`

Assistant immediately:

1. Generates the handoff content
2. Gets timestamp with `date +%s`
3. Uses Write tool to save to `/tmp/context_handoff_[timestamp].md`
4. Runs `pbcopy < /tmp/context_handoff_[timestamp].md`
5. Shows `📋 Copied to clipboard`

**Total time: ~2 seconds**

No prompts, no asking, just fast automatic clipboard copy.

## Notes

- The handoff should be immediately pasteable into a new Claude conversation
- The new Claude instance should be able to continue work without any additional context
- Include the markdown header `# Context Handoff` so it renders nicely when pasted
- Use pbcopy for Mac clipboard integration (pbpaste can verify if needed)
- The temp file ensures clean content without shell escaping issues

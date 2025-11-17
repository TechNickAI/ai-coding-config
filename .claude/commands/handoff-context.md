# Handoff Context

Generate a comprehensive context handoff for the current conversation that can be cleanly copied and pasted to continue work in a new session.

## Instructions

1. **Generate the handoff using the structured format** - Create a complete context handoff following the XML-structured format
2. **Output ONLY the handoff content** - No preambles, no explanations, just the raw handoff ready to paste
3. **Offer clipboard integration** - After generating, ask if the user wants it copied to clipboard

## Process

### Step 1: Generate Clean Handoff

Output the handoff in this exact format with NO additional text before or after:

```markdown
# Context Handoff

<context_handoff>

<original_task>
[State the original, specific request or task]
</original_task>

<work_completed>
[List everything successfully accomplished with file paths and line numbers]
</work_completed>

<work_remaining>
[Detail work that still needs to be done with priorities]
</work_remaining>

<attempted_approaches>
[Document approaches that didn't work and why]
</attempted_approaches>

<critical_context>
[Preserve essential technical, project, and business context]
</critical_context>

<current_state>
[Describe exact state of deliverables and system]
</current_state>

<recommendations>
[Provide actionable next steps in priority order]
</recommendations>

</context_handoff>
```

### Step 2: Clipboard Integration

After outputting the handoff, ask:
```
──────────────────────────────
Copy to clipboard? (y/n)
```

If user says yes, use:
```bash
pbcopy < /tmp/context_handoff.md
```

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
1. First save the handoff to a temp file:
   ```bash
   cat > /tmp/context_handoff.md << 'EOF'
   [handoff content]
   EOF
   ```

2. Then copy to clipboard:
   ```bash
   pbcopy < /tmp/context_handoff.md
   ```

3. Confirm success:
   ```bash
   echo "✅ Handoff copied to clipboard"
   ```

## Example Usage Flow

User: `/handoff-context`

Assistant outputs:
```markdown
# Context Handoff

<context_handoff>
[... structured handoff content ...]
</context_handoff>
```

Then asks:
```
──────────────────────────────
Copy to clipboard? (y/n)
```

User: `y`

Assistant executes:
```bash
# Save to temp file and copy to clipboard
cat > /tmp/context_handoff.md << 'EOF'
# Context Handoff

<context_handoff>
[... content ...]
</context_handoff>
EOF

pbcopy < /tmp/context_handoff.md
echo "✅ Handoff copied to clipboard - ready to paste in new conversation"
```

## Notes

- The handoff should be immediately pasteable into a new Claude conversation
- The new Claude instance should be able to continue work without any additional context
- Include the markdown header `# Context Handoff` so it renders nicely when pasted
- Use pbcopy for Mac clipboard integration (pbpaste can verify if needed)
- The temp file ensures clean content without shell escaping issues
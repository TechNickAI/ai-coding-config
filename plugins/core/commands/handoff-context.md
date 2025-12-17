---
description: "Generate context handoff and copy to clipboard for new session"
version: 1.0.0
---

# Handoff Context

<objective>
Generate a comprehensive context handoff for the current conversation that can be copied and pasted to continue work in a new session.
</objective>

<execution>
Create handoff following the XML-structured format, save to timestamped temp file, copy to clipboard automatically. Show brief confirmation: `📋 Copied to clipboard`

Do not ask for permission - execute immediately. </execution>

<handoff-format>
```markdown
# Context Handoff

<context_handoff> <original_task> [State the original, specific request or task]
</original_task> <work_completed> [List everything successfully accomplished with file
paths and line numbers] </work_completed> <work_remaining> [Detail work that still needs
to be done with priorities] </work_remaining> <attempted_approaches> [Document
approaches that didn't work and why] </attempted_approaches> <critical_context>
[Preserve essential technical, project, and business context] </critical_context>
<current_state> [Describe exact state of deliverables and system] </current_state>
<recommendations> [Provide actionable next steps in priority order] </recommendations>
</context_handoff>

```
</handoff-format>

<implementation>
Get timestamp with `date +%s`, use Write tool to save to `/tmp/context_handoff_[timestamp].md`, run `pbcopy < /tmp/context_handoff_[timestamp].md`, show confirmation.

Why Write tool: Avoids git hooks, no escaping issues, faster execution, prevents collisions.
</implementation>

<quality-guidelines>
For clean copy/paste: Start with `# Context Handoff`, end with `</context_handoff>`, no preambles or summaries.

For comprehensive documentation: Include file paths with line numbers, document all work including minor changes, include failed attempts, preserve error messages and stack traces, note time-sensitive information, include git status and branch info.
</quality-guidelines>

<success-criteria>
Handoff should be immediately pasteable into new Claude conversation. New Claude instance should be able to continue work without additional context.
</success-criteria>
```

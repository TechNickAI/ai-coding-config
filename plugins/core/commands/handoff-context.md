---
# prettier-ignore
description: "Generate context handoff and copy to clipboard for new session - preserves decisions, progress, and next steps across conversations"
version: 1.1.0
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
</original_task>

<decisions_made> [Architecture choices, tradeoffs accepted, approaches chosen — with the
reason each was picked over alternatives. Prevents the next session from relitigating
settled calls.]

- [decision] — reason: [why this over alternatives] </decisions_made>

<work_completed> [Every item here MUST include evidence. "Confirmed by: test passed /
curl returned 200 / visible in Supabase / Postman response attached." Without evidence,
move the item to untried_approaches.]

- [thing that works] — confirmed by: [specific evidence] </work_completed>

<files>
[Every file touched. Table format for scannability.]
| File              | Status        | Notes                      |
| ----------------- | ------------- | -------------------------- |
| `path/to/file.ts` | Complete      | [what it does]             |
| `path/to/file.ts` | In Progress   | [what's done, what's left] |
| `path/to/file.ts` | Broken        | [what's wrong]             |
| `path/to/file.ts` | Not Started   | [planned but not touched]  |
</files>

<work_remaining> [Work that still needs to be done, in priority order. Distinct from
blockers (these are doable now).] </work_remaining>

<failed_approaches> [Approaches tried that did NOT work. Pair each with the EXACT
failure reason so the next session does not retry blindly. "Threw X error because Y" is
useful; "didn't work" is not.]

- [approach tried] — failed because: [exact reason / error message] </failed_approaches>

<untried_approaches> [Promising ideas that have NOT yet been attempted. Distinct from
failed — these are still open. Be specific enough that the next session knows exactly
what to try.]

- [approach / idea] </untried_approaches>

<blockers>
[Unresolved external dependencies, open questions waiting on answers, things blocked on someone/something outside the session. Distinct from work_remaining (those are doable; these aren't yet).]
</blockers>

<critical_context> [Essential technical, project, and business context the next session
needs but can't derive from the code. Git branch, env state, related PR numbers,
stakeholder constraints, time-sensitive notes.] </critical_context>

<exact_next_step> [The ONE most important action to take on resume. Precise enough that
starting requires zero thinking. Singular and concrete, e.g., "In
app/api/auth/login/route.ts line 42, set the JWT as httpOnly cookie via
cookies().set(...), then curl the endpoint to verify Set-Cookie header is present."]
</exact_next_step>

<recommendations>
[Actionable next steps in priority order, as a backup to exact_next_step.]
</recommendations>
</context_handoff>
```
</handoff-format>

<honesty-requirement>
Write "N/A" or "None" in sections that genuinely have no content — incomplete is worse than honest empty. Skipping a section is indistinguishable from forgetting to fill it, which leaves the next session guessing. An empty `<blockers>None</blockers>` is a positive signal; a missing `<blockers>` tag is ambiguous.

If `work_completed` has no evidence-backed items yet, write "Nothing confirmed working
yet — all approaches still in progress or untested." </honesty-requirement>

<implementation>
Get timestamp with `date +%s`, use Write tool to save to `/tmp/context_handoff_[timestamp].md`, run `pbcopy < /tmp/context_handoff_[timestamp].md`, show confirmation.

Why Write tool: Avoids git hooks, no escaping issues, faster execution, prevents
collisions. </implementation>

<quality-guidelines>
For clean copy/paste: Start with `# Context Handoff`, end with `</context_handoff>`, no preambles or summaries.

For comprehensive documentation: Include file paths with line numbers, document all work
including minor changes, preserve error messages and stack traces verbatim, note
time-sensitive information, include git status and branch info. </quality-guidelines>

<success-criteria>
Handoff should be immediately pasteable into new Claude conversation. New Claude instance should be able to continue work without additional context — and should know which approaches to avoid retrying, which decisions are settled, and the single next step to take.
</success-criteria>

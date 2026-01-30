---
name: fireflies
# prettier-ignore
description: "Use when finding meeting transcripts, searching Fireflies recordings, getting action items from calls, or answering 'what was discussed in the meeting' questions"
version: 1.0.0
category: research
triggers:
  - "fireflies"
  - "meeting transcript"
  - "meeting notes"
  - "what was discussed"
  - "action items"
  - "zoom call"
  - "teams meeting"
  - "google meet"
---

<objective>
Query Fireflies.ai meeting transcripts - recorded calls with AI-generated summaries, action items, and searchable conversation history. Transform "what happened in that meeting?" into structured, actionable insights.
</objective>

<when-to-use>
Use when finding meeting content, extracting action items, searching professional discussions, getting context from recorded calls, or building understanding from past meetings.

Clear triggers:
- "What meetings did I have today/this week?"
- "What was discussed in the [project] meeting?"
- "What were the action items from yesterday's call?"
- "Find meetings about [topic]"
</when-to-use>

<prerequisites>
Set `FIREFLIES_API_KEY` environment variable. Get your key from [app.fireflies.ai](https://app.fireflies.ai) → Integrations → Fireflies API.
</prerequisites>

<commands>
```bash
# Recent transcripts (default: 5)
fireflies recent
fireflies recent 10

# Today's meetings
fireflies today

# Specific date
fireflies date 2026-01-28

# Search by keyword
fireflies search "product roadmap"
fireflies search "budget discussion"

# Full transcript by ID
fireflies get abc123xyz

# Your account info
fireflies me
```
</commands>

<response-format>
**List view includes:**
- id, title, duration, host, participants
- AI-generated overview and action items

**Full transcript includes:**
- Complete sentences with speaker names and timestamps
- Keywords, topics discussed, outline
- Extracted action items
</response-format>

<api-notes>
- Works with Zoom, Google Meet, Microsoft Teams
- Speaker names from calendar invites
- GraphQL API docs: [docs.fireflies.ai](https://docs.fireflies.ai)
</api-notes>

<llm-api-reference>
If you need to look up API details beyond this skill's commands, use Context7:
```
resolve-library-id: fireflies → /websites/fireflies_ai
query-docs: /websites/fireflies_ai with "GraphQL transcripts query"
```

Context7 has full GraphQL schema documentation with code examples in Python, JavaScript, and cURL.
</llm-api-reference>

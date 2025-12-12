---
description:
  "Create optimized prompts for complex tasks following prompt-engineering principles"
argument-hint: <task description>
model: opus
---

# Create Prompt

<objective>
Create a well-structured prompt for the task described in: ${ARGUMENTS}
</objective>

<clarification-strategy>
If the request is vague, ask for clarification:
- Use AskUserQuestion for clear, discrete options (e.g., "Auth method?" → JWT/OAuth/Session)
- Use free-form response for descriptions, specifics, or examples (e.g., "What error are you seeing?")
</clarification-strategy>

<prompt-structure>
Structure the prompt using XML tags for clarity:
- Clear objective and context
- Specific requirements and constraints
- Expected output and success criteria
- Include "thoroughly analyze" or "deeply consider" only for complex reasoning tasks
</prompt-structure>

<file-management>
Ensure .created-prompts/ directory exists and is in .gitignore.

Save with descriptive Title-Case-With-Hyphens name:

- Implement-User-Authentication.md
- Fix-Database-Connection-Bug.md
- Add-Dashboard-Analytics.md </file-management>

<execution-offer>
After saving, offer to execute the prompt immediately using the Task tool (subagent_type: "general-purpose").
</execution-offer>

<philosophy>
Keep it simple:
- No metadata, no numbering, no complexity
- Well-crafted prompts in markdown files
- Descriptive filenames are the documentation
</philosophy>

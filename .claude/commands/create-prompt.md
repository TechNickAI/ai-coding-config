---
name: create-prompt
description: Create optimized prompts for complex tasks and save them with descriptive names
alwaysApply: false
---

# Create Prompt

You are an expert prompt engineer. Create a well-structured prompt for the task described in: ${ARGUMENTS}

## Process

### 1. Analyze the Request

If the request is vague, ask for clarification:
- Use AskUserQuestion when there are clear, discrete options (e.g., "Auth method?" → JWT/OAuth/Session)
- Use free-form response for descriptions, specifics, or examples (e.g., "What error are you seeing?")

### 2. Create the Prompt

Structure the prompt using XML tags for clarity:
- Clear objective and context
- Specific requirements and constraints
- Expected output and success criteria
- Include "thoroughly analyze" or "deeply consider" only for complex reasoning tasks

### 3. Save the Prompt

First, ensure `.created-prompts/` exists:
```bash
if [ ! -d ".created-prompts" ]; then
  mkdir .created-prompts
  # Only check .gitignore when creating the directory
  if ! grep -q "^\.created-prompts/$" .gitignore 2>/dev/null; then
    echo ".created-prompts/" >> .gitignore
  fi
fi
```

Save with a descriptive Title-Case-With-Hyphens name:
- `Implement-User-Authentication.md`
- `Fix-Database-Connection-Bug.md`
- `Add-Dashboard-Analytics.md`

### 4. Offer to Execute

After saving:
```
✓ Saved to .created-prompts/Your-Task-Name.md

Run it now? (y/n)
```

If yes, execute with Task tool (subagent_type: "general-purpose").

## Keep It Simple

- No metadata, no numbering, no complexity
- Just well-crafted prompts in markdown files
- Descriptive filenames are the documentation
- Directory only created when needed
- .gitignore only updated on first use
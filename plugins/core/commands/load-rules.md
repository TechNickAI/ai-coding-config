---
description: Load relevant coding rules for the current task
model: haiku
---

Analyze the current task and load ONLY relevant rules from `rules/`.

PROCESS:

1. Discover available rules: use glob_file_search with pattern "\*.mdc" in rules/ to
   find all rule files recursively
2. Analyze task to identify what domains apply (languages, tools, frameworks,
   operations)
3. Select relevant rules based on task requirements
4. Read selected rule files
5. State which rules loaded in one sentence
6. Proceed with task following those rules

SELECTION CRITERIA:

- Load rules for the primary language/framework being used
- Load rules for specific tools or operations mentioned in the task
- Prefer specific rules over general ones when both apply
- Avoid loading rules that don't directly inform the current work

EXAMPLES: Task: "Add error tracking to payment processor" → Load Python standards, error
tracking rules Task: "Write tests for auth flow" → Load Python standards, pytest rules
Task: "Create React dashboard component" → Load React component rules Task: "Commit
these changes" → Load git commit message rules

Be selective. Loading too many rules dilutes focus.

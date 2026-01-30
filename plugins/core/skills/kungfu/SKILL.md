---
name: kungfu
# prettier-ignore
description: "Use when finding new AI agent skills, discovering capabilities, installing skills from GitHub, searching skill marketplaces, or expanding what Claude can do - like Neo downloading martial arts in The Matrix"
version: 1.0.0
category: meta
triggers:
  - "kungfu"
  - "find skills"
  - "install skill"
  - "skill marketplace"
  - "download skill"
  - "new capabilities"
  - "agent skills"
  - "expand abilities"
  - "i know kungfu"
  - "matrix"
---

<objective>
Discover, evaluate, and install AI agent skills from the ecosystem. Like Neo downloading kung fu in The Matrix - autonomously expand capabilities by finding and integrating new skills.
</objective>

<when-to-use>
- Need a skill that doesn't exist yet
- Want to discover what's available
- Installing skills from external sources
- Auditing or updating installed skills
</when-to-use>

<discovery-sources>
Search these GitHub repos for curated skill collections:
- VoltAgent/awesome-agent-skills (200+ skills)
- composioHQ/awesome-claude-code-skills
- sickn33/antigravity-awesome-skills (500+ skills)
- numman-ali/openskills
- rohitg00/skillkit
- alirezarezvani/claude-skills

Also search GitHub directly for repos containing SKILL.md files.
</discovery-sources>

<skill-format>
Valid skills have:
```
skill-name/
  SKILL.md           # Required - YAML frontmatter + content
  scripts/tool       # Optional - executable
```

Required frontmatter: name, description ("Use when..."), triggers
</skill-format>

<quality-signals>
Evaluate on: GitHub stars, recent activity, SKILL.md quality, documentation, relevance to user's need.

Skip: No SKILL.md, abandoned (>1 year stale), <10 stars (unless trusted source), duplicates existing skill.
</quality-signals>

<workflows>
**Search**: Query awesome lists and GitHub, evaluate candidates, present top 3-5 with install instructions.

**Install**: Fetch skill, validate SKILL.md format, download to skills directory, verify it loads.

**Audit**: List installed skills, check for updates, identify unused candidates for removal.

**Harvest**: Check awesome lists for new additions, find trending skill repos, queue promising discoveries.
</workflows>

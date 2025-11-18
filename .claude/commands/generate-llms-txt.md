---
description: Generate or update llms.txt file to help LLMs understand and navigate your site
---

# Generate llms.txt

Creates or updates `llms.txt` - a standardized file that helps Large Language Models understand and navigate your website or documentation at inference time.

<philosophy>
llms.txt provides LLM-friendly navigation and context for websites and documentation. It should be:
- Concise - LLMs have limited context windows
- Navigational - Links to key documentation rather than duplicating it
- Structured - Uses markdown format for easy LLM parsing
- Focused - Highlights most important resources first

Think: "What does an LLM need to understand and effectively use this site?"
</philosophy>

<workflow>
<determine-location>
Detect the appropriate location for llms.txt based on project type:

1. Check for `public/` directory (Next.js, React, Vue, many static site generators)
2. Check for `static/` directory (Django, Flask, Hugo)
3. Check for `docs/` directory if this appears to be a documentation site
4. Default to repository root if none found

The file should be placed where it will be accessible at the URL path `/llms.txt` when the site is deployed.
</determine-location>

<analyze-project>
Understand the project structure to generate relevant content:

1. Detect project type:
   - Check `package.json` for web frameworks (Next.js, React, Vue, etc.)
   - Check `pyproject.toml`, `requirements.txt` for Python frameworks (Django, Flask, FastAPI)
   - Check for static site generators (Hugo, Jekyll, Gatsby, etc.)
   - Check for documentation tools (MkDocs, Docusaurus, VitePress, etc.)

2. Identify key documentation:
   - Look for README.md
   - Look for docs/ or documentation/ directory
   - Look for CONTRIBUTING.md, ARCHITECTURE.md, API.md
   - Check .cursor/rules/ for coding standards
   - Check .claude/agents/ for specialized agents
   - Check for API documentation (OpenAPI/Swagger files)

3. Identify important links:
   - GitHub repository URL (from package.json, git remote)
   - Documentation site URL (from package.json, README)
   - API reference locations
   - Getting started guides
</analyze-project>

<generate-structure>
Create llms.txt following the standard format:

```markdown
# Project Name

> Brief 1-2 sentence description of what this project/site is and what it helps users accomplish.

Additional context paragraph (optional): More detailed information about the project's purpose, key features, or important background that helps LLMs understand how to use the site effectively.

## Documentation

- [Getting Started](url): Brief description of what this covers
- [Core Concepts](url): Brief description
- [API Reference](url): Brief description

## Guides

- [Guide Title](url): Brief description
- [Another Guide](url): Brief description

## Reference

- [Configuration](url): Brief description
- [CLI Commands](url): Brief description
- [Architecture](url): Brief description

## Optional

- [Less Critical Resource](url): Brief description
- [Advanced Topics](url): Brief description
```

Structure guidelines:
- **H1 title** (required): Project or site name
- **Blockquote** (recommended): Short summary with key information for understanding the rest of the file
- **Additional context** (optional): Detailed background if needed
- **Sections** (H2 headers): Organize documentation by category
  - Common categories: Documentation, Guides, Reference, API, Examples, Contributing
  - Use "Optional" section for less critical resources
- **Links**: Markdown format with optional brief descriptions
  - Use relative paths for internal documentation
  - Use absolute URLs for external resources
  - Keep descriptions concise

Priority order:
1. Getting started / quickstart guides
2. Core concepts and tutorials
3. API reference and technical documentation
4. Advanced topics and edge cases
5. Contributing and community resources
</generate-structure>

<create-llms-full-txt>
Optionally create llms-full.txt alongside llms.txt:

- `llms.txt` - Lightweight navigation file (links to docs)
- `llms-full.txt` - Comprehensive file with full documentation content

For most projects, start with just `llms.txt`. Only create `llms-full.txt` if:
- Project has extensive documentation that would benefit from a single-file view
- Documentation is already in markdown format
- Total size would be reasonable (< 100KB)

Skip llms-full.txt creation for now unless user specifically requests it.
</create-llms-full-txt>

<optimize-for-llms>
Review and optimize the generated content:

1. **Prioritize ruthlessly**: Most important links first
2. **Be concise**: Brief descriptions, not full explanations
3. **Use relative paths**: For internal documentation (easier to maintain)
4. **Organize logically**: Group related topics together
5. **Mark optional content**: Use "Optional" section for nice-to-have resources
6. **Keep it current**: Link to actively maintained documentation
7. **Test URLs**: Ensure all links will be valid when deployed

Target: Under 2KB for most projects (focused navigation, not content duplication)
</optimize-for-llms>

<report>
Show the user:
1. Where the file will be created (with explanation of why)
2. The generated content
3. File size
4. Suggestions for what to add if content seems sparse
5. Next steps (how to verify it works, how to update it)
</report>
</workflow>

<update-mode>
When `llms.txt` already exists:

1. Read existing file to understand current content
2. Analyze project for changes:
   - New documentation files added
   - Changed project structure
   - Updated README or documentation
   - New major features or guides
3. Suggest additions or updates with rationale
4. Show diff of proposed changes
5. Let user review before updating

Preserve existing structure and organization unless there's a good reason to change it.
</update-mode>

<key-principles>
Navigation over duplication: Link to documentation, don't duplicate it.

LLM-friendly format: Markdown is the most widely understood format for LLMs.

Prioritize ruthlessly: LLMs have limited context - put most important content first.

Keep it current: Outdated links are worse than missing links.

Test the result: After generating, consider "Would an LLM understand how to navigate this site?"
</key-principles>

<location-detection-examples>
Example directory structures and where to place llms.txt:

Next.js project:
```
project/
├── public/ ← Place llms.txt here
├── src/
└── package.json
```

Django project:
```
project/
├── static/ ← Place llms.txt here
├── myapp/
└── manage.py
```

Documentation site:
```
project/
├── docs/ ← Consider placing here if this is the deployed location
├── README.md
└── mkdocs.yml
```

Plain repository (no public/static):
```
project/
├── llms.txt ← Place in root
├── README.md
└── src/
```
</location-detection-examples>

<common-sections>
Recommended section organization based on project type:

**API/Library Project:**
- Documentation (getting started, core concepts)
- API Reference
- Examples
- Guides
- Optional (advanced topics, contributing)

**Web Application:**
- Documentation (overview, quickstart)
- User Guides
- API Documentation (if applicable)
- Architecture
- Optional (deployment, troubleshooting)

**Documentation Site:**
- Getting Started
- Tutorials
- Reference
- Guides
- Optional (FAQ, community)

**Developer Tool/CLI:**
- Documentation (installation, quickstart)
- Commands Reference
- Configuration
- Examples
- Optional (plugins, advanced usage)
</common-sections>

<final-checklist>
- File location is appropriate for project type
- H1 title reflects project name
- Blockquote provides clear project summary
- Sections are logically organized
- Most important links come first
- "Optional" section for less critical resources
- Link descriptions are concise and helpful
- All URLs will be valid when site is deployed
- File is under 2KB (focused navigation)
- Format follows llms.txt specification from llmstxt.org
</final-checklist>

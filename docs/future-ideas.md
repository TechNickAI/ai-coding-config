# Future Ideas

Ideas for potential improvements. No timelines, no commitments.

## Deferred for Later

**MCP Server Management**:

- Configuration templates for popular MCP servers
- Tool-specific configs (.cursor/mcp.json, .mcp.json in repo root)
- User-level vs project-level server configs
- Server discovery and selection

**Environment Variables & Secrets**:

- .env templates for Python/TypeScript
- API key management
- Secrets documentation
- Validation scripts

These are complex and can wait. Focus on the core first.

---

## Commands to Build

### Python Commands

**Testing**:

- `python-test` - Run pytest with coverage
- `python-test-watch` - Run tests on file changes
- `python-test-failed` - Re-run only failed tests
- `python-coverage` - Generate HTML coverage report

**Code Quality**:

- `python-lint` - Run ruff check
- `python-format` - Run ruff format
- `python-type` - Run mypy type checking
- `python-check-all` - Lint + format + type check in one command

**Django Specific**:

- `django-migrate` - Run migrations
- `django-makemigrations` - Create new migrations
- `django-shell` - Open Django shell with IPython
- `django-test` - Run Django tests
- `django-check` - Django system check
- `django-routes` - Show all URL routes

**FastAPI/Flask**:

- `api-test` - Test API endpoints
- `api-docs` - Generate OpenAPI docs
- `api-routes` - List all routes

**Dependencies**:

- `python-update-deps` - Update requirements.txt safely
- `python-audit` - Check for security issues
- `python-outdated` - Show outdated packages

### TypeScript Commands

**Testing**:

- `ts-test` - Run Jest/Vitest
- `ts-test-watch` - Run tests in watch mode
- `ts-test-coverage` - Generate coverage report

**Code Quality**:

- `ts-lint` - Run ESLint
- `ts-format` - Run Prettier
- `ts-type` - Run tsc type checking
- `ts-check-all` - Lint + format + type check

**Build**:

- `ts-build` - Build production bundle
- `ts-dev` - Start dev server
- `ts-analyze` - Analyze bundle size

**React Specific**:

- `react-component` - Generate component with tests
- `react-storybook` - Run Storybook
- `react-optimize` - Check for performance issues

**Node.js**:

- `node-debug` - Start debugger
- `node-profile` - Profile performance

**Dependencies**:

- `ts-update-deps` - Update package.json safely
- `ts-audit` - Check for security issues
- `ts-outdated` - Show outdated packages

### Universal Commands

**Code Understanding**:

- `explain-code` - Explain complex code
- `review-code` - AI code review
- `find-issues` - Identify potential bugs
- `suggest-improvements` - Refactoring suggestions

**Documentation**:

- `generate-docs` - Create documentation
- `update-readme` - Update README.md
- `create-changelog` - Generate CHANGELOG

**Git**:

- `git-commit-smart` - Generate commit message
- `git-pr-description` - Generate PR description
- `git-review-changes` - Review uncommitted changes

**DevOps**:

- `docker-build` - Build Docker image
- `docker-optimize` - Optimize Dockerfile
- `k8s-check` - Validate K8s configs

## GitHub Workflows to Build

### Python Workflows

**`.github/workflows/python-quality.yml`**:

- Run ruff check
- Run mypy
- Fail on any errors
- Fast feedback loop

**`.github/workflows/python-test.yml`**:

- Run pytest on multiple Python versions
- Generate coverage report
- Upload to Codecov
- Comment coverage on PR

**`.github/workflows/python-security.yml`**:

- Run pip-audit
- Check for known vulnerabilities
- Scan dependencies
- Create security report

**`.github/workflows/python-release.yml`**:

- Build package
- Run tests
- Publish to PyPI
- Create GitHub release

### TypeScript Workflows

**`.github/workflows/ts-quality.yml`**:

- Run ESLint
- Run Prettier check
- Type check with tsc
- Fast CI feedback

**`.github/workflows/ts-test.yml`**:

- Run Jest/Vitest
- Test on multiple Node versions
- Generate coverage
- Comment on PR

**`.github/workflows/ts-build.yml`**:

- Build production bundle
- Check bundle size
- Fail if size increased significantly
- Deploy preview

**`.github/workflows/ts-security.yml`**:

- npm audit
- Dependency scanning
- License checking

### Universal Workflows

**`.github/workflows/cursor-cli-fix.yml`** (from Cursor cookbook):

- Run on PR
- Use Cursor CLI to check code
- Auto-fix issues
- Commit fixes back

**`.github/workflows/ai-review.yml`**:

- AI-assisted code review on PR
- Comment suggestions
- Check for common issues

**`.github/workflows/deps-update.yml`**:

- Weekly dependency updates
- Create PR automatically
- Run tests
- Auto-merge if passing

**`.github/workflows/docs-check.yml`**:

- Validate documentation links
- Check code examples compile
- Spell check
- Grammar check

## MCP Servers to Add

### Development Tools

- filesystem - File operations
- github - GitHub integration
- git - Git operations
- memory - Persistent memory
- sequential-thinking - Enhanced reasoning

### Data Sources

- postgresql - PostgreSQL database
- sqlite - SQLite database
- mysql - MySQL database
- redis - Redis cache
- mongodb - MongoDB database

### External Services

- brave-search - Web search
- google-search - Google search
- slack - Slack integration
- linear - Linear issue tracking
- notion - Notion integration

### Python Specific

- python-repl - Python REPL
- jupyter - Jupyter notebooks
- pandas-helper - Data analysis

### TypeScript Specific

- npm-helper - Package management
- node-repl - Node.js REPL

## Agent Definitions to Create

**Language Specialists**:

- `python-expert` - Python best practices
- `typescript-expert` - TypeScript best practices
- `django-expert` - Django framework
- `react-expert` - React patterns

**Task Specialists**:

- `test-writer` - Generate comprehensive tests
- `code-reviewer` - Review code quality
- `doc-writer` - Write documentation
- `refactorer` - Suggest refactorings
- `debugger` - Help debug issues
- `optimizer` - Performance improvements

**Domain Specialists**:

- `api-designer` - RESTful API design
- `database-architect` - Database schema design
- `security-auditor` - Security review
- `devops-helper` - CI/CD and deployment

## Command Improvements

**ai-coding-config enhancements**:

- Remember user preferences across projects
- Show visual diff of changed files
- Backup before updating
- Validate copied files work
- Offer to commit changes after setup

## Documentation to Write

**Guides**:

- getting-started.md
- cursor-guide.md
- claude-code-guide.md
- mcp-guide.md
- python-setup.md
- typescript-setup.md

**Reference**:

- commands-reference.md - All commands explained
- agents-reference.md - All agents explained
- settings-reference.md - All settings explained

**Troubleshooting**:

- common-issues.md
- faq.md

## Maybe Later

**Advanced Features**:

- Analytics dashboard (if actually useful)
- CLI management tool (if scripts aren't enough)
- Plugin system (if people want to extend)
- More languages (Go, Rust, etc.)

**Community**:

- Contribution guide (if people want to contribute)
- Template sharing (if there's demand)
- Best practices collection (community-driven)

---

_These are ideas, not commitments. Build what's useful, skip what's not._

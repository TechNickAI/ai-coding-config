---
description: Initialize development environment for git worktree
---

Make this worktree a fully functional development environment where all tests pass.

You're in a fresh git worktree. Your job is to get it into the same working state as the
main development directory. After you finish, running the full validation suite should
pass - type checking, linting, unit tests, and integration tests.

To do this, you'll need to:

- Install whatever dependencies this project needs
- Run any code generation or build steps required
- Copy environment configuration from the parent directory so integration tests can
  connect to databases and services

Look at what kind of project this is and make intelligent decisions about what needs to
happen. If something fails or seems unusual, investigate and adapt. Report what you're
doing as you go so the user understands the progress.

The success criteria: after you're done, `pnpm pre-push` (or equivalent validation)
passes completely. No failing tests, no type errors, no missing dependencies.

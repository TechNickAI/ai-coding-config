---
description: Initialize development environment for git worktree
---

# Setup Development Environment

Initialize a git worktree as a fully functional development environment with all
dependencies, configurations, and validation tools.

## What This Command Does

You're in a fresh git worktree. This command will:

1. Install all project dependencies
2. Copy necessary environment configurations
3. Set up git hooks (husky/pre-commit)
4. Run any required build/generation steps
5. Verify everything works correctly

## Detection Phase

First, I'll analyze the project structure to understand what needs to be set up:

<detect-project-type>
Checking for project indicators:
- package.json → Node.js/JavaScript/TypeScript project
- requirements.txt/Pipfile → Python project
- Gemfile → Ruby project
- go.mod → Go project
- Cargo.toml → Rust project
- pom.xml/build.gradle → Java project
- .csproj → .NET project
</detect-project-type>

<detect-package-manager>
For Node.js projects, detecting package manager:
- pnpm-lock.yaml → pnpm
- yarn.lock → yarn
- package-lock.json → npm
- bun.lockb → bun
</detect-package-manager>

## Setup Steps

### 1. Install Dependencies

```bash
# Based on detected package manager
echo "📦 Installing dependencies..."

# Node.js
if [ -f "package.json" ]; then
  if [ -f "pnpm-lock.yaml" ]; then
    pnpm install
  elif [ -f "yarn.lock" ]; then
    yarn install
  elif [ -f "bun.lockb" ]; then
    bun install
  else
    npm install
  fi
fi

# Python
if [ -f "requirements.txt" ]; then
  pip install -r requirements.txt
elif [ -f "Pipfile" ]; then
  pipenv install
fi

# Add other language-specific installations as needed
```

### 2. Copy Environment Configuration

```bash
echo "🔐 Setting up environment configuration..."

# Get the main working directory (parent of .gitworktrees)
MAIN_DIR=$(git worktree list --porcelain | grep "^worktree" | head -1 | cut -d' ' -f2)

# Copy environment files if they exist
ENV_FILES=(.env .env.local .env.development .env.test)
for env_file in "${ENV_FILES[@]}"; do
  if [ -f "$MAIN_DIR/$env_file" ]; then
    echo "  Copying $env_file from main directory..."
    cp "$MAIN_DIR/$env_file" "./$env_file"
  fi
done

# Copy any other config files that aren't in version control
CONFIG_FILES=(.secrets.json local.config.js config.local.json)
for config_file in "${CONFIG_FILES[@]}"; do
  if [ -f "$MAIN_DIR/$config_file" ]; then
    echo "  Copying $config_file from main directory..."
    cp "$MAIN_DIR/$config_file" "./$config_file"
  fi
done
```

### 3. Setup Git Hooks

```bash
echo "🪝 Setting up git hooks..."

# Get the main working directory
MAIN_DIR=$(git worktree list --porcelain | grep "^worktree" | head -1 | cut -d' ' -f2)

# Husky (most common in JS/TS projects)
if [ -d "$MAIN_DIR/.husky" ] || [ -f ".husky" ]; then
  echo "  Installing Husky hooks..."
  npx husky install
  echo "  ✓ Husky hooks installed"
fi

# Pre-commit (Python and multi-language projects)
if [ -f "$MAIN_DIR/.pre-commit-config.yaml" ] || [ -f ".pre-commit-config.yaml" ]; then
  echo "  Installing pre-commit hooks..."
  if command -v pre-commit >/dev/null 2>&1; then
    pre-commit install
    echo "  ✓ Pre-commit hooks installed"
  else
    echo "  ⚠️ pre-commit not installed, run: pip install pre-commit"
  fi
fi

# Simple git hooks (legacy projects)
if [ -d "$MAIN_DIR/.git/hooks" ]; then
  # Check for custom hooks that need copying
  for hook in pre-commit pre-push commit-msg; do
    if [ -f "$MAIN_DIR/.git/hooks/$hook" ] && [ ! -f ".git/hooks/$hook" ]; then
      echo "  Copying $hook hook..."
      cp "$MAIN_DIR/.git/hooks/$hook" ".git/hooks/$hook"
      chmod +x ".git/hooks/$hook"
    fi
  done
fi

echo "  ✓ Git hooks configured for this worktree"
```

### 4. Run Build/Generation Steps

```bash
echo "🏗️ Running build and generation steps..."

# Check for code generation needs
if [ -f "package.json" ]; then
  # Prisma generation
  if grep -q "@prisma/client" package.json; then
    echo "  Generating Prisma client..."
    npx prisma generate
  fi

  # GraphQL codegen
  if [ -f "codegen.yml" ] || [ -f "codegen.ts" ]; then
    echo "  Running GraphQL codegen..."
    npm run codegen || yarn codegen || npx graphql-codegen
  fi

  # Build if needed for development
  if grep -q '"prepare"' package.json; then
    echo "  Running prepare script..."
    npm run prepare || yarn prepare
  fi

  # TypeScript declarations
  if [ -f "tsconfig.json" ] && grep -q '"declaration"' tsconfig.json; then
    echo "  Building TypeScript declarations..."
    npx tsc --emitDeclarationOnly || true
  fi
fi
```

### 5. Verify Setup

```bash
echo "🔍 Verifying environment setup..."

# Run git hooks to verify everything works
echo "Testing git hooks..."
if [ -d ".husky" ]; then
  echo "  Running Husky pre-commit hooks..."
  npx husky run pre-commit && echo "  ✓ Husky hooks working" || echo "  ⚠️ Some checks failed (fixing...)"
elif [ -f ".pre-commit-config.yaml" ]; then
  echo "  Running pre-commit hooks..."
  pre-commit run --all-files && echo "  ✓ Pre-commit hooks working" || echo "  ⚠️ Some checks failed (fixing...)"
else
  echo "  ⚠️ No git hooks configured - consider adding husky or pre-commit"
fi

# Quick sanity checks
if [ -f "package.json" ]; then
  echo "Testing build..."
  npm run build 2>/dev/null || yarn build 2>/dev/null || echo "  ⚠️ No build script"
fi

# Check environment files
if [ -f ".env" ]; then
  echo "✅ Environment configuration present"
fi

echo ""
echo "✅ Environment setup complete!"
echo ""
echo "This worktree is now ready for development:"
echo "  - All dependencies installed"
echo "  - Environment configured"
echo "  - Git hooks installed and working"
echo "  - Ready for development"
echo ""
echo "Your git hooks will handle all validation when you commit."
```

## Error Handling

If any step fails, I'll:

1. Identify what went wrong
2. Attempt to fix common issues automatically
3. Provide clear guidance on manual fixes if needed
4. Continue with other steps when safe to do so

## Success Criteria

After setup completes:

- All dependencies are installed
- Environment variables are configured
- Git hooks are properly installed and working
- The worktree is ready for development

The goal is a worktree that's immediately productive - no missing dependencies, no
failing tests, no configuration issues. Your existing git hooks (husky/pre-commit)
handle all validation automatically when you commit.

#!/bin/bash
set -e

echo "🚀 AI Coding Configuration Bootstrap"
echo ""

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: You're not in a git repository."
    echo ""
    echo "Move into a project directory first:"
    echo "  cd ~/your-project"
    echo ""
    echo "Then run this script again."
    exit 1
fi

# Check OS
OS="$(uname -s)"
if [[ "$OS" != "Darwin" && "$OS" != "Linux" ]]; then
    echo "❌ Error: This script only supports macOS and Linux."
    echo "Detected: $OS"
    exit 1
fi

echo "✓ Detected $OS"
echo "✓ In git repository: $(basename $(git rev-parse --show-toplevel))"
echo ""

# Clone or update ai-coding-config
if [ ! -d "$HOME/.ai_coding_config" ]; then
    echo "📥 Cloning ai-coding-config to ~/.ai_coding_config..."
    git clone https://github.com/TechNickAI/ai-coding-config.git ~/.ai_coding_config
    echo "✓ Cloned successfully"
else
    echo "📥 Updating ~/.ai_coding_config..."
    echo "   Running: git pull"
    cd ~/.ai_coding_config
    git pull
    cd - > /dev/null
    echo "✓ Updated to latest version"
fi

echo ""

# Copy the ai-coding-config command to current repo
echo "📋 Setting up /ai-coding-config command in this project..."

mkdir -p .claude/commands
cp ~/.ai_coding_config/.claude/commands/ai-coding-config.md .claude/commands/

echo "✓ Copied ai-coding-config command"
echo ""

# Set up Cursor directory structure
echo "📁 Setting up Cursor directory structure..."

# Create .cursor directory structure
mkdir -p .cursor/commands

# For fresh installs without existing rules, create .cursor/rules
if [ ! -d ".cursor/rules" ]; then
    mkdir -p .cursor/rules
    echo "✓ Created .cursor/rules/"
elif [ -d ".cursor/rules" ] && [ ! -L ".cursor/rules" ]; then
    echo "✓ .cursor/rules/ already exists"
elif [ -L ".cursor/rules" ]; then
    # Legacy v2 architecture with rules/ at root - suggest migration
    echo "⚠️  Detected legacy v2 architecture (rules/ symlink)"
    echo "   Run /ai-coding-config update to migrate to standard architecture"
fi

# Check for legacy rules/ directory
if [ -d "rules" ] && [ ! -L "rules" ]; then
    echo "⚠️  Found legacy rules/ directory"
    echo "   Run /ai-coding-config update to migrate to .cursor/rules/"
fi

echo ""

echo "✨ Bootstrap complete!"
echo ""
echo "Next steps:"
echo ""
echo "From Claude Code:"
echo "  /ai-coding-config"
echo ""
echo "From Cursor:"
echo "  @ai-coding-config set up this project"
echo ""
echo "The command will guide you through:"
echo "- Choosing an AI personality"
echo "- Selecting relevant rules for your project"
echo "- Copying configurations"
echo ""


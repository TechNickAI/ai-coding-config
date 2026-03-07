#!/bin/bash
set -e

echo "🚀 AI Coding Configuration Bootstrap"
echo ""

# Check OS
OS="$(uname -s)"
if [[ "$OS" != "Darwin" && "$OS" != "Linux" ]]; then
    echo "❌ Error: This script only supports macOS and Linux."
    echo "Detected: $OS"
    exit 1
fi

echo "✓ Detected $OS"

# Detect available AI coding tools
HAS_CLAUDE=false
HAS_CURSOR=false

if command -v claude &> /dev/null; then
    HAS_CLAUDE=true
    echo "✓ Found Claude Code"
fi

if [ -d ".cursor" ] || command -v cursor &> /dev/null || [ -d "/Applications/Cursor.app" ]; then
    HAS_CURSOR=true
    echo "✓ Found Cursor"
fi

if [ "$HAS_CLAUDE" = false ] && [ "$HAS_CURSOR" = false ]; then
    echo "ℹ️  No AI coding tools detected on PATH."
    echo "   Proceeding with file-based setup that works with any tool."
fi

echo ""

# ─── Claude Code Setup ───────────────────────────────────────────────
if [ "$HAS_CLAUDE" = true ]; then
    echo "📦 Setting up Claude Code plugin..."

    # Add marketplace (claude plugin commands use terminal UI that suppresses output)
    echo "   Adding marketplace..."
    if ! claude plugin marketplace add https://github.com/TechNickAI/ai-coding-config > /dev/null 2>&1; then
        echo "⚠️  Marketplace add may have failed. If /ai-coding-config doesn't work, run manually:"
        echo "   /plugin marketplace add https://github.com/TechNickAI/ai-coding-config"
    else
        echo "✓ Marketplace configured"
    fi

    # Install the plugin
    echo "   Installing plugin..."
    if ! claude plugin install ai-coding-config > /dev/null 2>&1; then
        echo "⚠️  Plugin install may have failed. Try manually in Claude Code:"
        echo "   /plugin install ai-coding-config"
    else
        echo "✓ Plugin installed"
    fi

    echo ""
    echo "✨ Claude Code setup complete!"
    echo ""
    echo "Next step — run this in Claude Code:"
    echo "  /ai-coding-config"
    echo ""
fi

# ─── Cursor / Other Tools Setup ──────────────────────────────────────
if [ "$HAS_CURSOR" = true ] || [ "$HAS_CLAUDE" = false ]; then

    # Check if we're in a git repository (needed for file-copy approach)
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        if [ "$HAS_CLAUDE" = true ]; then
            # Claude setup already succeeded above, just skip Cursor setup
            exit 0
        fi
        echo "❌ Error: You're not in a git repository."
        echo ""
        echo "Move into a project directory first:"
        echo "  cd ~/your-project"
        echo ""
        echo "Then run this script again."
        exit 1
    fi

    echo "📁 Setting up for Cursor / other AI tools..."
    echo "✓ In git repository: $(basename $(git rev-parse --show-toplevel))"
    echo ""

    # Clone or update ai-coding-config
    if [ ! -d "$HOME/.ai_coding_config" ]; then
        echo "📥 Cloning ai-coding-config to ~/.ai_coding_config..."
        if ! git clone https://github.com/TechNickAI/ai-coding-config.git ~/.ai_coding_config; then
            echo "❌ Failed to clone. Check your internet connection and try again."
            exit 1
        fi
        echo "✓ Cloned successfully"
    else
        echo "📥 Updating ~/.ai_coding_config..."
        (cd ~/.ai_coding_config && git pull) || echo "⚠️  Update failed. Continuing with existing version."
        echo "✓ Updated to latest version"
    fi

    echo ""

    # Copy the ai-coding-config command to current repo
    echo "📋 Setting up /ai-coding-config command..."
    mkdir -p .claude/commands
    cp ~/.ai_coding_config/.claude/commands/ai-coding-config.md .claude/commands/
    echo "✓ Copied ai-coding-config command"

    # Set up Cursor directory structure
    mkdir -p .cursor/commands

    if [ ! -d ".cursor/rules" ]; then
        mkdir -p .cursor/rules
        echo "✓ Created .cursor/rules/"
    elif [ -L ".cursor/rules" ]; then
        echo "⚠️  Detected legacy v2 architecture (rules/ symlink)"
        echo "   Run /ai-coding-config update to migrate to standard architecture"
    else
        echo "✓ .cursor/rules/ already exists"
    fi

    if [ -d "rules" ] && [ ! -L "rules" ]; then
        echo "⚠️  Found legacy rules/ directory"
        echo "   Run /ai-coding-config update to migrate to .cursor/rules/"
    fi

    echo ""
    echo "✨ Setup complete!"
    echo ""
    echo "Next steps:"
    echo ""
    echo "  Claude Code:  /ai-coding-config"
    echo "  Cursor:       @ai-coding-config set up this project"
    echo ""
    echo "The command will guide you through:"
    echo "  - Choosing an AI personality"
    echo "  - Selecting relevant rules for your project"
    echo "  - Copying configurations"
    echo ""
fi

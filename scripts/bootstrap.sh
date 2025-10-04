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

# Clone ai-coding-config if not present
if [ ! -d "$HOME/.ai_coding_config" ]; then
    echo "📥 Cloning ai-coding-config to ~/.ai_coding_config..."
    git clone https://github.com/TechNickAI/ai-coding-config.git ~/.ai_coding_config
    echo "✓ Cloned successfully"
else
    echo "✓ ~/.ai_coding_config already exists"
fi

echo ""

# Copy the ai-coding-config command to current repo
echo "📋 Setting up /ai-coding-config command in this project..."

mkdir -p .claude/commands
cp ~/.ai_coding_config/.claude/commands/ai-coding-config.md .claude/commands/

echo "✓ Copied ai-coding-config command"
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


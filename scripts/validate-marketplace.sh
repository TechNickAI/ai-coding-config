#!/usr/bin/env bash
#
# Validates marketplace.json consistency with individual plugin.json files
# - Checks that tags in marketplace.json match keywords in plugin.json
# - Validates JSON syntax
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
MARKETPLACE_FILE="$ROOT_DIR/.claude-plugin/marketplace.json"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

errors=0

echo "Validating marketplace configuration..."
echo ""

# Check jq is available
if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: jq is required but not installed${NC}"
    exit 1
fi

# Validate marketplace.json syntax
echo "Checking JSON syntax..."
if ! jq empty "$MARKETPLACE_FILE" 2>/dev/null; then
    echo -e "${RED}Error: Invalid JSON in marketplace.json${NC}"
    exit 1
fi
echo -e "${GREEN}JSON syntax valid${NC}"
echo ""

# Get plugin root from metadata
PLUGIN_ROOT=$(jq -r '.metadata.pluginRoot // "."' "$MARKETPLACE_FILE")

# Validate each plugin's keyword consistency
echo "Checking keyword consistency..."
echo ""

# Get plugin count
plugin_count=$(jq '.plugins | length' "$MARKETPLACE_FILE")

for i in $(seq 0 $((plugin_count - 1))); do
    # Get plugin info from marketplace
    plugin_name=$(jq -r ".plugins[$i].name" "$MARKETPLACE_FILE")
    plugin_source=$(jq -r ".plugins[$i].source" "$MARKETPLACE_FILE")
    marketplace_tags=$(jq -c ".plugins[$i].tags // []" "$MARKETPLACE_FILE")

    # Construct path to plugin.json
    plugin_json_path="$ROOT_DIR/$PLUGIN_ROOT/$plugin_source/.claude-plugin/plugin.json"

    if [[ ! -f "$plugin_json_path" ]]; then
        echo -e "${RED}  $plugin_name: plugin.json not found at $plugin_json_path${NC}"
        ((errors++))
        continue
    fi

    # Get keywords from plugin.json
    plugin_keywords=$(jq -c '.keywords // []' "$plugin_json_path")

    # Sort both arrays for comparison
    sorted_tags=$(echo "$marketplace_tags" | jq -c 'sort')
    sorted_keywords=$(echo "$plugin_keywords" | jq -c 'sort')

    if [[ "$sorted_tags" == "$sorted_keywords" ]]; then
        echo -e "${GREEN}  $plugin_name: keywords match${NC}"
    else
        echo -e "${RED}  $plugin_name: keyword mismatch${NC}"
        echo -e "    marketplace.json tags: $marketplace_tags"
        echo -e "    plugin.json keywords:  $plugin_keywords"

        # Show the diff
        tags_only=$(echo "$marketplace_tags" | jq -c --argjson kw "$plugin_keywords" '. - $kw')
        keywords_only=$(echo "$plugin_keywords" | jq -c --argjson tags "$marketplace_tags" '. - $tags')

        if [[ "$tags_only" != "[]" ]]; then
            echo -e "${YELLOW}    Only in marketplace tags: $tags_only${NC}"
        fi
        if [[ "$keywords_only" != "[]" ]]; then
            echo -e "${YELLOW}    Only in plugin keywords: $keywords_only${NC}"
        fi
        ((errors++))
    fi
done

echo ""
if [[ $errors -gt 0 ]]; then
    echo -e "${RED}Validation failed with $errors error(s)${NC}"
    exit 1
else
    echo -e "${GREEN}All validations passed${NC}"
    exit 0
fi

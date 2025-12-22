#!/usr/bin/env bash
#
# Validates marketplace.json against Claude Code's schema requirements
# and checks consistency with individual plugin.json files.
#
# Schema validations:
# - Required fields: name, source, description, version
# - source must start with "./"
# - plugins array must not be empty
#
# Consistency validations:
# - tags in marketplace.json should match keywords in plugin.json
# - plugin.json must exist at the source path
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
echo "=== JSON Syntax ==="
if ! jq empty "$MARKETPLACE_FILE" 2>/dev/null; then
    echo -e "${RED}✗ Invalid JSON in marketplace.json${NC}"
    exit 1
fi
echo -e "${GREEN}✓ JSON syntax valid${NC}"
echo ""

# Validate required top-level fields
echo "=== Marketplace Schema ==="

# Check name field
name=$(jq -r '.name // empty' "$MARKETPLACE_FILE")
if [[ -z "$name" ]]; then
    echo -e "${RED}✗ Missing required field: name${NC}"
    errors=$((errors + 1))
else
    echo -e "${GREEN}✓ name: $name${NC}"
fi

# Check metadata.pluginRoot
plugin_root=$(jq -r '.metadata.pluginRoot // empty' "$MARKETPLACE_FILE")
if [[ -z "$plugin_root" ]]; then
    echo -e "${YELLOW}⚠ Missing metadata.pluginRoot (using default '.')${NC}"
    plugin_root="."
else
    echo -e "${GREEN}✓ metadata.pluginRoot: $plugin_root${NC}"
fi

# Check plugins array exists and is not empty
plugin_count=$(jq '.plugins | length' "$MARKETPLACE_FILE")
if [[ "$plugin_count" -eq 0 ]]; then
    echo -e "${RED}✗ plugins array is empty${NC}"
    errors=$((errors + 1))
else
    echo -e "${GREEN}✓ plugins: $plugin_count entries${NC}"
fi
echo ""

# Validate each plugin's schema
echo "=== Plugin Schema Validation ==="
echo ""

for i in $(seq 0 $((plugin_count - 1))); do
    plugin_name=$(jq -r ".plugins[$i].name // empty" "$MARKETPLACE_FILE")
    plugin_source=$(jq -r ".plugins[$i].source // empty" "$MARKETPLACE_FILE")
    plugin_desc=$(jq -r ".plugins[$i].description // empty" "$MARKETPLACE_FILE")
    plugin_version=$(jq -r ".plugins[$i].version // empty" "$MARKETPLACE_FILE")

    plugin_errors=0
    echo "Plugin: ${plugin_name:-"(unnamed)"}"

    # Check required fields
    if [[ -z "$plugin_name" ]]; then
        echo -e "  ${RED}✗ Missing required field: name${NC}"
        plugin_errors=$((plugin_errors + 1))
    fi

    if [[ -z "$plugin_source" ]]; then
        echo -e "  ${RED}✗ Missing required field: source${NC}"
        plugin_errors=$((plugin_errors + 1))
    elif [[ "$plugin_source" != ./* ]]; then
        echo -e "  ${RED}✗ source must start with './' (got: $plugin_source)${NC}"
        plugin_errors=$((plugin_errors + 1))
    fi

    if [[ -z "$plugin_desc" ]]; then
        echo -e "  ${RED}✗ Missing required field: description${NC}"
        plugin_errors=$((plugin_errors + 1))
    fi

    if [[ -z "$plugin_version" ]]; then
        echo -e "  ${RED}✗ Missing required field: version${NC}"
        plugin_errors=$((plugin_errors + 1))
    fi

    if [[ $plugin_errors -eq 0 ]]; then
        echo -e "  ${GREEN}✓ Schema valid${NC}"
    else
        errors=$((errors + plugin_errors))
    fi
done
echo ""

# Validate plugin paths and keyword consistency
echo "=== Plugin Consistency ==="
echo ""

for i in $(seq 0 $((plugin_count - 1))); do
    plugin_name=$(jq -r ".plugins[$i].name" "$MARKETPLACE_FILE")
    plugin_source=$(jq -r ".plugins[$i].source" "$MARKETPLACE_FILE")
    marketplace_tags=$(jq -c ".plugins[$i].tags // []" "$MARKETPLACE_FILE")

    # Strip leading "./" from source for path construction
    source_path="${plugin_source#./}"

    # Construct path to plugin.json
    plugin_json_path="$ROOT_DIR/$plugin_root/$source_path/.claude-plugin/plugin.json"

    echo "Plugin: $plugin_name"

    if [[ ! -f "$plugin_json_path" ]]; then
        echo -e "  ${RED}✗ plugin.json not found at: $plugin_json_path${NC}"
        errors=$((errors + 1))
        continue
    fi
    echo -e "  ${GREEN}✓ plugin.json exists${NC}"

    # Get keywords from plugin.json
    plugin_keywords=$(jq -c '.keywords // []' "$plugin_json_path")

    # Sort both arrays for comparison
    sorted_tags=$(echo "$marketplace_tags" | jq -c 'sort')
    sorted_keywords=$(echo "$plugin_keywords" | jq -c 'sort')

    if [[ "$sorted_tags" == "$sorted_keywords" ]]; then
        echo -e "  ${GREEN}✓ Keywords match${NC}"
    else
        echo -e "  ${RED}✗ Keyword mismatch${NC}"
        echo -e "    marketplace tags: $marketplace_tags"
        echo -e "    plugin keywords:  $plugin_keywords"

        # Show the diff
        tags_only=$(echo "$marketplace_tags" | jq -c --argjson kw "$plugin_keywords" '. - $kw')
        keywords_only=$(echo "$plugin_keywords" | jq -c --argjson tags "$marketplace_tags" '. - $tags')

        if [[ "$tags_only" != "[]" ]]; then
            echo -e "    ${YELLOW}Only in marketplace: $tags_only${NC}"
        fi
        if [[ "$keywords_only" != "[]" ]]; then
            echo -e "    ${YELLOW}Only in plugin: $keywords_only${NC}"
        fi
        errors=$((errors + 1))
    fi
done

echo ""
echo "=== Summary ==="
if [[ $errors -gt 0 ]]; then
    echo -e "${RED}Validation failed with $errors error(s)${NC}"
    exit 1
else
    echo -e "${GREEN}All validations passed${NC}"
    exit 0
fi

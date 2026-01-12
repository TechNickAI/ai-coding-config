#!/usr/bin/env python3
"""
Validate YAML frontmatter in markdown files for ai-coding-config plugin files.

Schemas:
- Commands (.claude/commands/): description required
- Agents (.claude/agents/): name, description, color required; description starts with "Use when"
- Skills (.claude/skills/): name, description, triggers, category required
- Cursor rules (.cursor/rules/): description required

Usage: python scripts/validate-frontmatter.py [files...]

Note: pyyaml is installed automatically by pre-commit via additional_dependencies.
"""

import re
import sys
from pathlib import Path

import yaml

# Valid agent colors per color scheme
VALID_COLORS = {"red", "orange", "yellow", "green", "cyan", "blue", "purple", "magenta"}

# Valid model values for Claude Code
VALID_MODELS = {"haiku", "sonnet", "opus", "inherit"}


def extract_frontmatter(content: str) -> tuple[dict | None, str | None]:
    """Extract YAML frontmatter from markdown content.

    Returns (None, error_msg) for files without or with invalid frontmatter.
    Returns (data, None) for valid frontmatter.
    """
    match = re.match(r"^---\s*\n(.*?)\n---", content, re.DOTALL)
    if not match:
        return None, "No frontmatter found (must start with ---)"

    frontmatter_text = match.group(1)

    # Strip prettier-ignore comments before parsing
    lines = [
        line
        for line in frontmatter_text.split("\n")
        if line.strip() != "# prettier-ignore"
    ]

    try:
        data = yaml.safe_load("\n".join(lines))
        return data, None
    except yaml.YAMLError as e:
        return None, f"Invalid YAML: {e}"


def validate_command(data: dict, filepath: Path) -> list[str]:
    """Validate Claude Code command frontmatter."""
    errors = []

    if "description" not in data:
        errors.append("Missing required field: description")
    elif not isinstance(data["description"], str):
        errors.append("description must be a string (quote it)")

    if "model" in data and data["model"] not in VALID_MODELS:
        errors.append(f"Invalid model '{data['model']}'. Valid: {VALID_MODELS}")

    if "argument-hint" in data:
        hint = data["argument-hint"]
        if hint == "":
            errors.append("argument-hint is empty string - remove if not needed")
        elif isinstance(hint, list):
            suggested = f"[{hint[0]}]" if len(hint) == 1 else str(hint)
            errors.append(
                f"argument-hint parsed as array {hint} - quote it: "
                f'argument-hint: "{suggested}"'
            )

    return errors


def validate_agent(data: dict, filepath: Path) -> list[str]:
    """Validate Claude Code agent frontmatter."""
    errors = []

    for field in ["name", "description", "color"]:
        if field not in data:
            errors.append(f"Missing required field: {field}")

    if "description" in data:
        desc = data["description"]
        if not isinstance(desc, str):
            errors.append("description must be a string (quote it)")
        elif not desc.startswith("Use when"):
            errors.append('Agent description should start with "Use when..."')

    if "color" in data and data["color"] not in VALID_COLORS:
        errors.append(f"Invalid color '{data['color']}'. Valid: {VALID_COLORS}")

    if "model" in data and data["model"] not in VALID_MODELS:
        errors.append(f"Invalid model '{data['model']}'. Valid: {VALID_MODELS}")

    return errors


def validate_skill(data: dict, filepath: Path) -> list[str]:
    """Validate Claude Code skill frontmatter."""
    errors = []

    for field in ["name", "description", "triggers", "category"]:
        if field not in data:
            errors.append(f"Missing required field: {field}")

    if "description" in data:
        desc = data["description"]
        if not isinstance(desc, str):
            errors.append("description must be a string (quote it)")
        elif not desc.startswith("Use when"):
            errors.append('Skill description should start with "Use when..."')

    if "triggers" in data:
        if not isinstance(data["triggers"], list):
            errors.append("triggers must be an array")
        elif len(data["triggers"]) == 0:
            errors.append("triggers array is empty")

    return errors


def validate_cursor_rule(data: dict, filepath: Path) -> list[str]:
    """Validate Cursor rule frontmatter (.mdc files)."""
    errors = []

    if "description" not in data:
        errors.append("Missing required field: description")

    if "alwaysApply" in data:
        val = data["alwaysApply"]
        if val not in (True, False):
            errors.append(f"alwaysApply must be true or false, got: {val}")

    return errors


def determine_type(filepath: Path) -> str | None:
    """Determine file type from path."""
    parts = filepath.parts

    if filepath.suffix == ".mdc":
        return "cursor_rule"
    if "commands" in parts:
        return "command"
    if "agents" in parts:
        return "agent"
    if "skills" in parts:
        return "skill"

    return None


def validate_file(filepath: Path) -> list[str]:
    """Validate a single file's frontmatter."""
    content = filepath.read_text()

    data, error = extract_frontmatter(content)
    if error:
        return [error]

    if not data:
        return ["Frontmatter parsed but is empty"]

    file_type = determine_type(filepath)
    validators = {
        "command": validate_command,
        "agent": validate_agent,
        "skill": validate_skill,
        "cursor_rule": validate_cursor_rule,
    }

    validator = validators.get(file_type)
    if validator:
        return validator(data, filepath)
    return [f"Unknown file type for path: {filepath}"]


def main():
    if len(sys.argv) < 2:
        print("Usage: validate-frontmatter.py <file1> [file2] ...")
        sys.exit(1)

    has_errors = False

    for filepath in map(Path, sys.argv[1:]):
        if not filepath.exists():
            print(f"ERROR: {filepath}: File not found")
            has_errors = True
            continue

        errors = validate_file(filepath)
        if errors:
            has_errors = True
            print(f"ERROR: {filepath}:")
            for error in errors:
                print(f"  - {error}")

    sys.exit(1 if has_errors else 0)


if __name__ == "__main__":
    main()

# CLAUDE.md - Guidelines for AI Assistance

## Build/Setup Commands
- `./bootstrap.sh` - Main setup script for dotfiles
- No explicit lint/test commands (dotfiles repository)
- Use `which <command>` to verify tool availability
- For Hammerspoon: `osascript -e 'tell application "Hammerspoon" to reload'`

## Code Style Guidelines
- Shell scripts use bash (`#!/usr/bin/env bash`)
- Use 4-space indentation
- Variables in UPPER_CASE for constants, lowercase for local scope
- Always quote variables: `"$variable"` not $variable
- Use `command -v` for command existence checks: `if command -v tool >/dev/null 2>&1; then`
- Prefer `[[` over `[` for conditionals
- Functions should have descriptive names in snake_case
- Functions should check dependencies before using them
- Use comments for non-obvious code and function documentation
- Follow defensive programming: validate paths, check for errors
- For Git configuration, use delta for diffs when available
- Prefer long flag options (--version) except for common flags like rm -r, ls -la
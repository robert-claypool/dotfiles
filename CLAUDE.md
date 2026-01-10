# CLAUDE.md - Guidelines for AI Assistance

All task tracking goes through bd. No other TODO systems.

## Beads (bd) + Beads Viewer (bv)

Beads captures decisions in a dependency-aware graph. Source-controlled,
branch-aware. Track config decisions and their rationale.

```bash
bd ready --json                    # What's ready to work on
bd create "Title" -t task --json   # Create new task
bd close <id> --reason "..." --json # Close with outcome
bd comments add <id> "..." --json  # Add context during work
bv --robot-triage                  # Unified analysis
bv --robot-next                    # Top recommendation
```

Key invariants:
- `.beads/` is authoritative state; always commit with code changes
- Do not edit `.beads/*.jsonl` directly; only via bd

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
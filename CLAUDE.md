# CLAUDE.md - Guidelines for AI Assistance

## Build/Setup Commands
- `./bootstrap.sh` - Main setup script for dotfiles
- `bin/check` - Quality gates (shell syntax, shellcheck, formatting)
- Use `which <command>` to verify tool availability

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

<!-- ksmem:onboard:start -->
## Keystone Memory

This project uses ksmem for structured memory management.

- Prefer ksmem CLI for all memory operations (tool precedence rule)
- Run ksmem show context at session start for orientation
- Run ksmem show surface to see canonical command recipes
- Use stdin for prose input: echo "..." | ksmem note stone <id>

Delegation posture (co-equal builder under guardrails):

- Treat specs as high-fidelity intent, not literal scripts
- Preserve hard invariants and explicit acceptance criteria
- Improve implementation details when a better path exists
- Explain deviations and land code, tests, and docs together
<!-- ksmem:onboard:end -->

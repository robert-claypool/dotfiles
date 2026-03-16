#!/usr/bin/env python3
"""
Dotfiles Reminder Hook

Injects context reminders at strategic points:
- SessionStart: Full reminder (fresh session)
- PreCompact: Sets flag for post-compaction full reminder
- UserPromptSubmit: Full after compaction, compact otherwise
"""

import json
import sys
from pathlib import Path

# State file for tracking compaction
STATE_FILE = Path.home() / ".claude" / "dotfiles-reminder-state.json"

FULL_REMINDER = """
Continuing work on dotfiles. Context may have been lost.

---
CORE PRINCIPLES
---

Fail fast, fail loud.
  No fallbacks. Let failures crash. Shell configs should error visibly.

POSIX when possible.
  Prefer portable constructs. Note when something is bash/zsh-specific.

Public repo.
  This is part of an online portfolio. Code quality matters.

---
COMPOUND ENGINEERING
---

Plan -> Work -> Review -> Compound

PLAN: Before changes, outline:
  - What's being changed and why
  - Portability considerations (bash vs zsh vs POSIX)
  - Testing approach (how to verify it works)

WORK: Make changes incrementally. Test in a fresh shell.

REVIEW: Verify:
  - No syntax errors (shellcheck if available)
  - Works in target shells (bash, zsh as needed)
  - No secrets or machine-specific paths committed

COMPOUND: Capture learnings in ksmem.

---
DOTFILES BEST PRACTICES
---

Shell startup order matters.
  .zprofile (login) -> .zshrc (interactive)
  .bash_profile (login) -> .bashrc (interactive)

Environment vs aliases.
  Export env vars in profile. Define aliases/functions in rc.

Shared config.
  .bashrc_shared for config that works in both bash and zsh.

Machine-specific config.
  Keep in .secrets or .local files that are gitignored.

---

Context decays. The work compounds when continuity is maintained.
""".strip()

COMPACT_REMINDER = """
<reminders>1. This is a public repo. Ensure no secrets, machine-specific paths, or low-quality code gets committed. 2. Test shell changes in a fresh shell before considering them done.</reminders>
""".strip()


def load_state() -> dict:
    """Load state from file, or return defaults."""
    try:
        if STATE_FILE.exists():
            return json.loads(STATE_FILE.read_text())
    except (json.JSONDecodeError, OSError):
        pass
    return {
        "precompact_pending": False,
        "session_id": None
    }


def save_state(state: dict) -> None:
    """Save state to file."""
    try:
        STATE_FILE.parent.mkdir(parents=True, exist_ok=True)
        STATE_FILE.write_text(json.dumps(state, indent=2))
    except OSError:
        pass  # Best effort


def main():
    # Read hook input from stdin
    try:
        hook_input = json.load(sys.stdin)
    except json.JSONDecodeError:
        sys.exit(0)  # Silent failure if no valid input

    event = hook_input.get("hook_event_name", "")
    session_id = hook_input.get("session_id", "")

    state = load_state()

    # Reset state on new session
    if state.get("session_id") != session_id:
        state = {
            "precompact_pending": False,
            "session_id": session_id
        }

    if event == "SessionStart":
        # Full reminder on session start (fresh context)
        print(FULL_REMINDER)
        save_state(state)
        sys.exit(0)

    elif event == "PreCompact":
        # Set flag for post-compaction reminder
        state["precompact_pending"] = True
        save_state(state)
        sys.exit(0)

    elif event == "UserPromptSubmit":
        # Full reminder only after compaction (context actually lost)
        if state.get("precompact_pending"):
            print(FULL_REMINDER)
            state["precompact_pending"] = False
        else:
            # Compact reminder on every turn
            print(COMPACT_REMINDER)

        save_state(state)
        sys.exit(0)

    # Unknown event - do nothing
    sys.exit(0)


if __name__ == "__main__":
    main()

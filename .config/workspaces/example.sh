# shellcheck shell=bash
#
# Public example workspace. Copy to .config/workspaces/local/<name>.sh for
# private project URLs, Chrome profile directories, and machine-specific paths.

WS_LABEL="EXAMPLE"

# Chrome: use Chrome's Window > Name Window... with this same name for stable
# focus. WS_CHROME_PROFILE is Chrome's profile directory, such as "Default" or
# "Profile 3"; keep real account/profile mappings in local ignored files.
WS_CHROME_WINDOW="EXAMPLE"
WS_CHROME_PROFILE=""
WS_CHROME_URLS=(
    "https://github.com/robert-claypool/dotfiles"
)

# Ghostty: focus by window title, then optionally select tabs by number/name.
WS_GHOSTTY_WINDOW="EXAMPLE"
WS_GHOSTTY_DIR="$HOME/git/dotfiles"
WS_GHOSTTY_TABS=(
    "vim"
    "server"
    "codex"
    "git"
)

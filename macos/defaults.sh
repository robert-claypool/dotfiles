#!/usr/bin/env bash
set -euo pipefail

ACTION="${1:-plan}"
CHANGES=0

usage() {
    cat <<'EOF'
Usage: macos/defaults.sh plan|apply

Plan reports drift. Apply writes only drifted values and does not restart Dock,
Finder, or the current session; that disruption remains an explicit choice.
EOF
}

normalize_value() {
    local value_type="$1"
    local value="$2"

    case "$value_type" in
        bool)
            case "$value" in
                1 | true | TRUE | yes | YES) printf 'true' ;;
                0 | false | FALSE | no | NO) printf 'false' ;;
                *) printf '%s' "$value" ;;
            esac
            ;;
        *) printf '%s' "$value" ;;
    esac
}

write_value() {
    local domain="$1"
    local key="$2"
    local value_type="$3"
    local desired="$4"

    case "$value_type" in
        bool) defaults write "$domain" "$key" -bool "$desired" ;;
        int) defaults write "$domain" "$key" -int "$desired" ;;
        string) defaults write "$domain" "$key" -string "$desired" ;;
        *)
            printf 'Unsupported defaults type: %s\n' "$value_type" >&2
            return 2
            ;;
    esac
}

setting() {
    local domain="$1"
    local key="$2"
    local value_type="$3"
    local desired="$4"
    local description="$5"
    local current=""
    local normalized_current=""

    current="$(defaults read "$domain" "$key" 2>/dev/null || printf '<unset>')"
    normalized_current="$(normalize_value "$value_type" "$current")"
    if [[ "$normalized_current" == "$desired" ]]; then
        printf 'ok      %-38s %s\n' "$description" "$desired"
        return 0
    fi

    CHANGES=$((CHANGES + 1))
    if [[ "$ACTION" == "plan" ]]; then
        printf 'change  %-38s %s -> %s\n' "$description" "$normalized_current" "$desired"
    else
        write_value "$domain" "$key" "$value_type" "$desired"
        printf 'wrote   %-38s %s -> %s\n' "$description" "$normalized_current" "$desired"
    fi
}

main() {
    case "$ACTION" in
        -h | --help)
            usage
            return 0
            ;;
        plan | apply) ;;
        *)
            usage >&2
            return 2
            ;;
    esac

    if [[ "$(uname -s)" != "Darwin" ]]; then
        printf 'macOS defaults are only applicable on Darwin.\n' >&2
        return 1
    fi
    command -v defaults >/dev/null 2>&1 || {
        printf 'defaults command not found.\n' >&2
        return 127
    }

    setting NSGlobalDomain KeyRepeat int 2 "keyboard repeat interval"
    setting NSGlobalDomain InitialKeyRepeat int 15 "keyboard repeat delay"
    setting NSGlobalDomain ApplePressAndHoldEnabled bool false "press-and-hold accents"
    setting NSGlobalDomain AppleShowAllExtensions bool true "show filename extensions"

    setting com.apple.finder FXPreferredViewStyle string Nlsv "Finder default list view"
    setting com.apple.finder ShowPathbar bool true "Finder path bar"
    setting com.apple.finder ShowStatusBar bool true "Finder status bar"
    setting com.apple.finder _FXShowPosixPathInTitle bool true "Finder POSIX path in title"
    setting com.apple.finder FXEnableExtensionChangeWarning bool false "extension-change warning"

    setting com.apple.dock autohide bool false "Dock auto-hide"
    setting com.apple.dock tilesize int 43 "Dock tile size"
    setting com.apple.dock show-recents bool false "Dock recent applications"
    setting com.apple.dock mineffect string genie "Dock minimize effect"
    setting com.apple.dock mru-spaces bool false "stable Spaces ordering"

    setting com.apple.desktopservices DSDontWriteNetworkStores bool true "no .DS_Store on network volumes"
    setting com.apple.desktopservices DSDontWriteUSBStores bool true "no .DS_Store on USB volumes"

    printf '\n%d setting(s) %s.\n' "$CHANGES" "$([[ "$ACTION" == "plan" ]] && printf 'would change' || printf 'changed')"
    if [[ "$ACTION" == "apply" && "$CHANGES" -gt 0 ]]; then
        printf 'Restart Finder/Dock or log out when you want every change to take effect.\n'
    fi
}

main

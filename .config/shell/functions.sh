#!/usr/bin/env bash

# Shared helper functions for interactive shells (zsh + bash).
# Safe to source multiple times.

if [ -n "${DOTFILES_SHELL_FUNCTIONS_LOADED:-}" ]; then
    return 0
fi
DOTFILES_SHELL_FUNCTIONS_LOADED=1

_dotfiles_clipboard_copy() {
    if command -v pbcopy >/dev/null 2>&1; then
        pbcopy
        return 0
    fi
    if command -v wl-copy >/dev/null 2>&1; then
        wl-copy
        return 0
    fi
    if command -v xclip >/dev/null 2>&1; then
        xclip -selection clipboard
        return 0
    fi
    if command -v xsel >/dev/null 2>&1; then
        xsel --clipboard --input
        return 0
    fi
    return 1
}

favorites() {
    local num
    num="${1:-10}"
    history | awk '{print $2}' | sort | uniq -c | sort -rn | head -n "$num"
}

gitf() {
    command -v git >/dev/null 2>&1 || return 1
    command -v fzf >/dev/null 2>&1 || return 1
    local branch
    branch="$(git branch --all | sed 's/^[* ]*//' | fzf | sed 's#^remotes/origin/##')"
    [ -n "$branch" ] && git checkout "$branch"
}

killf() {
    command -v fzf >/dev/null 2>&1 || return 1
    local pid
    pid="$(ps -ef | sed 1d | fzf -m | awk '{print $2}')"
    [ -n "$pid" ] && kill -"${1:-9}" "$pid"
}

vf() {
    command -v nvim >/dev/null 2>&1 || return 1
    command -v fzf >/dev/null 2>&1 || return 1
    local file
    if command -v bat >/dev/null 2>&1; then
        file="$(fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}')"
    else
        file="$(fzf --preview 'cat {}')"
    fi
    [ -n "$file" ] && nvim "$file"
}

vsf() {
    command -v code >/dev/null 2>&1 || return 1
    command -v fzf >/dev/null 2>&1 || return 1
    local file
    if command -v bat >/dev/null 2>&1; then
        file="$(fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}')"
    else
        file="$(fzf --preview 'cat {}')"
    fi
    [ -n "$file" ] && code "$file"
}

rgf() {
    command -v rg >/dev/null 2>&1 || return 1
    command -v fzf >/dev/null 2>&1 || return 1
    local file line
    local preview_cmd
    if command -v bat >/dev/null 2>&1; then
        preview_cmd='bat --color=always --highlight-line {2} {1}'
    else
        preview_cmd='sed -n "1,200p" {1}'
    fi
    # shellcheck disable=SC2162
    read -r file line <<EOF
$(rg --line-number . | fzf -d ':' --preview "$preview_cmd" | awk -F: '{print $1, $2}')
EOF
    if [ -n "$file" ]; then
        ${EDITOR:-nvim} "$file" +"$line"
    fi
}

commitf() {
    command -v git >/dev/null 2>&1 || return 1
    command -v fzf >/dev/null 2>&1 || return 1
    local commit
    commit="$(git log --oneline --color=always | fzf --ansi --preview 'git show --color=always {1}' | awk '{print $1}')"
    [ -n "$commit" ] && git checkout "$commit"
}

stashf() {
    command -v git >/dev/null 2>&1 || return 1
    command -v fzf >/dev/null 2>&1 || return 1
    local stash
    stash="$(git stash list | fzf --preview 'git stash show --color=always {1}' | cut -d: -f1)"
    [ -n "$stash" ] && git stash apply "$stash"
}

envf() {
    command -v fzf >/dev/null 2>&1 || return 1
    local selection
    selection="$(printenv | fzf || true)"
    if [ -n "$selection" ]; then
        if printf '%s' "$selection" | _dotfiles_clipboard_copy; then
            printf 'Copied to clipboard: %s\n' "$selection"
        else
            printf '%s\n' "$selection"
        fi
    fi
}

extract() {
    if [ $# -lt 1 ]; then
        printf 'Usage: extract <archive>\n'
        return 1
    fi
    if [ ! -f "$1" ]; then
        printf "'%s' is not a valid file\n" "$1"
        return 1
    fi
    case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz) tar xzf "$1" ;;
        *.bz2) bunzip2 "$1" ;;
        *.rar) unrar e "$1" ;;
        *.gz) gunzip "$1" ;;
        *.tar) tar xf "$1" ;;
        *.tbz2) tar xjf "$1" ;;
        *.tgz) tar xzf "$1" ;;
        *.zip) unzip "$1" ;;
        *.Z) uncompress "$1" ;;
        *.7z) 7z x "$1" ;;
        *) printf "'%s' cannot be extracted via extract()\n" "$1" ;;
    esac
}

# Safer delete: `del` moves things to Trash when available.
# - macOS: `trash` (brew install trash)
# - Linux: `trash-put` (trash-cli)
_dotfiles_del_usage() {
    printf 'Usage: del [-f] [-v] <path>...\n'
}

_dotfiles_del_via_trash() {
    local trash_cmd
    trash_cmd="$1"
    shift

    local force=0 verbose=0
    local opt

    local old_optind="${OPTIND:-1}"
    OPTIND=1
    while getopts ":fRrdiIv" opt; do
        case "$opt" in
            f) force=1 ;;
            v) verbose=1 ;;
            r | R | d) : ;;
            i | I)
                printf 'del: interactive prompts are not supported (use rmd or rm -i).\n' >&2
                return 2
                ;;
            \?)
                printf 'del: unrecognized option -%s\n' "$OPTARG" >&2
                _dotfiles_del_usage >&2
                return 2
                ;;
        esac
    done
    shift $((OPTIND - 1))
    OPTIND="$old_optind"

    if [ "$#" -eq 0 ]; then
        _dotfiles_del_usage >&2
        return 2
    fi

    # `trash` doesn't support `--` to end options; ensure leading '-' args are treated as paths.
    local -a paths
    local path
    paths=()
    for path in "$@"; do
        if [[ "$path" == -* ]]; then
            paths+=("./$path")
        else
            paths+=("$path")
        fi
    done

    if [ "$force" -eq 1 ]; then
        local status=0
        for path in "${paths[@]}"; do
            if [ -e "$path" ] || [ -L "$path" ]; then
                if [ "$trash_cmd" = "trash" ] && [ "$verbose" -eq 1 ]; then
                    trash -v "$path" || status=$?
                else
                    "$trash_cmd" "$path" || status=$?
                fi
            fi
        done
        return $status
    fi

    if [ "$trash_cmd" = "trash" ] && [ "$verbose" -eq 1 ]; then
        trash -v "${paths[@]}"
    else
        "$trash_cmd" "${paths[@]}"
    fi
}

del() {
    if command -v trash >/dev/null 2>&1; then
        _dotfiles_del_via_trash trash "$@"
        return $?
    fi
    if command -v trash-put >/dev/null 2>&1; then
        _dotfiles_del_via_trash trash-put "$@"
        return $?
    fi
    printf "del: missing dependency ('trash' on macOS, 'trash-put' on Linux)\n" >&2
    return 127
}

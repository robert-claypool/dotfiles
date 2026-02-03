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

#!/usr/bin/env sh

# Shared aliases for interactive shells (zsh + bash).
# Safe to source multiple times.

if [ -n "${DOTFILES_SHELL_ALIASES_LOADED:-}" ]; then
    return 0
fi
DOTFILES_SHELL_ALIASES_LOADED=1

alias ..='cd ..'
alias cdh='cd ~/'
alias cdd='cd ~/downloads'

alias df='df -h'
alias du='du -h'
alias free='free -m'

alias dirsize='du -sh'
alias cpv='rsync -ah --info=progress2'

# Editor/tool aliases
if command -v nvim >/dev/null 2>&1; then
    alias vim='nvim'
fi
if command -v bat >/dev/null 2>&1; then
    alias cat='bat --paging=never'
fi

# Safer delete: prefer trash when available (macOS: `trash`, Linux: `trash-put`)
if command -v trash >/dev/null 2>&1; then
    alias rm='trash'
elif command -v trash-put >/dev/null 2>&1; then
    alias rm='trash-put'
fi

# Escape hatch for real rm
alias rmd='command rm -Iv'

# Use eza (modern ls) if available
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --group-directories-first'
    alias ll='eza -lahF --git --group-directories-first'
    alias lt='eza --tree --level=2'
    alias lg='eza -lahF --git --git-ignore'
else
    # macOS BSD ls (colors via -G)
    alias ls='ls -FG'
    alias ll='ls -lahGFT'
    alias la='ls -AGF'
    alias l='ls -CFG'
fi

# Quick directory navigation
alias ...='cd ../..'
alias ....='cd ../../..'

# Find stuff fast (fzf integration configured elsewhere)
if command -v fd >/dev/null 2>&1; then
    alias f='fd'
    alias ff='fd --type f'
    alias fdd='fd --type d'
else
    alias ff='find . -type f -name'
fi

# Terraform helpers (optional but handy)
alias tff='terraform fmt -recursive'
alias tfa='terraform apply'

alias killnode='pkill --signal SIGKILL node'

# Git aliases (minimal)
alias gst='git status'
alias ga='git add'
alias gp='git push'
alias gd='git diff'
alias gds='git diff --staged'
alias gl1='git log -1'
alias gl2='git log -2'
alias gl3='git log -3'

# Prefer ripgrep for interactive grep
if command -v rg >/dev/null 2>&1; then
    alias grep='rg --color=auto'
fi

# Quick cd to git root
cdg() {
    command cd "$(git rev-parse --show-toplevel 2>/dev/null)" || return 1
}


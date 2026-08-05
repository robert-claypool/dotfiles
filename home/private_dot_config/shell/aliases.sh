#!/usr/bin/env sh

# Add conveniences without changing the meaning of Unix primitives.
if [ -n "${DOTFILES_SHELL_ALIASES_LOADED:-}" ]; then
    return 0
fi
DOTFILES_SHELL_ALIASES_LOADED=1

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cdh='cd "$HOME"'
alias cdd='cd "$HOME/Downloads"'

alias dfh='df -h'
alias duh='du -h'
alias dirsize='du -sh'
alias cpv='rsync -ah --info=progress2'

if command -v nvim >/dev/null 2>&1; then
    alias vim='nvim'
fi

# Explicit enhanced views; ls, cat, and grep keep their standard behavior.
if command -v eza >/dev/null 2>&1; then
    alias ll='eza -lahF --git --group-directories-first'
    alias la='eza -a --group-directories-first'
    alias lt='eza --tree --level=2'
    alias lg='eza -lahF --git --git-ignore --group-directories-first'
else
    alias ll='ls -lahGFT'
    alias la='ls -AGF'
fi
if command -v bat >/dev/null 2>&1; then
    alias bcat='bat --paging=never'
fi

if command -v fd >/dev/null 2>&1; then
    alias f='fd'
    alias ff='fd --type f'
    alias fdd='fd --type d'
else
    alias ff='find . -type f -name'
fi

# Destructive commands remain visually explicit.
alias rmd='command rm -Iv'

alias gst='git status'
alias ga='git add'
alias gp='git push'
alias gd='git diff'
alias gds='git diff --staged'
alias gl1='git log -1'
alias gl2='git log -2'
alias gl3='git log -3'

alias tff='terraform fmt -recursive'
alias tfa='terraform apply'
alias killnode='pkill --signal SIGKILL node'

cdg() {
    command cd "$(git rev-parse --show-toplevel 2>/dev/null)" || return 1
}

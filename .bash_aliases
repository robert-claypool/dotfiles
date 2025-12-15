alias ..='cd ..'
alias cdh="cd ~/"
alias cdd="cd ~/downloads"

# alias python="python3"

alias cat="bat --paging=never"
alias vim="nvim"

alias tff="terraform fmt -recursive"
alias tfa="terraform apply"

# Caliber Dev CLI
alias cali="bun run ~/git/caliber/cli/dev.ts"
alias sfr="bun run cli/dev.ts system factory-reset"

# Use eza (modern ls) if available
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --group-directories-first'
    alias ll='eza -lahF --git --group-directories-first'
    alias lt='eza --tree --level=2'
    alias lg='eza -lahF --git --git-ignore'
else
    # Fallback to traditional ls with colors
    alias ls='ls -FG'
    alias ll='ls -lahGFT'
    alias la='ls -AGF'
    alias l='ls -CFG'
fi

# Quick directory navigation
# '..' is already defined earlier; keep a single source of truth.
alias ...='cd ../..'
alias ....='cd ../../..'

# Better defaults
alias df='df -h'
alias du='du -h'
alias free='free -m'

# Find stuff fast
if command -v fd >/dev/null 2>&1; then
    # Show hidden files by default, but keep common junk excluded.
    export FD_OPTIONS="${FD_OPTIONS:---hidden --exclude .git}"

    alias f='fd'
    alias ff='fd -t f'
    alias fdd='fd -t d'

    # Make fzf use fd (faster than `find`) if both are installed.
    if command -v fzf >/dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND='fd -t f --hidden --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd -t d --hidden --exclude .git'
    fi
else
    alias ff='find . -type f -name'
    alias fd='find . -type d -name'
fi

alias killnode="pkill --signal SIGKILL node"


# Ripgrep configuration moved to ~/.ripgreprc

# Show directory size
alias dirsize='du -sh'

# Copy with progress
alias cpv='rsync -ah --info=progress2'

# Quick cd to git root
alias cdg='cd $(git rev-parse --show-toplevel)'

# Show most used commands, with options for number of commands to show
favorites() {
    local num=${1:-10}  # Default to 10 if no argument provided
    history | awk '{print $2}' | sort | uniq -c | sort -rn | head -n "$num"
}

# Git aliases (only a few)
alias gst='git status'
alias ga='git add'
alias gp='git push'
alias gd='git diff'
alias gds='git diff --staged'
alias gl1='git log -1'
alias gl2='git log -1'
alias gl3='git log -1'

alias rm='rm -Iv'
alias grep='rg --color=auto'

# Flexoki theme switching
flexoki-toggle() {
    # Toggle macOS appearance
    osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to not dark mode'

    # Reload tmux config if in tmux
    if [ -n "$TMUX" ]; then
        tmux source-file ~/.tmux.conf
        tmux display-message "Theme toggled"
    fi
}

flexoki-dark() {
    # Set macOS to dark mode
    osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to true'

    # Set tmux theme if in tmux
    if [ -n "$TMUX" ]; then
        touch ~/.tmux/.flexoki-dark-active
        tmux source-file ~/.tmux/themes/flexoki-dark.tmuxtheme
        tmux display-message "Flexoki Dark theme loaded"
    fi
}

flexoki-light() {
    # Set macOS to light mode
    osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to false'

    # Set tmux theme if in tmux
    if [ -n "$TMUX" ]; then
        rm -f ~/.tmux/.flexoki-dark-active
        tmux source-file ~/.tmux/themes/flexoki-light.tmuxtheme
        tmux display-message "Flexoki Light theme loaded"
    fi
}

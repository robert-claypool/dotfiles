alias ..='cd ..'
alias cdh="cd ~/"
alias cdd="cd ~/downloads"

# alias python="python3"

alias cat="bat --paging=never"
alias vim="nvim"

alias tff="terraform fmt -recursive"
alias tfa="terraform apply"

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
    echo "eza not found, falling back to traditional ls"
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
alias ff='find . -type f -name'
alias fd='find . -type d -name'

alias killnode="pkill --signal SIGKILL node"

alias claude="/Users/rc/.claude/local/claude"

# Ripgrep with smart defaults
alias rg='rg --hidden --glob "!.git" --smart-case'

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

# Git aliases (only gst and ga as requested)
alias gst='git status -sb' # status (short/branch view)
alias ga='git add'

alias rm='rm -Iv'
alias grep='grep --color=auto'

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


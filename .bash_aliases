alias ..='cd ..'
alias cdh="cd ~/"
alias cdd="cd ~/downloads"
alias cdg="cd ~/git"

# alias python="python3"

alias cat="bat --paging=never"

# Use eza (modern ls) if available
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --group-directories-first --icons'
    alias ll='eza -lahF --git --group-directories-first --icons'
    alias lt='eza --tree --level=2 --icons'
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
alias ..='cd ..'
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

alias rm='rm -Iv'
alias grep='grep --color=auto'

alias sound="pavucontrol"
alias wifi="sudo wifi-menu -o"

# Create missing directories
alias mkdir='mkdir -pv'

# xclip -selection c will send data to the clipboard that works
# with ^C, ^V in most applications, http://stackoverflow.com/a/4208191
alias setclip='xclip -selection c'
alias getclip='xclip -selection clipboard -o'

# Screen brightness
alias b10="xbacklight -set 10"
alias b20="xbacklight -set 20"
alias b30="xbacklight -set 30"
alias b40="xbacklight -set 40"
alias b50="xbacklight -set 50"
alias b60="xbacklight -set 60"
alias b70="xbacklight -set 70"
alias b80="xbacklight -set 80"
alias b90="xbacklight -set 90"
alias b100="xbacklight -set 100"

alias google-chrome="google-chrome-stable"

# Small/medium/large scaling presets that work nicely on an LG-34WN80C widescreen monitor.
# Sleep and a duplicate call to xrdb are necessary.
alias lgl="xrandr --dpi 208 --output eDP1 --off --output DP1 --off --output DP2 --mode 3440x1440 --rate 60 --pos 0x0 --primary --output DP3 --off --output HDMI1 --off --output HDMI2 --off --output HDMI3 --off --output VIRTUAL1 --off && echo \"Xft.dpi: 208\" | xrdb -merge && i3-msg restart && sleep 5s && echo \"Xft.dpi: 208\" | xrdb -merge "
alias lgm="xrandr --dpi 176 --output eDP1 --off --output DP1 --off --output DP2 --mode 3440x1440 --rate 60 --pos 0x0 --primary --output DP3 --off --output HDMI1 --off --output HDMI2 --off --output HDMI3 --off --output VIRTUAL1 --off && echo \"Xft.dpi: 176\" | xrdb -merge && i3-msg restart && sleep 5s && echo \"Xft.dpi: 176\" | xrdb -merge "
alias lgs="xrandr --dpi 132 --output eDP1 --off --output DP1 --off --output DP2 --mode 3440x1440 --rate 60 --pos 0x0 --primary --output DP3 --off --output HDMI1 --off --output HDMI2 --off --output HDMI3 --off --output VIRTUAL1 --off && echo \"Xft.dpi: 132\" | xrdb -merge && i3-msg restart && sleep 5s && echo \"Xft.dpi: 132\" | xrdb -merge "
# For using the primary monitor, not LG...
alias lgx="xrandr --dpi 120 --output eDP1 --mode 1600x900 --rate 60 --pos 0x0 --primary --output DP1 --off --output DP2 --off --output DP3 --off --output HDMI1 --off --output HDMI2 --off --output HDMI3 --off --output VIRTUAL1 --off && echo \"Xft.dpi: 120\" | xrdb -merge && i3-msg restart && sleep 5s && echo \"Xft.dpi: 120\" | xrdb -merge "

# Alternative LG widescreen settings for Ubuntu
alias lgu="xrandr --output "eDP-1" --off --output "DP-1" --off --output "DP-2" --mode 3440x1440 --fb 8600x3600 --rate 60 --pos 0x0 --primary --scale 0.8x0.8 --output "DP-3" --off --output "HDMI-1" --off --output "HDMI-2" --off --output "HDMI-3" --off && echo \"Xft.dpi: 144\" | xrdb -merge && i3-msg restart && sleep 5s && echo \"Xft.dpi: 144\" | xrdb -merge "

# Claude Code AI agent aliases
alias forge="WHO_AM_I=forge claude"
alias axiom="WHO_AM_I=axiom claude"
alias jarvis="WHO_AM_I=jarvis claude"

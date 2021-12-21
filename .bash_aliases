alias ..='cd ..'
alias cdh="cd ~/"
alias cdd="cd ~/downloads"
alias cdg="cd ~/git"

# alias python="python3"

alias ls='ls -G'

alias ls='ls --color=auto --group-directories-first'
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

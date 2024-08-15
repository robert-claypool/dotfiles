# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load
ZSH_THEME="spaceship"

# Disable compfix to avoid the mv error
ZSH_DISABLE_COMPFIX=true

# Which plugins would you like to load?
plugins=(
  git
  history
  last-working-dir
  npm
  zsh-completions
  colored-man-pages
  web-search
  zsh-history-substring-search
  command-not-found
  common-aliases
  fzf
  z
  zsh-syntax-highlighting
  zsh-autosuggestions
)

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# History configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000
setopt extended_history
setopt inc_append_history
setopt hist_ignore_space

# Source custom configurations
[ -f ~/.bashrc_shared ] && source ~/.bashrc_shared
[ -f ~/.bash_aliases ] && source ~/.bash_aliases
[ -f ~/.local_aliases ] && source ~/.local_aliases

# PATH additions
[ -f /Applications/Docker.app/Contents/Resources/bin/docker ] && export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin"
[ -f /Applications/Rancher\ Desktop.app/Contents/Info.plist ] && export PATH="$PATH:$HOME/.rd/bin"
[ -d ~/.local/bin ] && export PATH="$PATH:~/.local/bin"
export PATH="$PATH:~/.dotnet/tools"

# Neovim setup
if [ -f /usr/bin/nvim ]; then
    alias vim="nvim"
    export EDITOR=nvim
    export NVIM_TUI_ENABLE_TRUE_COLOR=1
fi

# Other environment variables
export DOTNET_ROOT=/opt/dotnet
export AWS_VAULT_BACKEND="file"
export BROWSER=/usr/bin/chromium

# NVM setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# FZF configuration
export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Source FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Kubectl completion
(( $+commands[kubectl] )) && source <(kubectl completion zsh)

# Angular CLI completion
(( $+commands[ng] )) && source <(ng completion script)

# Terraform completion
complete -o nospace -C /usr/bin/terraform terraform

# Initialize the completion system
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select

# Spaceship prompt configurations
SPACESHIP_PROMPT_ORDER=(
  time
  user
  dir
  host
  git
  node
  ruby
  python
  golang
  docker
  aws
  exec_time
  line_sep
  jobs
  exit_code
  char
)
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_FORMAT="%D{%I:%M:%S %p}"
SPACESHIP_EXEC_TIME_SHOW=true
SPACESHIP_EXEC_TIME_ELAPSED=0

# Ensure Spaceship is loaded
autoload -U promptinit; promptinit
prompt spaceship

# Override Spaceship char section
SPACESHIP_CHAR_PREFIX=" "
SPACESHIP_CHAR_SUFFIX=""
SPACESHIP_CHAR_SYMBOL="❯"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/rc/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

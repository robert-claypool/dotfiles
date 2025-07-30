# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load
# ZSH_THEME="spaceship" <--- Removed as Starship will handle the prompt

# Save my shell line in Vim/Neovim → close with ":wq" → it runs.
# Quit with ":cq"/":q!" → nothing runs.
bindkey '^e' edit-command-line # Ctrl-E opens $EDITOR on the current buffer

# Disable compfix - prevents permission warnings when dotfiles are owned by different users
ZSH_DISABLE_COMPFIX=true

# Which plugins would you like to load?
plugins=(
  history
  last-working-dir
  npm
  zsh-completions
  colored-man-pages
  zsh-history-substring-search
  command-not-found
  common-aliases
  zsh-syntax-highlighting
  zsh-autosuggestions
  you-should-use
)

# Initialize zoxide (a better alternative to z)
eval "$(zoxide init zsh)"

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# History configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000
setopt extended_history
setopt inc_append_history
setopt hist_ignore_space

# Source shared environment and aliases
[ -f ~/.bashrc_shared ] && source ~/.bashrc_shared
[ -f ~/.bash_aliases ] && source ~/.bash_aliases
[ -f ~/.local_aliases ] && source ~/.local_aliases

# Kubectl completion
# (( $+commands[kubectl] )) && source <(kubectl completion zsh)

# Angular CLI completion
# (( $+commands[ng] )) && source <(ng completion script)

# Terraform completion
complete -o nospace -C /usr/bin/terraform terraform

# direnv
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# FZF keybindings and completion
if command -v fzf >/dev/null 2>&1; then
  # Try to find FZF installation path
  if [ -f "/opt/homebrew/opt/fzf/shell/key-bindings.zsh" ]; then
    source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
  elif [ -f "/usr/local/opt/fzf/shell/key-bindings.zsh" ]; then
    source "/usr/local/opt/fzf/shell/key-bindings.zsh"
  elif [ -f "$HOME/.fzf/shell/key-bindings.zsh" ]; then
    source "$HOME/.fzf/shell/key-bindings.zsh"
  fi

  # Completion
  if [ -f "/opt/homebrew/opt/fzf/shell/completion.zsh" ]; then
    source "/opt/homebrew/opt/fzf/shell/completion.zsh"
  elif [ -f "/usr/local/opt/fzf/shell/completion.zsh" ]; then
    source "/usr/local/opt/fzf/shell/completion.zsh"
  elif [ -f "$HOME/.fzf/shell/completion.zsh" ]; then
    source "$HOME/.fzf/shell/completion.zsh"
  fi
fi

# Atuin (better history)
if command -v atuin >/dev/null 2>&1; then
  # Disable interactive bindings so Atuin only logs history in the background.
  # This makes Ctrl-R and Up-Arrow use the classic Zsh/plugin behaviors.
  eval "$(atuin init zsh --disable-up-arrow --disable-ctrl-r)"
fi

# Fix autosuggestions color for specific dark themes
# The default fg=8 color is invisible in some dark themes
if command -v ghostty >/dev/null 2>&1; then
  current_theme=$(ghostty +show-config 2>/dev/null | grep "^theme = " | cut -d' ' -f3)
  if [[ "$current_theme" == "OneHalfDark" ]] || [[ "$current_theme" == "OneDark" ]]; then
    export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"
    echo "▸ Overriding autosuggestions color for $current_theme theme"
  fi
fi

# ------------------------------------------------------------------
# History navigation: arrow-keys with substring search (inline, no CLS)
# ------------------------------------------------------------------
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/rc/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# Starship prompt
eval "$(starship init zsh)"

# ZLE vi-mode indicator setup
# Ensures Starship's vicmd_symbol updates correctly.
autoload -U add-zsh-hook

# Updates Starship keymap and redraws prompt on mode change.
function zle-keymap-select() {
    STARSHIP_KEYMAP="$KEYMAP"
    zle reset-prompt
}
zle -N zle-keymap-select

# Ensures shell starts in insert mode.
function zle-line-init() {
    zle -K viins
}
zle -N zle-line-init

# Ensure vi-mode is enabled after all other plugins and settings.
bindkey -v

# Vi-mode overwrites the key bindings that zsh-autosuggestions needs to work.
# Since vi-mode is enabled at the end of .zshrc (after plugins load), we need
# to restore the autosuggestion bindings and restart the suggestion engine.

bindkey '^F' autosuggest-accept    # Ctrl+F to accept suggestion
bindkey '^[[C' autosuggest-accept  # Right arrow to accept suggestion

# Fix arrow keys in vi mode
bindkey "^[[C" forward-char        # Right arrow
bindkey "^[[D" backward-char       # Left arrow
bindkey "^[[A" up-line-or-history  # Up arrow
bindkey "^[[B" down-line-or-history # Down arrow

# Restart autosuggestions so they appear as you type
_zsh_autosuggest_start 2>/dev/null || true

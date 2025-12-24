# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Homebrew-provided zsh completions (e.g. fd, eza).
if command -v brew >/dev/null 2>&1; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  [ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ] && fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
  [ -d "$HOMEBREW_PREFIX/share/zsh-completions" ] && fpath=("$HOMEBREW_PREFIX/share/zsh-completions" $fpath)
fi

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
setopt extended_history       # Record timestamp in history
setopt inc_append_history     # Write immediately, not on shell exit
setopt hist_ignore_space      # Ignore commands starting with space
setopt hist_ignore_dups       # Ignore consecutive duplicates
setopt hist_find_no_dups      # Skip duplicates when searching
setopt share_history          # Share history across sessions

# Source shared environment and aliases
[ -f ~/.bashrc_shared ] && source ~/.bashrc_shared
[ -f ~/.bash_aliases ] && source ~/.bash_aliases
[ -f ~/.local_aliases ] && source ~/.local_aliases

# Kubectl completion
# (( $+commands[kubectl] )) && source <(kubectl completion zsh)

# Angular CLI completion
# (( $+commands[ng] )) && source <(ng completion script)

# Terraform completion
if command -v terraform >/dev/null 2>&1; then
  complete -o nospace -C "$(command -v terraform)" terraform
fi

# direnv
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# FZF keybindings and completion (requires fzf 0.48+)
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

# Atuin (better history)
if command -v atuin >/dev/null 2>&1; then
  # Disable interactive bindings so Atuin only logs history in the background.
  # This makes Ctrl-R and Up-Arrow use the classic Zsh/plugin behaviors.
  eval "$(atuin init zsh --disable-up-arrow --disable-ctrl-r)"
fi

# Catppuccin handles autosuggestions colors well - no override needed

# ------------------------------------------------------------------
# History navigation: arrow-keys with substring search (inline, no CLS)
# ------------------------------------------------------------------
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

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

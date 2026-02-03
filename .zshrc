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
  command-not-found
  zsh-autosuggestions
  you-should-use
)

if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab" ]; then
  plugins+=(fzf-tab)
fi

plugins+=(zsh-syntax-highlighting)

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Shared shell config (env, aliases, functions, fzf defaults, etc.)
dotfiles_shell_dir="$HOME/.config/shell"
if [ ! -d "$dotfiles_shell_dir" ]; then
  dotfiles_zshrc_target="$(readlink "$HOME/.zshrc" 2>/dev/null || true)"
  if [ -n "$dotfiles_zshrc_target" ]; then
    dotfiles_shell_dir="$(cd "$(dirname "$dotfiles_zshrc_target")" && pwd)/.config/shell"
  fi
fi
for dotfiles_shell_file in env.sh aliases.sh functions.sh interactive.sh; do
  if [ -f "$dotfiles_shell_dir/$dotfiles_shell_file" ]; then
    # shellcheck disable=SC1090
    source "$dotfiles_shell_dir/$dotfiles_shell_file"
  fi
done
unset dotfiles_shell_dir dotfiles_zshrc_target dotfiles_shell_file

# pyenv (optional)
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

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

# Local-only aliases (not checked in)
[ -f ~/.local_aliases ] && source ~/.local_aliases

# Kubectl completion
# (( $+commands[kubectl] )) && source <(kubectl completion zsh)

# Angular CLI completion
# (( $+commands[ng] )) && source <(ng completion script)

# direnv
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# FZF keybindings and completion (requires fzf 0.48+)
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

# fzf-tab: polished completion UI (optional)
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab" ]; then
  zstyle ':fzf-tab:*' switch-group ',' '.'
  zstyle ':fzf-tab:*' fzf-flags --height=60% --layout=reverse --border=sharp \
    --color=bg:#1e1e2e,bg+:#313244,fg:#cdd6f4,fg+:#cdd6f4,hl:#f38ba8,hl+:#f38ba8,header:#f38ba8,info:#cba6f7,prompt:#cba6f7,pointer:#f5e0dc,marker:#b4befe,spinner:#f5e0dc

  if command -v eza >/dev/null 2>&1; then
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --color=always $realpath | head -200'
  else
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -la $realpath | head -200'
  fi
fi

# zoxide (smart cd / `z`)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Atuin (better history)
if command -v atuin >/dev/null 2>&1; then
  # Ctrl-R: Atuin search UI
  # Up-Arrow: keep classic shell history
  eval "$(atuin init zsh --disable-up-arrow)"
fi

# Catppuccin handles autosuggestions colors well - no override needed

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

# Fix arrow keys in vi mode
bindkey "^[[C" forward-char        # Right arrow
bindkey "^[[D" backward-char       # Left arrow
bindkey "^[[A" up-line-or-history  # Up arrow
bindkey "^[[B" down-line-or-history # Down arrow

# Restart autosuggestions so they appear as you type
_zsh_autosuggest_start 2>/dev/null || true

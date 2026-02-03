#!/usr/bin/env sh

# Shared interactive configuration (fzf defaults, etc.) for zsh + bash.
# Safe to source multiple times.

if [ -n "${DOTFILES_SHELL_INTERACTIVE_LOADED:-}" ]; then
    return 0
fi
DOTFILES_SHELL_INTERACTIVE_LOADED=1

# FZF configuration - check dependencies first
if command -v fzf >/dev/null 2>&1; then
    if command -v bat >/dev/null 2>&1; then
        _dotfiles_fzf_preview_cmd='bat --color=always --style=numbers --line-range=:500 {}'
    else
        _dotfiles_fzf_preview_cmd='cat {}'
    fi

    export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:-} --height 60% --layout=reverse --border sharp"

    case "${FZF_DEFAULT_OPTS:-}" in
        *"--color="*) ;;
        *)
            # Catppuccin Mocha (matches Ghostty theme)
            export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=bg:#1e1e2e,bg+:#313244,fg:#cdd6f4,fg+:#cdd6f4,hl:#f38ba8,hl+:#f38ba8,header:#f38ba8,info:#cba6f7,prompt:#cba6f7,pointer:#f5e0dc,marker:#b4befe,spinner:#f5e0dc"
            ;;
    esac

    if command -v bat >/dev/null 2>&1; then
        export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --preview '$_dotfiles_fzf_preview_cmd' --preview-window=right:60%:wrap"
        export FZF_CTRL_T_OPTS="--preview '$_dotfiles_fzf_preview_cmd' --preview-window=right:60%:wrap"
    fi

    export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window=down:3:wrap"

    if command -v eza >/dev/null 2>&1; then
        # shellcheck disable=SC2089,SC2090
        export FZF_ALT_C_OPTS="--preview 'eza --tree {} | head -200'"
    elif command -v tree >/dev/null 2>&1; then
        # shellcheck disable=SC2089,SC2090
        export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
    else
        # shellcheck disable=SC2090
        export FZF_ALT_C_OPTS="--preview 'ls -la {}'"
    fi

    if command -v fd >/dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    else
        export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/\\.git/*"'
        export FZF_ALT_C_COMMAND='find . -type d -not -path "*/\\.git/*"'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    fi
fi

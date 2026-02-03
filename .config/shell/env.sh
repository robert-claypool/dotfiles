#!/usr/bin/env sh

# Shared environment for interactive shells (zsh + bash).
# Safe to source multiple times.

if [ -n "${DOTFILES_SHELL_ENV_LOADED:-}" ]; then
    return 0
fi
DOTFILES_SHELL_ENV_LOADED=1

DOTFILES_OS="unknown"
case "$(uname -s 2>/dev/null || echo unknown)" in
    Darwin) DOTFILES_OS="darwin" ;;
    Linux) DOTFILES_OS="linux" ;;
esac
export DOTFILES_OS

# Export UID for Linux Docker hosts (helps avoid root-owned files).
export UID

_dotfiles_prepend_path() {
    [ -d "$1" ] || return 0
    case ":$PATH:" in
        *":$1:"*) return 0 ;;
    esac
    PATH="$1:$PATH"
}

# ---------------------------------------------------------------------------
# Secrets (local-only, not checked in)
# ---------------------------------------------------------------------------
if [ -f "$HOME/.secrets" ]; then
    # shellcheck disable=SC1090
    . "$HOME/.secrets"
fi

# ---------------------------------------------------------------------------
# Editor / pager defaults
# ---------------------------------------------------------------------------
if command -v nvim >/dev/null 2>&1; then
    export EDITOR="nvim"
    export NVIM_TUI_ENABLE_TRUE_COLOR="1"
elif command -v vim >/dev/null 2>&1; then
    export EDITOR="vim"
fi

if command -v vimpager >/dev/null 2>&1; then
    export PAGER="vimpager"
    export VIMPAGER="vimpager"
    alias less="$VIMPAGER"

    if command -v nvim >/dev/null 2>&1; then
        export VIMPAGER_VIM="nvim"
    fi
fi

# Pretty man pages
if command -v bat >/dev/null 2>&1; then
    if [ -z "${BAT_THEME:-}" ]; then
        export BAT_THEME="Catppuccin Mocha"
    fi
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# ---------------------------------------------------------------------------
# PATH
# ---------------------------------------------------------------------------
_dotfiles_prepend_path "$HOME/.local/bin"
_dotfiles_prepend_path "$HOME/bin"
_dotfiles_prepend_path "$HOME/.dotnet/tools"

# Rancher Desktop
_dotfiles_prepend_path "$HOME/.rd/bin"

# Tool-specific PATH additions (optional)
_dotfiles_prepend_path "$HOME/.codeium/windsurf/bin"
_dotfiles_prepend_path "$HOME/.antigravity/antigravity/bin"

# Postgres.app CLI tools (macOS)
if [ "$DOTFILES_OS" = "darwin" ]; then
    if [ -d "/Applications/Postgres.app/Contents/Versions/latest/bin" ]; then
        _dotfiles_prepend_path "/Applications/Postgres.app/Contents/Versions/latest/bin"
    fi
    if [ -d "/Applications/pgModeler.app/Contents/MacOS" ]; then
        _dotfiles_prepend_path "/Applications/pgModeler.app/Contents/MacOS"
    fi
fi

# OpenJDK (Homebrew)
if [ -d "/opt/homebrew/opt/openjdk/bin" ]; then
    _dotfiles_prepend_path "/opt/homebrew/opt/openjdk/bin"
elif [ -d "/usr/local/opt/openjdk/bin" ]; then
    _dotfiles_prepend_path "/usr/local/opt/openjdk/bin"
fi

export PATH

# ---------------------------------------------------------------------------
# Language/tool managers
# ---------------------------------------------------------------------------
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

# pyenv
export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
_dotfiles_prepend_path "$PYENV_ROOT/shims"
_dotfiles_prepend_path "$PYENV_ROOT/bin"

# ---------------------------------------------------------------------------
# AWS
# ---------------------------------------------------------------------------
export AWS_VAULT_BACKEND="file"
export AWS_PAGER=""

# ---------------------------------------------------------------------------
# Claude Code / tooling
# ---------------------------------------------------------------------------
export CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR="1"

# ---------------------------------------------------------------------------
# Linux-only defaults
# ---------------------------------------------------------------------------
if [ "$DOTFILES_OS" = "linux" ]; then
    if [ -d "/opt/dotnet" ]; then
        export DOTNET_ROOT="/opt/dotnet"
    fi

    if [ -x "/usr/bin/chromium" ]; then
        export BROWSER="/usr/bin/chromium"
    fi

    # Restore SSH_AUTH_SOCK for desktop sessions if an env file exists.
    if [ -z "${SSH_AUTH_SOCK:-}" ]; then
        if [ -n "${XDG_RUNTIME_DIR:-}" ] && [ -f "$XDG_RUNTIME_DIR/ssh-agent.env" ]; then
            # shellcheck disable=SC1090
            . "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null 2>&1 || true
        elif [ -f "/tmp/ssh-agent.env" ]; then
            # shellcheck disable=SC1090
            . "/tmp/ssh-agent.env" >/dev/null 2>&1 || true
        fi
    fi
fi

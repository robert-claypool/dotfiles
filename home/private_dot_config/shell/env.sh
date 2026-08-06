#!/usr/bin/env sh

# Shared, output-free environment for Zsh and Bash. Every source pass
# reasserts ordering because macOS path_helper runs between .zshenv and
# .zprofile in login shells.

PATH="${PATH:-/usr/bin:/bin}"

_dotfiles_prepend_path() {
    [ -d "$1" ] || return 0

    _dotfiles_path_new=""
    _dotfiles_path_old_ifs="$IFS"
    IFS=:
    for _dotfiles_path_entry in $PATH; do
        [ -n "$_dotfiles_path_entry" ] || continue
        [ "$_dotfiles_path_entry" = "$1" ] && continue
        if [ -n "$_dotfiles_path_new" ]; then
            _dotfiles_path_new="$_dotfiles_path_new:$_dotfiles_path_entry"
        else
            _dotfiles_path_new="$_dotfiles_path_entry"
        fi
    done
    IFS="$_dotfiles_path_old_ifs"
    PATH="$1${_dotfiles_path_new:+:$_dotfiles_path_new}"
    unset _dotfiles_path_entry _dotfiles_path_new _dotfiles_path_old_ifs
}

DOTFILES_OS="unknown"
case "$(uname -s 2>/dev/null || printf unknown)" in
    Darwin) DOTFILES_OS="darwin" ;;
    Linux) DOTFILES_OS="linux" ;;
esac
export DOTFILES_OS

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Homebrew is made available without spawning brew on every shell start.
if [ -d "/opt/homebrew" ]; then
    _dotfiles_prepend_path "/opt/homebrew/sbin"
    _dotfiles_prepend_path "/opt/homebrew/bin"
elif [ -d "/usr/local/Homebrew" ]; then
    _dotfiles_prepend_path "/usr/local/sbin"
    _dotfiles_prepend_path "/usr/local/bin"
fi

# User executables precede system package managers.
_dotfiles_prepend_path "$HOME/bin"
_dotfiles_prepend_path "$HOME/.local/bin"

# Optional desktop and language toolchains.
_dotfiles_prepend_path "$HOME/.rd/bin"
_dotfiles_prepend_path "$HOME/.dotnet/tools"
_dotfiles_prepend_path "$HOME/.cargo/bin"
_dotfiles_prepend_path "$HOME/.codeium/windsurf/bin"
_dotfiles_prepend_path "$HOME/.antigravity/antigravity/bin"

if [ "$DOTFILES_OS" = "darwin" ]; then
    _dotfiles_prepend_path "/Applications/Postgres.app/Contents/Versions/latest/bin"
    _dotfiles_prepend_path "/Applications/pgModeler.app/Contents/MacOS"
    if [ -d "/opt/homebrew/opt/libpq/bin" ]; then
        _dotfiles_prepend_path "/opt/homebrew/opt/libpq/bin"
    elif [ -d "/usr/local/opt/libpq/bin" ]; then
        _dotfiles_prepend_path "/usr/local/opt/libpq/bin"
    fi
fi

if [ -d "/opt/homebrew/opt/openjdk/bin" ]; then
    export JAVA_HOME="/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home"
    _dotfiles_prepend_path "/opt/homebrew/opt/openjdk/bin"
elif [ -d "/usr/local/opt/openjdk/bin" ]; then
    export JAVA_HOME="/usr/local/opt/openjdk/libexec/openjdk.jdk/Contents/Home"
    _dotfiles_prepend_path "/usr/local/opt/openjdk/bin"
fi

if [ -d "$HOME/Library/Android/sdk" ]; then
    export ANDROID_HOME="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
    export ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-$ANDROID_HOME}"
    _dotfiles_prepend_path "$ANDROID_HOME/cmdline-tools/latest/bin"
    _dotfiles_prepend_path "$ANDROID_HOME/emulator"
    _dotfiles_prepend_path "$ANDROID_HOME/platform-tools"
fi

export GOPATH="${GOPATH:-$HOME/go}"
_dotfiles_prepend_path "$GOPATH/bin"

export BUN_INSTALL="${BUN_INSTALL:-$HOME/.bun}"
_dotfiles_prepend_path "$BUN_INSTALL/bin"

export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
_dotfiles_prepend_path "$PYENV_ROOT/bin"
_dotfiles_prepend_path "$PYENV_ROOT/shims"

# Keystone adapters intentionally win over unmanaged or stale tool copies.
_dotfiles_prepend_path "$HOME/.keystone/toolchain/active/bin"

export PATH

if command -v nvim >/dev/null 2>&1; then
    export EDITOR="nvim"
    export VISUAL="nvim"
elif command -v vim >/dev/null 2>&1; then
    export EDITOR="vim"
    export VISUAL="vim"
else
    export EDITOR="vi"
    export VISUAL="vi"
fi

export PAGER="${PAGER:-less}"
export LESS="${LESS:--FRX}"
if command -v bat >/dev/null 2>&1; then
    export BAT_THEME="${BAT_THEME:-ansi}"
    export MANPAGER="sh -c 'col -bx | bat --language man --plain'"
fi

export AWS_VAULT_BACKEND="${AWS_VAULT_BACKEND:-file}"
export AWS_PAGER=""
export CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR="1"

if [ "$DOTFILES_OS" = "linux" ] && [ -z "${SSH_AUTH_SOCK:-}" ]; then
    if [ -n "${XDG_RUNTIME_DIR:-}" ] && [ -r "$XDG_RUNTIME_DIR/ssh-agent.env" ]; then
        # shellcheck source=/dev/null
        . "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null 2>&1 || true
    fi
fi

unset -f _dotfiles_prepend_path 2>/dev/null || unset _dotfiles_prepend_path

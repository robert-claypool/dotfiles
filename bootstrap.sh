#!/usr/bin/env bash

# Define the dotfiles directory:
# Ensures this script always references the correct path to our dotfiles repo,
# regardless of where it's executed.
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

set -euo pipefail

setup_tools_macos() {
    echo "Installing tools via Homebrew Bundle..."

    if ! command -v brew >/dev/null 2>&1; then
        echo "⚠ Homebrew not found. Install it from https://brew.sh and re-run ./bootstrap.sh"
        return 0
    fi

    local brewfile="$DOTFILES_DIR/Brewfile"
    if [[ ! -f "$brewfile" ]]; then
        echo "⚠ Brewfile not found at '$brewfile' (skipping)"
        return 0
    fi

    if ! brew bundle --file "$brewfile" --no-lock; then
        echo "⚠ Homebrew Bundle failed (continuing)."
        return 0
    fi
}

setup_tools_omarchy() {
    echo "Installing tools via pacman (Omarchy/Arch)..."

    if ! command -v pacman >/dev/null 2>&1; then
        echo "⚠ pacman not found (skipping)"
        return 0
    fi

    local sudo_cmd=""
    if command -v sudo >/dev/null 2>&1; then
        sudo_cmd="sudo"
    fi

    local packages=(
        atuin
        bat
        bottom
        doggo
        direnv
        duf
        dust
        eza
        fd
        fzf
        git-delta
        jq
        procs
        pspg
        pyenv
        ripgrep
        starship
        tldr
        tmux
        trash-cli
        yq
        zsh-completions
        zoxide
    )

    for pkg in "${packages[@]}"; do
        if pacman -Qi "$pkg" >/dev/null 2>&1; then
            echo "✓ $pkg is already installed"
            continue
        fi
        echo "Installing $pkg..."
        if ! $sudo_cmd pacman -S --needed --noconfirm "$pkg"; then
            echo "⚠ Failed to install '$pkg' (skipping)"
        fi
    done
}

setup_zsh_plugins() {
    echo "Setting up Zsh plugins..."
    if [[ ! -d "$HOME/.oh-my-zsh" && -z "${ZSH_CUSTOM:-}" ]]; then
        echo "⚠ Oh My Zsh not found at '$HOME/.oh-my-zsh' (skipping). Install it, then re-run ./bootstrap.sh"
        return 0
    fi

    # Default ZSH_CUSTOM to ~/.oh-my-zsh/custom if not set
    local zsh_custom_plugins_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    mkdir -p "$zsh_custom_plugins_dir"

    declare -A plugins
    plugins=(
        ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
        ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions.git"
        ["you-should-use"]="https://github.com/MichaelAquilina/zsh-you-should-use.git"
        ["fzf-tab"]="https://github.com/Aloxaf/fzf-tab.git"
    )

    for plugin_name in "${!plugins[@]}"; do
        local plugin_repo="${plugins[$plugin_name]}"
        local plugin_dir="$zsh_custom_plugins_dir/$plugin_name"
        if [ ! -d "$plugin_dir" ]; then
            echo "Installing '$plugin_name' zsh plugin..."
            if ! git clone "$plugin_repo" "$plugin_dir"; then
                echo "⚠ Failed to clone '$plugin_name' (skipping)"
                continue
            fi
        else
            echo "✓ '$plugin_name' zsh plugin is already installed"
        fi
    done
}

setup_symlinks() {
    echo "Setting symbolic links to various configs..."
    local configs=(
        .env
        .bash_aliases
        .bashrc_shared
        .ripgreprc
        .zshrc
        .zprofile
        .psqlrc
        .sqliterc
        .inputrc
        .tmux.conf
        .gitignore
        .secrets
    )
    for config in "${configs[@]}"; do
        local source="$DOTFILES_DIR/$config"
        local target="$HOME/$config"
        if [[ ! -e "$source" ]]; then
            echo "⚠ $config source not found at '$source' (skipping)"
            continue
        fi
        if [[ -L "$target" ]]; then
            echo "✓ $config symlink already exists"
        elif [[ -e "$target" ]]; then
            echo "⚠ $config exists but is not a symlink (skipping)"
        else
            ln -s "$source" "$target"
            echo "✓ Linked $config"
        fi
    done

    # Symlink executables from bin directory
    echo "Setting up executables from bin directory..."
    local bin_dir="$DOTFILES_DIR/bin"
    local dest_bin_dir="$HOME/bin"
    if [[ -d "$bin_dir" ]]; then
        mkdir -p "$dest_bin_dir"
        for script in "$bin_dir"/*; do
            # Only symlink files that are executable
            if [[ -f "$script" ]] && [[ -x "$script" ]]; then
                local script_name
                script_name=$(basename "$script")
                local target="$dest_bin_dir/$script_name"
                if [[ -L "$target" ]]; then
                    echo "✓ $script_name symlink already exists"
                elif [[ -e "$target" ]]; then
                    echo "⚠ $script_name exists but is not a symlink (skipping)"
                else
                    ln -s "$script" "$target"
                    echo "✓ Linked $script_name"
                fi
            fi
        done
    fi
}

setup_shell_config() {
    echo "Setting up shared shell configuration (~/.config/shell)..."
    local shell_config_dir="$HOME/.config"
    local shell_config_target="$shell_config_dir/shell"
    local shell_config_source="$DOTFILES_DIR/.config/shell"

    if [[ ! -d "$shell_config_source" ]]; then
        echo "⚠ Shell config source not found at '$shell_config_source' (skipping)"
        return 0
    fi

    mkdir -p "$shell_config_dir"

    if [[ -L "$shell_config_target" ]]; then
        echo "✓ Shell config symlink already exists"
    elif [[ -e "$shell_config_target" ]]; then
        echo "⚠ '$shell_config_target' exists but is not a symlink (skipping)"
    else
        ln -s "$shell_config_source" "$shell_config_target"
        echo "✓ Linked shell config directory"
    fi
}

setup_macos() {
    echo "Setting up macOS-specific configurations..."

    local ssh_config_source="$DOTFILES_DIR/macOS/.ssh/config"
    local ssh_config_target="$HOME/.ssh/config"

    if [[ ! -f "$ssh_config_source" ]]; then
        echo "⚠ SSH config source not found at '$ssh_config_source' (skipping)"
        return 0
    fi

    mkdir -p "$HOME/.ssh"

    if [[ -L "$ssh_config_target" ]]; then
        echo "✓ ~/.ssh/config symlink already exists"
    elif [[ -e "$ssh_config_target" ]]; then
        echo "⚠ ~/.ssh/config exists but is not a symlink (skipping)"
    else
        ln -s "$ssh_config_source" "$ssh_config_target"
        echo "✓ Linked ~/.ssh/config"
    fi
}

setup_ghostty() {
    echo "Setting up Ghostty configuration..."
    local ghostty_config_dir="$HOME/.config/ghostty"
    local ghostty_config_file="$ghostty_config_dir/config"
    local source_config_file="$DOTFILES_DIR/.config/ghostty/config"

    mkdir -p "$ghostty_config_dir"

    if [[ -L "$ghostty_config_file" ]]; then
        echo "✓ Ghostty config symlink already exists"
    elif [[ -e "$ghostty_config_file" ]]; then
        echo "⚠ Ghostty config exists but is not a symlink (skipping)"
    else
        ln -s "$source_config_file" "$ghostty_config_file"
        echo "✓ Linked Ghostty config"
    fi
}

setup_ghostty_app_macos() {
    if ! command -v brew >/dev/null 2>&1; then
        return 0
    fi

    local channel="${DOTFILES_GHOSTTY_CHANNEL:-tip}"
    local desired_cask=""
    local other_cask=""

    case "$channel" in
        tip|nightly)
            desired_cask="ghostty@tip"
            other_cask="ghostty"
            ;;
        stable)
            desired_cask="ghostty"
            other_cask="ghostty@tip"
            ;;
        *)
            echo "⚠ Unknown DOTFILES_GHOSTTY_CHANNEL='$channel' (use 'stable' or 'tip'); skipping Ghostty install"
            return 0
            ;;
    esac

    echo "Ensuring Ghostty is installed ($desired_cask)..."
    if brew list --cask "$other_cask" >/dev/null 2>&1; then
        brew uninstall --cask "$other_cask" || true
    fi
    if ! brew install --cask "$desired_cask"; then
        echo "⚠ Failed to install '$desired_cask' (continuing)"
        return 0
    fi
}

setup_starship() {
    echo "Setting up Starship configuration..."
    local starship_config_file="$HOME/.config/starship.toml"
    local source_config_file="$DOTFILES_DIR/.config/starship.toml"

    if [[ ! -f "$source_config_file" ]]; then
        echo "⚠ Starship config source not found at '$source_config_file' (skipping)"
        return
    fi

    mkdir -p "$HOME/.config"

    if [[ -L "$starship_config_file" ]]; then
        echo "✓ Starship config symlink already exists"
    elif [[ -e "$starship_config_file" ]]; then
        echo "⚠ Starship config exists but is not a symlink (skipping)"
    else
        ln -s "$source_config_file" "$starship_config_file"
        echo "✓ Linked Starship config"
    fi
}

setup_atuin() {
    echo "Setting up Atuin configuration..."
    local atuin_config_dir="$HOME/.config/atuin"
    local atuin_config_file="$atuin_config_dir/config.toml"
    local source_config_file="$DOTFILES_DIR/.config/atuin/config.toml"

    if [[ ! -f "$source_config_file" ]]; then
        echo "⚠ Atuin config source not found at '$source_config_file' (skipping)"
        return
    fi

    # Note: Atuin stores its database in ~/.config/atuin - never delete this directory
    mkdir -p "$atuin_config_dir"

    if [[ -L "$atuin_config_file" ]]; then
        echo "✓ Atuin config symlink already exists"
    elif [[ -e "$atuin_config_file" ]]; then
        echo "⚠ Atuin config exists but is not a symlink (skipping)"
    else
        ln -s "$source_config_file" "$atuin_config_file"
        echo "✓ Linked Atuin config"
    fi
}

setup_git() {
    if ! command -v git >/dev/null 2>&1; then
        echo "Error: Cannot find Git. Global config was not updated."
        return 1
    fi

    if [[ ! -f "$HOME/.gitconfig" ]]; then
        echo "Git configuration not found. Setting optional user identity..."
        local git_name=""
        local git_email=""

        read -r -p "Git user.name (blank to skip): " git_name
        if [[ -n "$git_name" ]]; then
            git config --global user.name "$git_name"
        fi

        read -r -p "Git user.email (blank to skip): " git_email
        if [[ -n "$git_email" ]]; then
            git config --global user.email "$git_email"
        fi

        echo "Run 'git config --global -e' to review/edit the configuration."
    else
        echo "Git configuration found."
    fi

    if [[ -z "$(git config --global --get core.excludesfile || true)" ]]; then
        git config --global core.excludesfile "$HOME/.gitignore"
    fi

    if [[ -z "$(git config --global --get merge.tool || true)" ]]; then
        git config --global merge.tool vimdiff
    fi

    # Optional: configure delta if installed, but only if the user hasn't set a pager.
    if command -v delta >/dev/null 2>&1; then
        if [[ -z "$(git config --global --get core.pager || true)" ]]; then
            git config --global core.pager "delta"
        fi
        if [[ -z "$(git config --global --get interactive.diffFilter || true)" ]]; then
            git config --global interactive.diffFilter "delta --color-only"
        fi
        if [[ -z "$(git config --global --get delta.navigate || true)" ]]; then
            git config --global delta.navigate true
        fi
    fi
}

main() {
    setup_symlinks
    echo "-----"
    setup_shell_config
    echo "-----"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        setup_macos
        echo "-----"
        setup_tools_macos
        echo "-----"
        setup_ghostty_app_macos
        echo "-----"
    else
        setup_tools_omarchy
        echo "-----"
    fi

    setup_zsh_plugins
    echo "-----"

    setup_ghostty
    echo "-----"
    setup_starship
    echo "-----"
    setup_atuin
    echo "-----"
    setup_git
    echo "-----"
    echo "Open README.md for next steps."
}

main

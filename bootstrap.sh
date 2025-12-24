#!/usr/bin/env bash

# Define the dotfiles directory:
# Ensures this script always references the correct path to our dotfiles repo,
# regardless of where it's executed.
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

setup_tools() {
    echo "Setting up additional command line tools..."

    local tools=(
        # Better ls replacement
        eza
        # Better find replacement
        fd
        # Smarter cd with directory jumping (better than z)
        zoxide
        # Simplified man pages
        tldr
        # Better disk usage viewer
        duf
        # Directory size analyzer
        dust
        # Modern cut replacement
        choose
        # Modern system monitor
        bottom
        # Modern replacement for dig (and dog)
        doggo
        # JSON processor
        jq
        # YAML processor
        yq
        # Fast, cross-shell prompt
        starship
        # Better shell history
        atuin
        # Per-directory env vars
        direnv
        # Safer rm
        trash-cli
        # Modern process viewer
        procs
        # Modern grep alternative with type support
        rg
    )

    for tool in "${tools[@]}"; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            echo "Installing $tool..."
            brew install "$tool"
        else
            echo "✓ $tool is already installed"
        fi
    done
}

setup_zsh_plugins() {
    echo "Setting up Zsh plugins..."
    # Default ZSH_CUSTOM to ~/.oh-my-zsh/custom if not set
    local zsh_custom_plugins_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    mkdir -p "$zsh_custom_plugins_dir"

    declare -A plugins
    plugins=(
        ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
        ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions.git"
        ["zsh-history-substring-search"]="https://github.com/zsh-users/zsh-history-substring-search.git"
        ["you-should-use"]="https://github.com/MichaelAquilina/zsh-you-should-use.git"
    )

    for plugin_name in "${!plugins[@]}"; do
        local plugin_repo="${plugins[$plugin_name]}"
        local plugin_dir="$zsh_custom_plugins_dir/$plugin_name"
        if [ ! -d "$plugin_dir" ]; then
            echo "Installing '$plugin_name' zsh plugin..."
            git clone "$plugin_repo" "$plugin_dir"
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
        local target="$HOME/$config"
        if [[ -L "$target" ]]; then
            echo "✓ $config symlink already exists"
        elif [[ -e "$target" ]]; then
            echo "⚠ $config exists but is not a symlink (skipping)"
        else
            ln -s "$DOTFILES_DIR/$config" "$target"
            echo "✓ Linked $config"
        fi
    done

    # Add Hammerspoon configuration symlink
    echo "Setting up Hammerspoon configuration..."
    mkdir -p "$HOME/.hammerspoon"
    local hs_target="$HOME/.hammerspoon/init.lua"
    if [[ -L "$hs_target" ]]; then
        echo "✓ Hammerspoon init.lua symlink already exists"
    elif [[ -e "$hs_target" ]]; then
        echo "⚠ Hammerspoon init.lua exists but is not a symlink (skipping)"
    else
        ln -s "$DOTFILES_DIR/hammerspoon/init.lua" "$hs_target"
        echo "✓ Linked Hammerspoon init.lua"
    fi

    # Reload Hammerspoon if running
    if pgrep -x "Hammerspoon" >/dev/null 2>&1; then
        osascript -e 'tell application "Hammerspoon" to reload config'
        echo "Hammerspoon configuration reloaded."
    else
        echo "Hammerspoon is not running. Configuration will take effect on next launch."
    fi

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

setup_macos() {
    echo "Setting up macOS-specific configurations..."

    if [[ ! -f "$HOME/.ssh/config" ]]; then
        mkdir -p "$HOME/.ssh"
        ln -s "$DOTFILES_DIR/macOS/.ssh/config" "$HOME/.ssh/config"
    fi
}

setup_linux() {
    echo "Setting up Linux-specific configurations..."
    MY_CONFIGS="$HOME/.config"
    if [[ -f /etc/regolith/i3/config ]]; then
        MY_CONFIGS="$HOME/.config/regolith"
    fi

    setup_linux_configs

    mkdir -p "$MY_CONFIGS/i3"
    ln -s "$DOTFILES_DIR/.config/i3/config" "$MY_CONFIGS/i3/config"
}

setup_linux_configs() {
    mkdir -p "$MY_CONFIGS"

    if [[ ! -f "$MY_CONFIGS/openai.token" ]]; then
        ln -s "$DOTFILES_DIR/.config/openai.token" "$MY_CONFIGS/openai.token"
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
    if command -v git >/dev/null 2>&1; then
        if [[ ! -f "$HOME/.gitconfig" ]]; then
            echo "Git configuration not found. Creating one..."
            read -p "Set your Git name to 'Robert Claypool'? [y,N] " doit
            case $doit in
                y|Y) git config --global user.name 'Robert Claypool' ;;
                  *) ;;
            esac
            read -p "Set your Git email to 'robert-claypool@outlook.com'? [y,N] " doit
            case $doit in
                y|Y) git config --global user.email 'robert-claypool@outlook.com' ;;
                  *) ;;
            esac
            git config --global core.excludesfile ~/.gitignore
            git config --global merge.tool vimdiff
            echo "Run 'git config --global -e' to review/edit the configuration."
        else
            echo "Git configuration found."
        fi
    else
        echo "Error: Cannot find Git. '.gitconfig' was not updated."
        return 1
    fi
}

main() {
    setup_symlinks
    echo "-----"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        setup_macos
        echo "-----"
        setup_tools
        echo "-----"
        setup_zsh_plugins
        echo "-----"
    else
        setup_linux
        setup_zsh_plugins
        echo "-----"
    fi

    setup_ghostty
    echo "-----"
    setup_starship
    echo "-----"
    setup_atuin
    echo "-----"
    setup_git
    echo "-----"
    echo "Open README.md and install ZSH plugins as described."
}

main
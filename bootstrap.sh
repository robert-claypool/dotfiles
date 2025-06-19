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
        ln -sf "$DOTFILES_DIR/$config" "$HOME/$config"
    done

    # Add Hammerspoon configuration symlink
    echo "Setting up Hammerspoon configuration..."
    mkdir -p "$HOME/.hammerspoon"
    ln -sf "$DOTFILES_DIR/hammerspoon/init.lua" "$HOME/.hammerspoon/init.lua"

    # Reload Hammerspoon if running
    if pgrep -x "Hammerspoon" >/dev/null 2>&1; then
        osascript -e 'tell application "Hammerspoon" to reload'
        echo "Hammerspoon configuration reloaded."
    else
        echo "Hammerspoon is not running. Configuration will take effect on next launch."
    fi
}

setup_macos() {
    echo "Setting up macOS-specific configurations..."

    if [[ ! -f "$HOME/.ssh/config" ]]; then
        mkdir -p "$HOME/.ssh"
        ln -sf "$DOTFILES_DIR/macOS/.ssh/config" "$HOME/.ssh/config"
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
    ln -sf "$DOTFILES_DIR/.config/i3/config" "$MY_CONFIGS/i3/config"
}

setup_linux_configs() {
    mkdir -p "$MY_CONFIGS"

    if [[ ! -f "$MY_CONFIGS/openai.token" ]]; then
        ln -sf "$DOTFILES_DIR/.config/openai.token" "$MY_CONFIGS/openai.token"
    fi
}

setup_ghostty() {
    echo "Setting up Ghostty configuration..."
    local ghostty_config_dir="$HOME/.config/ghostty"
    local ghostty_config_file="$ghostty_config_dir/config"
    local source_config_file="$DOTFILES_DIR/.config/ghostty/config"

    # Remove existing symlink or directory
    rm -rf "$ghostty_config_dir"

    # Create the directory
    mkdir -p "$ghostty_config_dir"

    # Create symlink for the configuration file
    ln -sf "$source_config_file" "$ghostty_config_file"

    echo "Ghostty configuration set up successfully."
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
    else
        setup_linux
    fi

    setup_ghostty
    echo "-----"
    setup_git
    echo "-----"
    echo "Open README.md and install ZSH plugins as described."
}

main
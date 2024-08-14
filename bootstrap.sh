#!/usr/bin/env bash

setup_symlinks() {
    echo "Setting symbolic links to various configs..."
    local configs=(
        .env
        .bash_aliases
        .bashrc_shared
        .pam_environment
        .zshrc
        .psqlrc
        .sqliterc
        .inputrc
        .tmux.conf
        .gitignore
        .Xresources
        .secrets
    )
    for config in "${configs[@]}"; do
        ln -sf "$PWD/$config" "$HOME/$config"
    done
}

setup_macos() {
    echo "Setting up macOS-specific configurations..."

    if [[ ! -f $HOME/.ssh/config ]]; then
        ln -s $PWD/macOS/.ssh/config $HOME/.ssh/config
    fi

    setup_yabai_skhd
}

setup_yabai_skhd() {
    echo "Setting up Yabai and skhd..."

    # Install Yabai and skhd
    if ! command -v yabai >/dev/null 2>&1; then
        echo "Installing Yabai..."
        brew install koekeishiya/formulae/yabai
    fi
    if ! command -v skhd >/dev/null 2>&1; then
        echo "Installing skhd..."
        brew install koekeishiya/formulae/skhd
    fi

    # Create symlinks for Yabai and skhd configs
    ln -sf $PWD/.yabairc $HOME/.yabairc
    ln -sf $PWD/.skhdrc $HOME/.skhdrc
    chmod +x $HOME/.yabairc

    # Setup LaunchAgents
    mkdir -p "$HOME/Library/LaunchAgents"
    ln -sf "$PWD/.config/LaunchAgents/com.koekeishiya.yabai.plist" \
        "$HOME/Library/LaunchAgents/com.koekeishiya.yabai.plist"
    ln -sf "$PWD/.config/LaunchAgents/com.koekeishiya.skhd.plist" \
        "$HOME/Library/LaunchAgents/com.koekeishiya.skhd.plist"

    # Load launch agents
    if ! launchctl list com.koekeishiya.yabai &>/dev/null; then
        launchctl load -w "$HOME/Library/LaunchAgents/com.koekeishiya.yabai.plist"
    fi
    if ! launchctl list com.koekeishiya.skhd &>/dev/null; then
        launchctl load -w "$HOME/Library/LaunchAgents/com.koekeishiya.skhd.plist"
    fi

    setup_yabai_scripting_addition
}

setup_yabai_scripting_addition() {
    SUDOERS_FILE="/private/etc/sudoers.d/yabai"
    YABAI_HASH=$(shasum -a 256 $(command -v yabai) | awk '{print $1}')
    YABAI_PATH=$(command -v yabai)

    echo "YABAI_HASH=$YABAI_HASH"
    echo "YABAI_PATH=$YABAI_PATH"

    echo "Setting up Yabai's scripting addition. This requires sudo."
    sudo bash << EOF
echo "$(whoami) ALL=(root) NOPASSWD: sha256:$YABAI_HASH $YABAI_PATH --load-sa" > "$SUDOERS_FILE"
chmod 0440 "$SUDOERS_FILE"
EOF
    echo "Yabai sudoers file created/updated."

    echo "Attempting to load Yabai scripting addition..."
    if sudo "$YABAI_PATH" --load-sa; then
        echo "Yabai scripting addition loaded successfully."
    else
        echo "Failed to load Yabai scripting addition. Checking for specific errors..."
        if sudo "$YABAI_PATH" --load-sa 2>&1 | grep -q "boot-arg"; then
            echo "Error related to boot args detected."
            echo "Current boot-args:"
            nvram boot-args
            echo "Try running: sudo nvram boot-args=\"-arm64e_preview_abi\""
            echo "Then restart your computer and run this script again."
        elif sudo "$YABAI_PATH" --load-sa 2>&1 | grep -q "SIP"; then
            echo "Error related to SIP detected."
            echo "Current SIP status:"
            csrutil status
            echo "You may need to partially disable SIP. See Yabai documentation for instructions."
        else
            echo "Unknown error occurred. Full error message:"
            sudo "$YABAI_PATH" --load-sa
        fi
    fi

    echo "NOTE: Ensure that SIP is partially disabled for Yabai to work fully."
    echo "If you encounter issues, please refer to the Yabai documentation:"
    echo "https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection"
}

setup_linux() {
    echo "Setting up Linux-specific configurations..."
    MY_CONFIGS="$HOME/.config"
    if [[ -f /etc/regolith/i3/config ]]; then
        MY_CONFIGS="$HOME/.config/regolith"
    else
        setup_linux_configs
    fi

    if [[ ! -f $MY_CONFIGS/i3/config ]]; then
        ln -s $PWD/.config/i3 $MY_CONFIGS/i3
    fi
}

setup_linux_configs() {
    if [[ ! -f $MY_CONFIGS/openai.token ]]; then
        ln -s $PWD/.config/openai.token $MY_CONFIGS/openai.token
    fi

    if [[ ! -f $MY_CONFIGS/i3status/config ]]; then
        ln -s $PWD/.config/i3status $MY_CONFIGS/i3status
    fi
    if [[ ! -f $MY_CONFIGS/conky/conky.conf ]]; then
        ln -s $PWD/.config/conky $MY_CONFIGS/conky
    fi
    if [[ ! -f $MY_CONFIGS/termite/config ]]; then
        ln -s $PWD/.config/termite $MY_CONFIGS/termite
    fi
}

setup_alacritty() {
    if [[ ! -f $HOME/.config/alacritty/alacritty.yml ]]; then
        ln -s $PWD/.config/alacritty $HOME/.config/alacritty
    fi
}

setup_git() {
    if command -v git >/dev/null 2>&1; then
        if [[ ! -f $HOME/.gitconfig ]]; then
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

    if [[ "$OSTYPE" == "darwin"* ]]; then
        setup_macos
    else
        setup_linux
    fi

    setup_alacritty
    setup_git

    echo "-----"
    echo "Open README.md and install ZSH plugins as described."
}

# Wrapping in main() can prevent partial execution if the script is sourced
# instead of executed.
main

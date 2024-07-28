#!/usr/bin/env bash

main() {
    echo "Setting symbolic links to various configs..."
    ln -sf $PWD/.env $HOME/.env
    ln -sf $PWD/.bash_aliases $HOME/.bash_aliases
    ln -sf $PWD/.bashrc_shared $HOME/.bashrc_shared
    ln -sf $PWD/.pam_environment $HOME/.pam_environment
    ln -sf $PWD/.zshrc $HOME/.zshrc
    ln -sf $PWD/.psqlrc $HOME/.psqlrc
    ln -sf $PWD/.sqliterc $HOME/.sqliterc
    ln -sf $PWD/.inputrc $HOME/.inputrc
    ln -sf $PWD/.tmux.conf $HOME/.tmux.conf
    ln -sf $PWD/.gitignore $HOME/.gitignore
    ln -sf $PWD/.Xresources $HOME/.Xresources
    ln -sf $PWD/.secrets $HOME/.secrets

    if [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        if [ ! -f $HOME/.ssh/config ]; then
            # Link our conky config
            # https://wiki.archlinux.org/index.php/Conky#Configuration
            ln -s $PWD/macOS/.ssh/config $HOME/.ssh/config
        fi

        # Yabai and skhd setup
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

        # Set executable permission for .yabairc
        chmod +x $HOME/.yabairc

        # Ensure LaunchAgents directory exists
        mkdir -p "$HOME/Library/LaunchAgents"

        # Create symlinks for launch agents
        ln -sf $PWD/.config/LaunchAgents/com.koekeishiya.yabai.plist $HOME/Library/LaunchAgents/com.koekeishiya.yabai.plist
        ln -sf $PWD/.config/LaunchAgents/com.koekeishiya.skhd.plist $HOME/Library/LaunchAgents/com.koekeishiya.skhd.plist

        # Load launch agents
        # The -w flag ensures that agent is not ignored in future logins.
        if ! launchctl list com.koekeishiya.yabai &>/dev/null; then
            launchctl load -w $HOME/Library/LaunchAgents/com.koekeishiya.yabai.plist
        fi
        if ! launchctl list com.koekeishiya.skhd &>/dev/null; then
            launchctl load -w $HOME/Library/LaunchAgents/com.koekeishiya.skhd.plist
        fi

        # Set up Yabai scripting addition: This is important for Yabai features
        # that require system-level access. It allows Yabai to perform some
        # operations without requiring a password each time, while still
        # maintaining a good level of security by restricting the privileges to
        # a specific version (specific file hash) of Yabai.
        # Set up Yabai scripting addition
        SUDOERS_FILE="/private/etc/sudoers.d/yabai"
        YABAI_HASH=$(shasum -a 256 $(which yabai) | awk '{print $1}')
        YABAI_PATH=$(which yabai)

        echo "YABAI_HASH=$YABAI_HASH"
        echo "YABAI_PATH=$YABAI_PATH"

        echo "Setting up Yabai's scripting addition. This requires sudo."
        sudo bash << EOF
echo "$(whoami) ALL=(root) NOPASSWD: sha256:$YABAI_HASH $YABAI_PATH --load-sa" > "$SUDOERS_FILE"
chmod 0440 "$SUDOERS_FILE"
EOF
        echo "Yabai sudoers file created/updated."

        # Check SIP status
        # echo "Checking SIP status..."
        # csrutil status

        # Check boot args
        # echo "Checking boot args..."
        # nvram boot-args

        # Load the scripting addition with verbose output
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

        # Reminder about SIP
        echo "NOTE: Ensure that SIP is partially disabled for Yabai to work fully."
        echo "If you encounter issues, please refer to the Yabai documentation:"
        echo "https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection"
    fi

    MY_CONFIGS=""
    if [ -f /etc/regolith/i3/config ]; then
        # Save override configs where Regolith needs them to be.
        # https://regolith-linux.org/docs/interface/system/
        MY_CONFIGS=$HOME/.config/regolith
    else
        # Use paths that work on Manjaro and (probably) other distros.
        MY_CONFIGS=$HOME/.config

        # Setup for https://github.com/madox2/vim-ai
        if [ ! -f $MY_CONFIGS/openai.token ]; then
            ln -s $PWD/.config/openai.token $MY_CONFIGS/openai.token
        fi

        # We don't use these overrides on Regolith because it already has good defaults.
        if [ ! -f $MY_CONFIGS/i3status/config ]; then
            # Link our i3status config directory.
            ln -s $PWD/.config/i3status $MY_CONFIGS/i3status
        fi
        if [ ! -f $MY_CONFIGS/conky/conky.conf ]; then
            # Link our conky config
            # https://wiki.archlinux.org/index.php/Conky#Configuration
            ln -s $PWD/.config/conky $MY_CONFIGS/conky
        fi
        if [ ! -f $MY_CONFIGS/termite/config ]; then
            # Link our termite config directory.
            ln -s $PWD/.config/termite $MY_CONFIGS/termite
        fi
    fi

    if [ ! -f $MY_CONFIGS/i3/config ]; then
        # Link our i3 config directory.
        ln -s $PWD/.config/i3 $MY_CONFIGS/i3
    fi

    # Alacritty belongs in ~./config no matter the distro.
    if [ ! -f $HOME/.config/alacritty/alacritty.yml ]; then
        # Link our alacritty config directory.
        ln -s $PWD/.config/alacritty $HOME/.config/alacritty
    fi

    echo "Done."

    if command -v git >/dev/null 2>&1; then
        if [ ! -f $HOME/.gitconfig ]; then
            echo "Git configuration not found. Creating one..."
            # This will create ~/.gitconfig if it does not already exist.
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

    # if command -v python3 >/dev/null 2>&1; then
    #     python3 $PWD/util/terminalcolors.py
    #     echo "If you don't see 256 unique colors, then try"
    #     echo "adding 'export TERM=\"xterm-256color\"' to the end of '.bashrc'"
    #     echo "and open a new shell. (This works in Debian, Arch, and Manjaro.)"
    # else
    #     echo "Warning: Cannot find Python 3. Unable to run 'util/terminalcolors.py'."
    #     return 0
    # fi

    echo "-----"
    echo "Open README.md and install ZSH plugins as described."
}

# Wrapping in main() can prevent partial execution if the script is sourced
# instead of executed.
main

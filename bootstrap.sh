#!/usr/bin/env bash

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

mkdir -p $HOME/.config
if [ ! -f $HOME/.config/i3/config ]; then
    # Link our i3 config directory.
    ln -s $PWD/.config/i3 $HOME/.config/i3
fi
if [ ! -f $HOME/.config/i3status/config ]; then
    # Link our i3status config directory.
    ln -s $PWD/.config/i3status $HOME/.config/i3status
fi
if [ ! -f $HOME/.config/termite/config ]; then
    # Link our termite config directory.
    ln -s $PWD/.config/termite $HOME/.config/termite
fi
if [ ! -f $HOME/.config/conky/conky.conf ]; then
    # Link our conky config
    # https://wiki.archlinux.org/index.php/Conky#Configuration
    ln -s $PWD/.config/conky $HOME/.config/conky
fi
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
        read -p "Set your Git email to 'robert.g.claypool@gmail.com'? [y,N] " doit
        case $doit in
            y|Y) git config --global user.email 'robert.g.claypool@gmail.com' ;;
              *) ;;
        esac
        git config --global core.excludesfile ~/.gitignore
        git config --global merge.tool vimdiff
        echo "Run 'git config --global -e' to review/edit the configuration."
    fi
else
    echo "Error: Cannot find Git. '.gitconfig' was not updated."
    exit 1
fi

if command -v python >/dev/null 2>&1; then
    python $PWD/util/terminalcolors.py
    echo "If you don't see 256 unique colors, then try"
    echo "adding 'export TERM=\"xterm-256color\"' to the end of '.bashrc'"
    echo "and open a new shell. (This works in Debian, Arch, and Manjaro.)"
else
    echo "Warning: Cannot find Python. Unable to run 'util/terminalcolors.py'."
    exit 0
fi

echo "-----"
echo "Open README.md and edit .bashrc as described."

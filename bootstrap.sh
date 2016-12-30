#!/usr/bin/env bash

echo "Setting symbolic links to various configs..."
ln -sf $PWD/system/.env $HOME/.env
ln -sf $PWD/system/.bash_aliases $HOME/.bash_aliases
ln -sf $PWD/.psqlrc $HOME/.psqlrc
ln -sf $PWD/.tmux.conf $HOME/.tmux.conf
ln -sf $PWD/.gitignore $HOME/.gitignore
ln -sf $PWD/.Xresources $HOME/.Xresources
echo "Done."

if command -v git >/dev/null 2>&1; then
    if [ ! -f $HOME/.gitconfig ]; then
        echo "Git configuration not found. Creating one..."
    fi
    # This will create ~/.gitconfig if it does not already exist.
    read -p "Set your Git name to 'Robert Claypool'? [y,n] " doit
    case $doit in
        y|Y) git config --global user.name 'Robert Claypool' ;;
          *) ;;
    esac
    read -p "Set your Git email to 'robert.g.claypool+git@gmail.com'? [y,n] " doit
    case $doit in
        y|Y) git config --global user.email 'robert.g.claypool+git@gmail.com' ;;
          *) ;;
    esac
    git config --global core.excludesfile ~/.gitignore
    echo "Run 'git config --global -e' to review/edit the configuration."
else
    echo "Error: Cannot find Git. '.gitconfig' was not updated."
    exit 1
fi

if command -v python >/dev/null 2>&1; then
    python $PWD/util/terminalcolors.py
    echo "If you don't see 256 unique colors, then try"
    echo "adding 'export TERM=\"xterm-256color\"' to the end of '.bashrc'"
    echo "and open a new shell. (This works in Debian, I don't know about"
    echo "other distros.)"
else
    echo "Warning: Cannot find Python. Unable to run 'util/terminalcolors.py'."
    exit 0
fi

echo "-----"
echo "Open README.md and edit .bashrc as described."

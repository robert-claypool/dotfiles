#!/usr/bin/env bash

echo "Setting symbolic links to various configs..."
ln -sf $PWD/system/.env $HOME/.env
ln -sf $PWD/system/.alias $HOME/.alias
ln -sf $PWD/.psqlrc $HOME/.psqlrc
ln -sf $PWD/.tmux.conf $HOME/.tmux.conf
ln -sf $PWD/.gitignore $HOME/.gitignore
echo "Done."

if command -v git >/dev/null 2>&1; then
    git config --global core.excludesfile ~/.gitignore
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
    exit 0
else
    echo "Warning: Cannot find Python. Unable to run 'util/terminalcolors.py'."
    exit 0
fi

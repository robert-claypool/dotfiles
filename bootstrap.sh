#!/usr/bin/env bash

ln -sf $PWD/system/.env $HOME/.env
ln -sf $PWD/system/.alias $HOME/.alias
ln -sf $PWD/.tmux.conf $HOME/.tmux.conf
ln -sf $PWD/.gitignore $HOME/.gitignore

if command -v git >/dev/null 2>&1; then
    git config --global core.excludesfile ~/.gitignore
else
    echo "error: cannot find git. gitconfig was not updated"
    exit 1
fi

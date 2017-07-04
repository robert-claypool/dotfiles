#!/usr/bin/env bash

if [[ -z "$(pidof i3lock)" ]]; then
  i3lock --ignore-empty-password --show-failed-attempts --image ~/.config/i3/backgrounds/dark.png --tiling && sleep 1
else
  echo "i3lock is already running"
fi

#!/usr/bin/env bash

# https://github.com/wavexx/screenkey
# https://github.com/naelstrof/slop
echo 'slop (Select Operation) will prompt for a geometry... Draw a box to position Screenkey.'
screenkey --position fixed --font 'DejaVu Sans Mono Bold' --geometry $(slop -n -f '%g')

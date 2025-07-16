#!/usr/bin/env bash

PLUGIN_DIR="$CONFIG_DIR/plugins"

# remember to install Noto Color Emoji font
status="$(curl -s 'wttr.in/bruxelles,belgium?format=%c|%t')"
condition=$(echo $status| cut -d '|' -f1)
temperature=$(echo $status | cut -d '|' -f2)
sketchybar --set $NAME icon="$condition" label="$temperature"

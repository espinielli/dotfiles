#!/bin/bash

# already sourced by sketchybarrc
# source "$CONFIG_DIR/colors.sh"

volume=(
    script="$PLUGIN_DIR/volume.sh"
    label.padding_right=3
    label.padding_left=0
    background.padding_right=1
    background.color=$TRANSPARENT
    background.border_color=$BLACK
    background.border_width=1
)

sketchybar --add item volume right \
    --set volume "${volume[@]}" \
    --subscribe volume volume_change

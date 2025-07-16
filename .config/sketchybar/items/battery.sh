#!/bin/bash

battery=(
    update_freq=30
    script="$PLUGIN_DIR/battery.sh"
    label.padding_right=3
    label.padding_left=0
    background.padding_right=1
    background.color=$TRANSPARENT
    background.border_color=$BLACK
    background.border_width=1
)

sketchybar --add item battery right \
    --set battery "${battery[@]}" \
    --subscribe battery power_source_change system_woke

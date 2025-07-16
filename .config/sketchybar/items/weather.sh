#!/bin/bash

weather=(
    update_freq=1800
    #label.background.border_width=2
    #label.background.border_color=0XFFF5A97F
    script="$PLUGIN_DIR/weather.sh"
    click_script="open https://merrysky.net/forecast/brussels/si"
    label.padding_right=3
    label.padding_left=0
    background.padding_right=1
    background.color=$TRANSPARENT
    background.border_color=$BLACK
    background.border_width=1
)

sketchybar --add item weather right \
    --set weather "${weather[@]}"

#!/bin/bash

weather=(
    update_freq=1800
    script="$PLUGIN_DIR/weather.sh"
    click_script="open https://merrysky.net/forecast/brussels/si"
)

sketchybar --add item weather right \
    --set weather "${weather[@]}"

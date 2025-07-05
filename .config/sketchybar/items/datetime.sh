#!/bin/bash

date=(
    width=0
    y_offset=8
    icon=$CALENDAR
    label.align=right
    label.font.size=11
    update_freq=3000
    script='sketchybar --set $NAME label="$(date +"%a %d")"'
)
time=(
    label.width=40
    y_offset=-6
    icon=$CLOCK
    label.align=right
    label.font.size=12
    update_freq=30
    script='sketchybar --set $NAME label="$(date "+%R")"'
)

sketchybar \
    --add item date right \
    --set date "${date[@]}" \
    \
    --add item time right \
    --set time "${time[@]}"

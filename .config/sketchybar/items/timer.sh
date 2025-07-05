#!/bin/bash

sketchybar --add item timer right \
            --set timer \
                label="--:--" \
                icon= \
                icon.font.size=20 \
                icon.color=$BLACK \
                icon.padding_right=3 \
                background.drawing=off \
                y_offset=1 \
                script="$PLUGIN_DIR/timer.sh" \
                popup.background.corner_radius=10 \
                popup.background.color=$POPUP_BACKGROUND_COLOR \
                popup.background.border_width=1 \
                popup.background.border_color=0xFF45475A \
                popup.y_offset=-4 \
            --subscribe timer \
                mouse.clicked \
                mouse.entered \
                mouse.exited \
                mouse.exited.global

for timer in "5" "10" "25"; do
sketchybar --add item "timer.${timer}" popup.timer \
            --set "timer.${timer}" \
                label="${timer} Minutes" \
                padding_left=16 \
                padding_right=16 \
                click_script="$PLUGIN_DIR/timer.sh $((timer * 60)); sketchybar -m --set timer popup.drawing=off"
done

#!/bin/bash
source "$CONFIG_DIR/icons.sh"
if [ "$SENDER" = "volume_change" ]; then
    HIGHLIGHT=off

    case $INFO in
    [6-9][0-9] | 100)
        ICON=$VOLUME_100
        ;;
    [3-5][0-9])
        ICON=$VOLUME_33
        ;;
    [1-9] | [1-2][0-9])
        ICON=$VOLUME_10
        ;;
    *)
        ICON=􀊢
        HIGHLIGHT=on
        ;;
    esac

    sketchybar --set $NAME icon=$ICON label="$INFO%" icon.highlight=$HIGHLIGHT
fi

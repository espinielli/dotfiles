#!/bin/bash

SOUNDS_PATH="/System/Library/PrivateFrameworks/ScreenReader.framework/Versions/A/Resources/Sounds/"
COUNTDOWN_PID_FILE="/tmp/sketchybar_timer_pid"
DEFAULT_DURATION=1500  # 25 minutes

__start() {
    local name="$1"
    local duration="$2"

    (
        local time_left="$duration"

        while [ "$time_left" -gt 0 ]; do
            local minutes=$((time_left / 60))
            local seconds=$((time_left % 60))
            sketchybar --set "$name" label="$(printf "%02d:%02d" "$minutes" "$seconds")"
            sleep 1
            time_left=$((time_left - 1))
        done

        afplay "$SOUNDS_PATH/GuideSuccess.aiff"
        sketchybar --set "$name" label="Done!"
    ) &
    printf "%s\n" "$!" > "$COUNTDOWN_PID_FILE"
}

__stop() {
    if [ -f "$COUNTDOWN_PID_FILE" ]; then
        if IFS= read -r PID < "$COUNTDOWN_PID_FILE"; then
            if ps -p "$PID" > /dev/null 2>&1; then
                kill -- "$PID"
            fi
        fi
        rm -f "$COUNTDOWN_PID_FILE"
    fi
}

start_countdown() {
    __stop
    __start "$1" "$2"
    afplay "$SOUNDS_PATH/TrackingOn.aiff"
}

stop_countdown() {
    __stop
    afplay "$SOUNDS_PATH/TrackingOff.aiff"
    sketchybar --set "$NAME" label="--:--"
}

# If script is run directly with a duration argument (e.g. ./timer.sh 300)
if [[ "$#" -eq 1 && "$1" =~ ^[0-9]+$ ]]; then
    start_countdown "$(echo "$NAME" | awk -F'.' '{print $1}')" "$1"
    exit 0
fi

# Handle SketchyBar mouse events
if [ "$SENDER" = "mouse.clicked" ]; then
    case "$BUTTON" in
        "left")
            sketchybar --set "$NAME" icon=""
            start_countdown "$NAME" "$DEFAULT_DURATION"
            ;;
        "right")
            sketchybar --set "$NAME" icon=""
            stop_countdown
            ;;
    esac
fi

case "$SENDER" in
    "mouse.entered")
        sketchybar --set "$NAME" popup.drawing=on
        ;;
    "mouse.exited"|"mouse.exited.global")
        sketchybar --set "$NAME" popup.drawing=off
        ;;
esac

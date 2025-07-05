#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

BATTERY_INFO="$(pmset -g batt)"
PERCENTAGE=$(echo "$BATTERY_INFO" | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(echo "$BATTERY_INFO" | grep 'AC Power')

if [ $PERCENTAGE = "" ]; then
    exit 0
fi

BCOLOR=$WHITE
case $PERCENTAGE in
9[0-9] | 100)
    BICON=$BATTERY_100
    ;;
[6-8][0-9])
    BICON=$BATTERY_75
    ;;
[3-5][0-9])
    BICON=$BATTERY_50
    ;;
[1-2][0-9])
    BICON=$BATTERY_25
    ;;
*)
    BICON=$BATTERY_0
    BCOLOR=$RED
    ;;
esac

if [[ $CHARGING != "" ]]; then
    BICON=$BATTERY_CHARGING
fi

sketchybar --set $NAME icon=$BICON label="$PERCENTAGE%"

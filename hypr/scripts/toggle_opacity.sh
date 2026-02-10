#!/usr/bin/env bash

CONFIG="$HOME/.config/hypr/config/opacity-rules.conf"
STATE="$HOME/.cache/hypr-opacity-toggle"

apply_rules() {
    # wczytaj reguły z pliku
    original_window_address=$(hyprctl -j activewindow | awk -F'"' '/"address"/ {gsub(",", "", $4); print $4}')
    while IFS= read -r rule; do
        hyprctl keyword windowrulev2 "$rule" >/dev/null 2>&1
    done < "$CONFIG"

    # wymuś natychmiastowe zastosowanie reguł dla wszystkich okien
    for win in $(hyprctl clients | awk '{if($1=="Window") print $2}'); do
        hyprctl dispatch focuswindow address:0x$win >/dev/null 2>&1
        # hyprctl dispatch blurwindow address:0x$win
    done
    hyprctl dispatch focuswindow address:$original_window_address >/dev/null 2>&1
}

clear_rules() {
    original_window_address=$(hyprctl -j activewindow | awk -F'"' '/"address"/ {gsub(",", "", $4); print $4}')
    # ustaw pełną przezroczystość dla wszystkich okien
    hyprctl keyword windowrulev2 "opacity 1.0 1.0, class:.*" >/dev/null 2>&1

    # wymuś odświeżenie
    for win in $(hyprctl clients | awk '{if($1=="Window") print $2}'); do
        hyprctl dispatch focuswindow address:0x$win >/dev/null 2>&1
        # hyprctl dispatch blurwindow address:0x$win
    done
    hyprctl dispatch focuswindow address:$original_window_address >/dev/null 2>&1
}

case "$1" in
    toggle)
        if [ -f "$STATE" ]; then
            rm "$STATE"
            apply_rules
        else
            touch "$STATE"
            clear_rules
        fi
        ;;
    apply)
        apply_rules
        ;;
    *)
        echo "Usage: $0 {apply|toggle}"
        exit 1
        ;;
esac

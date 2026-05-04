{ pkgs, ... }:
pkgs.writeShellScriptBin "border-animation" ''
#!/bin/bash

ANGLE=0
ACTIVE_WINDOW=""

# listen to Hyprland active window changes
hyprctl -j events | while read -r line; do
    if echo "$line" | grep -q "activewindow"; then
        ACTIVE_WINDOW=$(hyprctl activewindow -j | jq -r '.address')
    fi
done &

EVENT_PID=$!

cleanup() {
    kill $EVENT_PID
}
trap cleanup EXIT

while true; do
    if [ -n "$ACTIVE_WINDOW" ]; then
        hyprctl dispatch focuswindow address:$ACTIVE_WINDOW >/dev/null 2>&1

        echo hyprctl keyword "plugin:borders-plus-plus:col.border_2" \
        "rgba(ff69b4ff) rgba(ff69b400) ''${ANGLE}deg"

        ANGLE=$(( (ANGLE + 2) % 360 ))
        echo ''${ANGLE}
    fi

    sleep 0.05
done
''

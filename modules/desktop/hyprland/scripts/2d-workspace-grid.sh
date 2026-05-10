#!/usr/bin/env bash

set -euo pipefail

COMMAND="${1:-move}"
DIRECTION="${2:-}"

DIMENSION=16
SIZE=$(printf "%.0f" "$(echo "sqrt($DIMENSION)" | bc -l)")

log() {
    echo "[workspace-nav] $*"
}

usage() {
    echo "Usage: $0 move [-l|-r|-t|-b]"
    exit 1
}

if [[ "$COMMAND" != "move" ]]; then
    log "Invalid command: $COMMAND"
    usage
fi

[[ -z "$DIRECTION" ]] && usage

RAW_WS_ID=$(hyprctl activeworkspace -j | jq '.id')

if [[ -z "$RAW_WS_ID" || "$RAW_WS_ID" == "null" ]]; then
    log "Failed to get active workspace ID"
    exit 1
fi

# Convert Hyprland 1-based -> 0-based
WS=$((RAW_WS_ID - 1))

# Grid coordinates
X=$((WS % SIZE))
Y=$((WS / SIZE))

log "Workspace: $WS"
log "Coordinates: x=$X y=$Y"

set_animation() {
    case "$1" in
        left)
            hyprctl keyword animation "workspaces, 1, 7, default, slidefadeleft"
            ;;
        right)
            hyprctl keyword animation "workspaces, 1, 7, default, slidefaderight"
            ;;
        up)
            hyprctl keyword animation "workspaces, 1, 7, default, slidefadeup"
            ;;
        down)
            hyprctl keyword animation "workspaces, 1, 7, default, slidefadedown"
            ;;
    esac
}

case "$DIRECTION" in
    -l)
        set_animation right # reverse animation
        RESULT_WS=$(( Y * SIZE + ((X + 1) % SIZE) ))
        log "Move LEFT"
        ;;

    -r)
        set_animation left
        RESULT_WS=$(( Y * SIZE + ((X - 1 + SIZE) % SIZE) ))
        log "Move RIGHT"
        ;;

    -t)
        set_animation down
        RESULT_WS=$(( ((Y - 1 + SIZE) % SIZE) * SIZE + X ))
        log "Move UP"
        ;;

    -b)
        set_animation up
        RESULT_WS=$(( ((Y + 1) % SIZE) * SIZE + X ))
        log "Move DOWN"
        ;;

    *)
        log "Invalid direction: $DIRECTION"
        usage
        ;;
esac

# Convert back to Hyprland 1-based
TARGET_WS=$((RESULT_WS + 1))

log "Target workspace: $RESULT_WS"
log "Switching to workspace ID: $TARGET_WS"

hyprctl dispatch workspace "$TARGET_WS"

log "Done."

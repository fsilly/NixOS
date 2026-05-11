#!/usr/bin/env bash

set -euo pipefail

COMMAND="${1:-move}"
ARG="${2:-}"

DIMENSION=16
SIZE=$(printf "%.0f" "$(echo "sqrt($DIMENSION)" | bc -l)")

log() {
    echo "[workspace-nav] $*"
}

usage() {
    echo "Usage: $0 move [-l|-r|-t|-b] | teleport [00-99]"
    exit 1
}

case "$COMMAND" in
    move)
        case "$ARG" in
            -l|-r|-t|-b)
                ;;
            *)
                log "Invalid direction for move: $ARG"
                usage
                ;;
        esac
        ;;
    teleport)
        case "$ARG" in
            [0-9][0-9])
                TP_X=$((10#${ARG:0:1}))
                TP_Y=$((10#${ARG:1:1}))
                ;;
            *)
                log "Invalid coordinate for teleport: $ARG"
                usage
                ;;
        esac
        ;;
    *)
        log "Invalid command: $COMMAND"
        usage
        ;;
esac

[[ -z "$ARG" ]] && usage

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


if [ $COMMAND == "move" ]; then
    DIRECTION=$ARG;

    WORKSPACE_ANIMATION="workspaces, 1, 2, default" 

    set_animation() {
        case "$1" in
            left)
                hyprctl keyword animation "$WORKSPACE_ANIMATION, slide"
                ;;
            right)
                hyprctl keyword animation "$WORKSPACE_ANIMATION, slide"
                ;;
            up)
                hyprctl keyword animation "$WORKSPACE_ANIMATION, slidevert"
                ;;
            down)
                hyprctl keyword animation "$WORKSPACE_ANIMATION, slidevert"
                ;;
        esac
    }

    case "$DIRECTION" in
        -l)
            set_animation right # reverse animation
            TARGET_WS=$(( Y * SIZE + ((X + 1) % SIZE) ))
            log "Move LEFT"
            ;;

        -r)
            set_animation left
            TARGET_WS=$(( Y * SIZE + ((X - 1 + SIZE) % SIZE) ))
            log "Move RIGHT"
            ;;

        -t)
            set_animation down
            TARGET_WS=$(( ((Y - 1 + SIZE) % SIZE) * SIZE + X ))
            log "Move UP"
            ;;

        -b)
            set_animation up
            TARGET_WS=$(( ((Y + 1) % SIZE) * SIZE + X ))
            log "Move DOWN"
            ;;

        *)
            log "Invalid direction: $DIRECTION"
            usage
            ;;
    esac
fi

if [ $COMMAND == "teleport" ]; then
    TARGET_WS=$((TP_Y * SIZE + TP_X))
    echo "$TP_Y * $SIZE + $TP_X = $TARGET_WS"
fi

log "Target workspace: $TARGET_WS"
log "Switching to workspace ID: $TARGET_WS + 1"
hyprctl dispatch workspace "$(($TARGET_WS + 1))"

log "Done."

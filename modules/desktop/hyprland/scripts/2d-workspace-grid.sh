#!/usr/bin/env bash

set -euo pipefail

TOPOLOGY="${WS_TOPOLOGY:-torus}"

COMMAND="${1:-move}"
ARG="${2:-}"

log() {
    echo "[workspace-nav] $*"
}

usage() {
    echo "Usage:"
    echo "  $0 move [-l|-r|-u|-d]"
    echo "  $0 teleport [00-99]"
    exit 1
}

case "$TOPOLOGY" in
    torus|plane)
        ;;
    *)
        log "Invalid topology: $TOPOLOGY"
        echo "Valid values: torus | plane"
        exit 1
        ;;
esac

case "$COMMAND" in
    move)
        case "$ARG" in
            -l|-r|-u|-d)
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

                if (( TP_X >= WS_COL || TP_Y >= WS_ROW )); then
                    log "Teleport target out of bounds"
                    exit 1
                fi
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

# Hyprland workspace IDs are 1-based
WS=$((RAW_WS_ID - 1))

# Current coordinates
X=$((WS % WS_COL))
Y=$(((WS / WS_COL) % WS_ROW))

log "Workspace: $WS"
log "Coordinates: x=$X y=$Y"
log "Topology: $TOPOLOGY"

WORKSPACE_ANIMATION="workspaces, 1, 2, default"

set_animation() {
    case "$1" in
        left|right)
            hyprctl keyword animation "$WORKSPACE_ANIMATION, slide"
            ;;
        up|down)
            hyprctl keyword animation "$WORKSPACE_ANIMATION, slidevert"
            ;;
    esac
}

#
# Coordinate resolvers
#

min() {
    (( $1 < $2 )) && echo "$1" || echo "$2"
}

max() {
    (( $1 > $2 )) && echo "$1" || echo "$2"
}

resolve_new_position() {
    local POSITION="$1"
    local MOVEMENT="$2"
    local LIMIT="$3"

    local TARGET_TORUS=$(((POSITION + MOVEMENT + LIMIT) % LIMIT))

    local TARGET_PLANE
    TARGET_PLANE=$(max 0 "$(min "$((LIMIT - 1))" "$((POSITION + MOVEMENT))")")

    case "$TOPOLOGY" in
        torus)
            echo "$TARGET_TORUS"
            ;;
        plane)
            echo "$TARGET_PLANE"
            ;;
    esac
}

if [[ "$COMMAND" == "move" ]]; then
    case "$ARG" in
        -r)
            set_animation right

            TARGET_X=$(resolve_new_position "$X" 1 "$WS_COL")
            TARGET_Y="$Y"

            log "Move LEFT"
            ;;

        -l)
            set_animation left

            TARGET_X=$(resolve_new_position "$X" -1 "$WS_COL")
            TARGET_Y="$Y"

            log "Move RIGHT"
            ;;

        -d)
            set_animation down

            TARGET_X="$X"
            TARGET_Y=$(resolve_new_position "$Y" 1 "$WS_ROW")

            log "Move UP"
            ;;

        -u)
            set_animation up

            TARGET_X="$X"
            TARGET_Y=$(resolve_new_position "$Y" -1 "$WS_ROW")

            log "Move DOWN"
            ;;
    esac

    TARGET_WS=$((TARGET_Y * WS_COL + TARGET_X))
fi

if [[ "$COMMAND" == "teleport" ]]; then
    TARGET_X="$TP_X"
    TARGET_Y="$TP_Y"

    TARGET_WS=$((TARGET_Y * WS_COL + TARGET_X))

    log "Teleport -> x=$TARGET_X y=$TARGET_Y"
fi

MAX_WS=$((WS_COL * WS_ROW - 1))

log "Target coordinates: x=$TARGET_X y=$TARGET_Y"
log "Target workspace: $TARGET_WS"

if (( TARGET_WS < 0 || TARGET_WS > MAX_WS )); then
    log "Target workspace out of bounds"
    exit 1
fi

log "Switching to workspace ID: $((TARGET_WS + 1))"

hyprctl dispatch workspace "$((TARGET_WS + 1))"

log "Done."

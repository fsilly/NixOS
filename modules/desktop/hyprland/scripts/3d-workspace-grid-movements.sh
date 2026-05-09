#!/usr/bin/env bash

set -euo pipefail

COMMAND="${1:-move}"
DIRECTION="${2:-}"

# 4x4x4 cube
WIDTH=4
HEIGHT=4
DEPTH=4

DIMENSION=$((WIDTH * HEIGHT * DEPTH))

log() {
    echo "[workspace-cube] $*"
}

usage() {
    echo "Usage:"
    echo "  $0 move -l   # left"
    echo "  $0 move -r   # right"
    echo "  $0 move -u   # up"
    echo "  $0 move -d   # down"
    echo "  $0 move -f   # forward (next layer)"
    echo "  $0 move -b   # backward (previous layer)"
    exit 1
}

if [[ "$COMMAND" != "move" ]]; then
    usage
fi

RAW_WS_ID=$(hyprctl activeworkspace -j | jq '.id')

if [[ -z "$RAW_WS_ID" || "$RAW_WS_ID" == "null" ]]; then
    log "Failed to get active workspace"
    exit 1
fi

# Convert Hyprland 1-based -> 0-based
WS=$((RAW_WS_ID - 1))

log "Current workspace: $WS"

# Convert linear index -> x/y/z
#
# layout:
#
# z layers
#
# layer 0:
#  0  1  2  3
#  4  5  6  7
#  8  9 10 11
# 12 13 14 15
#
# layer 1:
# 16 ...
#

X=$(( WS % WIDTH ))
Y=$(( (WS / WIDTH) % HEIGHT ))
Z=$(( WS / (WIDTH * HEIGHT) ))

log "Coordinates: x=$X y=$Y z=$Z"

case "$DIRECTION" in
    -l)
        X=$(( (X - 1 + WIDTH) % WIDTH ))
        log "Move LEFT"
        ;;

    -r)
        X=$(( (X + 1) % WIDTH ))
        log "Move RIGHT"
        ;;

    -u)
        Y=$(( (Y - 1 + HEIGHT) % HEIGHT ))
        log "Move UP"
        ;;

    -d)
        Y=$(( (Y + 1) % HEIGHT ))
        log "Move DOWN"
        ;;

    -f)
        Z=$(( (Z + 1) % DEPTH ))
        log "Move FORWARD"
        ;;

    -b)
        Z=$(( (Z - 1 + DEPTH) % DEPTH ))
        log "Move BACKWARD"
        ;;

    *)
        usage
        ;;
esac

# Convert x/y/z -> linear index
RESULT_WS=$(( Z * WIDTH * HEIGHT + Y * WIDTH + X ))

# Convert back to Hyprland 1-based
TARGET_WS=$((RESULT_WS + 1))

log "New coordinates: x=$X y=$Y z=$Z"
log "Target workspace: $RESULT_WS"
log "Dispatching to workspace ID: $TARGET_WS"

hyprctl dispatch workspace "$TARGET_WS"

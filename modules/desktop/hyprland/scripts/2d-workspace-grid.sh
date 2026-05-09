#!/usr/bin/env bash

set -euo pipefail

COMMAND="${1:-move}"
DIRECTION="${2:-}"

DIMENSION=16
Y_OFFSET=$(printf "%.0f" "$(echo "sqrt($DIMENSION)" | bc -l)")

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

if [[ -z "$DIRECTION" ]]; then
    usage
fi

# Get active workspace ID from Hyprland
RAW_WS_ID=$(hyprctl activeworkspace -j | jq '.id')

if [[ -z "$RAW_WS_ID" || "$RAW_WS_ID" == "null" ]]; then
    log "Failed to get active workspace ID"
    exit 1
fi

log "Raw workspace ID: $RAW_WS_ID"

# Normalize workspace index:
# If Hyprland starts at 1, convert to 0-based
WS_ID=$((RAW_WS_ID - 1))

log "Normalized workspace index: $WS_ID"

RESULT_WS=0

case "$DIRECTION" in
    -l)
        RESULT_WS=$(( (WS_ID - 1 + DIMENSION) % DIMENSION ))
        log "Moving LEFT"
        ;;

    -r)
        RESULT_WS=$(( (WS_ID + 1) % DIMENSION ))
        log "Moving RIGHT"
        ;;

    -t)
        RESULT_WS=$(( (WS_ID - Y_OFFSET + DIMENSION) % DIMENSION ))
        log "Moving UP"
        ;;

    -b)
        RESULT_WS=$(( (WS_ID + Y_OFFSET) % DIMENSION ))
        log "Moving DOWN"
        ;;

    *)
        log "Invalid direction: $DIRECTION"
        usage
        ;;
esac

# Convert back to Hyprland's 1-based workspace numbering
TARGET_WS=$((RESULT_WS + 1))

log "Target workspace index: $RESULT_WS"
log "Switching to workspace ID: $TARGET_WS"

hyprctl dispatch workspace "$TARGET_WS"

log "Done."

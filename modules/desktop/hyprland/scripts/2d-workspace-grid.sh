#!/usr/bin/env bash

set -euo pipefail

TOPOLOGY="${WS_TOPOLOGY:-torus}"

COMMAND="${1:-move}"
ARG="${2:-}"

log() {
    echo "[workspace-nav] $*" >&2
}

usage() {
    echo "Usage:"
    echo "  $0 move [-l|-r|-u|-d]"
    echo "  $0 teleport [11-99]"
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
                TP_X=$((10#${ARG:0:1} -1))
                TP_Y=$((10#${ARG:1:1} -1))

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
    teleportX)
        case "$ARG" in
            [1-9])
                TPX_X=$((10#$ARG - 1))

                if (( TPX_X >= WS_COL )); then
                    log "TeleportX target out of bounds"
                    exit 1
                fi
                ;;
            *)
                log "Invalid X coordinate for teleportX: $ARG"
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

CACHE_FILE="/tmp/workspace-nav-y-cache"

get_cached_y() {
    local x="$1"

    log "get_cached_y(x=$x)"

    if [[ ! -f "$CACHE_FILE" ]]; then
        log "Cache file does not exist: $CACHE_FILE"
        return 0
    fi

    log "Cache contents:"
    sed 's/^/[workspace-nav]   /' "$CACHE_FILE" >&2

    local y
    y=$(grep "^${x}=" "$CACHE_FILE" 2>/dev/null | tail -n1 | cut -d= -f2 || true)

    log "Lookup result for x=$x -> y=<$y>"

    echo "$y"
}

set_cached_y() {
    local x="$1"
    local y="$2"

    log "set_cached_y(x=$x, y=$y)"

    mkdir -p "$(dirname "$CACHE_FILE")"

    if [[ -f "$CACHE_FILE" ]]; then
        log "Removing previous entry for x=$x"
        grep -v "^${x}=" "$CACHE_FILE" > "${CACHE_FILE}.tmp" || true
    else
        log "Creating cache file"
        : > "${CACHE_FILE}.tmp"
    fi

    echo "${x}=${y}" >> "${CACHE_FILE}.tmp"
    mv "${CACHE_FILE}.tmp" "$CACHE_FILE"

    log "Cache after update:"
    sed 's/^/[workspace-nav]   /' "$CACHE_FILE"
}

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

WORKSPACE_ANIMATION="workspaces, 1, $WS_SPEED, $WS_FUNCTION"

set_animation() {
    case "$1" in
        left|right)
            hyprctl keyword animation "$WORKSPACE_ANIMATION, slide"
            ;;
        up|down)
            hyprctl keyword animation "$WORKSPACE_ANIMATION, slidevert"
            ;;
        teleport)
            hyprctl keyword animation "$WORKSPACE_ANIMATION, fade"
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
fi

if [[ "$COMMAND" == "teleportX" ]]; then
    TARGET_X="$TPX_X"

    log "teleportX requested: x=$TARGET_X"

    CACHED_Y=$(get_cached_y "$TARGET_X")

    printf 'CACHED_Y=<%s>\n' "$CACHED_Y" >&2

    if [[ -n "$CACHED_Y" ]]; then
        TARGET_Y="$CACHED_Y"
        log "Using cached y=$TARGET_Y"
    else
        TARGET_Y=2
        log "No cached value found, defaulting to y=$TARGET_Y"
    fi

    set_animation teleport
fi

if [[ "$COMMAND" == "teleport" ]]; then
    TARGET_X=($TP_X)
    TARGET_Y=($TP_Y)
    set_animation teleport
    log "Teleport -> x=$TARGET_X y=$TARGET_Y"
fi

log "Target coordinates: x=$TARGET_X y=$TARGET_Y"
TARGET_WS=$((TARGET_Y * WS_COL + TARGET_X))
log "Target workspace: $TARGET_WS"
MAX_WS=$((WS_COL * WS_ROW - 1))
set_cached_y "$TARGET_X" "$TARGET_Y"


if (( TARGET_WS < 0 || TARGET_WS > MAX_WS )); then
    log "Target workspace out of bounds"
    exit 1
fi

log "Switching to workspace ID: $((TARGET_WS + 1))"

hyprctl dispatch workspace "$((TARGET_WS + 1))"

log "Done."

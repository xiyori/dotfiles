#!/usr/bin/env bash
# Usage: scroll-columns-or-workspaces.sh [next|prev]

DIRECTION="$1"

# 1. Only fetch the focused window first (fastest check)
FOCUSED=$(niri msg --json focused-window)

# Fast exit if workspace is empty
if [[ "$FOCUSED" == "null" || -z "$FOCUSED" ]]; then
    if [[ "$DIRECTION" == "prev" ]]; then
        niri msg action focus-workspace-up
    else
        niri msg action focus-workspace-down
    fi
    exit 0
fi

# Extract CUR_COL and WS_ID in a single jq call
read -r CUR_COL WS_ID < <(jq -r '[(.layout.pos_in_scrolling_layout[0] // "floating"), .workspace_id] | @tsv' <<< "$FOCUSED")

# Fast exit if focused window is floating
if [[ "$CUR_COL" == "floating" ]]; then
    niri msg action switch-focus-between-floating-and-tiling
    exit 0
fi

# Fast path for "prev": if CUR_COL > 1, we don't even need to fetch all windows or workspaces!
if [[ "$DIRECTION" == "prev" && "$CUR_COL" -gt 1 ]]; then
    niri msg action focus-column-left
    exit 0
fi

# 2. Only fetch all windows if we are at an edge (CUR_COL == 1 for prev, or checking MAX_COL for next)
WINDOWS=$(niri msg --json windows)
MAX_COL=$(jq -r --argjson ws "$WS_ID" '[.[] | select(.workspace_id == $ws) | .layout.pos_in_scrolling_layout[0] // 0] | max // 0' <<< "$WINDOWS")

if [[ "$DIRECTION" == "next" && "$CUR_COL" -lt "$MAX_COL" ]]; then
    niri msg action focus-column-right
    exit 0
fi

# 3. Only fetch workspaces when we actually need to jump workspaces
WORKSPACES=$(niri msg --json workspaces)

TARGET_IDX=$(jq -rn \
    --arg dir "$DIRECTION" \
    --argjson ws_id "$WS_ID" \
    --argjson wins "$WINDOWS" \
    --argjson wss "$WORKSPACES" '
    ($wss[] | select(.id == $ws_id)) as $cur_ws
    | $cur_ws.output as $out
    | $cur_ws.idx as $idx

    | [ $wss[] | select(.output == $out) ] | sort_by(.idx) as $mon_ws
    | ([ $mon_ws[] | select(.name != null) | .idx ] | max // 0) as $max_named
    | ($max_named + 1) as $first_unnamed

    # Pre-calculate workspace IDs that contain windows for O(1) lookup

    | (INDEX($wins[].workspace_id | tostring; .)) as $occupied

    | [ $mon_ws[]
        | select(
            ($occupied[.id | tostring] != null)
            or (.idx == $first_unnamed and .name == null)
        )
      ] as $valid_ws

    | if $dir == "prev" then
        [ $valid_ws[] | select(.idx < $idx) ] | last | .idx // empty
      else
        [ $valid_ws[] | select(.idx > $idx) ] | first | .idx // empty
      end
')

if [[ -n "$TARGET_IDX" ]]; then
    niri msg action focus-workspace "$TARGET_IDX"
fi

#!/bin/bash
# Focus the first window matching app-id and title regexes, or run the command.
# Usage: focus_or_run.sh APP_ID_REGEX TITLE_REGEX COMMAND...

app_id="$1"
title="$2"
shift 2

id="$(niri msg --json windows | jq -r --arg a "$app_id" --arg t "$title" \
    '[.[] | select((.app_id // "" | test($a)) and (.title // "" | test($t)))][0].id // empty')"

if [[ -n "$id" ]]; then
    niri msg action focus-window --id "$id"
else
    exec "$@"
fi

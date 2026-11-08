#!/usr/bin/bash

niri msg --json windows | jq -r '.[].id' | xargs -I {} niri msg action close-window --id {}
systemctl "$1"

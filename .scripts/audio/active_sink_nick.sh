#!/bin/bash

pactl list sinks | sed -n "/$(~/.scripts/audio/list_active_sinks.sh | head -1)/,/^$/p" | grep -e "node\.nick" -e "media\.name" | cut -d'=' -f 2 | xargs | tr -d '"'

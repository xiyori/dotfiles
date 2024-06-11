#!/bin/bash

pactl list sinks | sed -n "/$(~/.scripts/audio/get_active_sink.sh)/,/^$/p" | grep -e "node\.nick" -e "media\.name" | cut -d'=' -f 2 | xargs | tr -d '"'

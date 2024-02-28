#!/bin/bash

wpctl inspect @DEFAULT_AUDIO_SINK@ | grep -e "node\.nick" -e "media\.name" | cut -d'=' -f 2 | xargs | tr -d '"'

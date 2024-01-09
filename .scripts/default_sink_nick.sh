#!/bin/bash

wpctl inspect @DEFAULT_AUDIO_SINK@ | grep node.nick | cut -d'=' -f 2

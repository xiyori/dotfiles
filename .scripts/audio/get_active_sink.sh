#!/bin/bash

~/.scripts/audio/pactl_sinks.sh | ~/.scripts/audio/filter_sinks.sh | grep RUNNING | head -1 | cut -f 2

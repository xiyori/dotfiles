#!/bin/bash

~/.scripts/audio/pactl_sinks.sh | grep RUNNING | head -1 | cut -f 2

#!/bin/bash

muted="$1"
echo "$muted" > /tmp/muted

# Refreshes the bar and, when open, the sound panel
~/.scripts/bar_refresh sound

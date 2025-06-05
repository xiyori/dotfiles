#!/bin/bash

~/.scripts/audio/pactl_sinks.sh | ~/.scripts/audio/filter_sinks.sh | cut -f 2

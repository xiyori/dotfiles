#!/bin/bash

~/.scripts/audio/remove_old_profile.sh "myeffects_sink:monitor_FL"
~/.scripts/audio/remove_old_profile.sh "myeffects_sink:monitor_FR"

profile="$1"
pw-link "myeffects_sink:monitor_FL" "${profile}:Input L"
pw-link "myeffects_sink:monitor_FR" "${profile}:Input R"

#!/bin/bash

killall utility_loop.sh

if ! pactl list short sinks | grep myeffects_sink ; then
    pw-cli create-node adapter '{ factory.name=support.null-audio-sink node.name="myeffects_sink" node.description="myeffects_sink" media.class=Audio/Sink object.linger=true audio.position=[FL FR] }'
fi
if ! pactl list short sinks | grep gain_sink ; then
    pw-cli create-node adapter '{ factory.name=support.null-audio-sink node.name="gain_sink" node.description="gain_sink" media.class=Audio/Sink object.linger=true monitor.channel-volumes=true audio.position=[FL FR] }'
fi

regex=".* ([0-9]+)\. myeffects_sink.*"
if [[ "$(wpctl status | grep -F ". myeffects_sink")" =~ $regex ]]; then
    wpctl set-default "${BASH_REMATCH[1]}"
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 1
    echo 4D > /tmp/loudness  # 65db initial loudness
    if ! pgrep carla ; then
        carla ~/.config/myeffects/carla.carxp > /tmp/carla.log 2>&1 & disown
        # pid="$!"
        # while [ "$(ps -o etimes= -p "$pid")" -lt 7 ]; do
        #     sleep 1
        # done
        while ! pactl list clients | grep "Big Meter" > /dev/null 2>&1 ; do
            sleep 1
        done
        ~/.scripts/audio/link_nodes.sh
        ~/.scripts/audio/utility_loop.sh > /dev/null 2>&1 & disown
    fi
else
    echo "audio effects startup failed"
fi

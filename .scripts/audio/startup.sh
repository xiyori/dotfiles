#!/bin/bash

if ! pactl list short sinks | grep myeffects_sink ; then
    pw-cli create-node adapter '{ factory.name=support.null-audio-sink node.name="myeffects_sink" node.description="myeffects_sink" media.class=Audio/Sink object.linger=true audio.position=[FL FR] }'
fi
if ! pactl list short sinks | grep gain_sink ; then
    pw-cli create-node adapter '{ factory.name=support.null-audio-sink node.name="gain_sink" node.description="gain_sink" media.class=Audio/Sink object.linger=true monitor.channel-volumes=true audio.position=[FL FR] }'
fi

regex=".* ([0-9]+)\. myeffects_sink.*"
if [[ "$(wpctl status | grep "\. myeffects_sink")" =~ $regex ]]; then
    wpctl set-default "${BASH_REMATCH[1]}"
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 1
    echo 4D > /tmp/loudness  # 65db initial loudness
    if ! pgrep carla ; then
        carla ~/.config/myeffects/carla.carxp > /tmp/carla.log 2>&1 & disown
    fi
else
    echo "audio effects startup failed"
fi

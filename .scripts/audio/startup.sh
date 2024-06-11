#!/bin/bash

pw-cli create-node adapter '{ factory.name=support.null-audio-sink node.name="myeffects_sink" node.description="myeffects_sink" media.class=Audio/Sink object.linger=true audio.position=[FL FR] }'

regex=".* ([0-9]+)\. myeffects_sink.*"
if [[ "$(wpctl status | grep "\. myeffects_sink")" =~ $regex ]]
then
    wpctl set-default "${BASH_REMATCH[1]}"
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 1
    echo 4D > /tmp/loudness  # 65db initial loudness
    nohup carla "/home/sergej/.config/myeffects.carxp" &
else
    echo "audio effects startup failed"
fi

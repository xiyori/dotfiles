#!/bin/bash

if ! pactl list short sinks | grep myeffects_sink ; then
    pw-cli create-node adapter '{ factory.name=support.null-audio-sink node.name="myeffects_sink" node.description="myeffects_sink" media.class=Audio/Sink object.linger=true monitor.channel-volumes=true audio.position=[FL FR] }'
fi

regex=".* ([0-9]+)\. myeffects_sink.*"
if [[ "$(wpctl status | grep -F ". myeffects_sink")" =~ $regex ]]; then
    wpctl set-default "${BASH_REMATCH[1]}"
    pactl set-sink-volume myeffects_sink 100%
    echo 65 > /tmp/loudness  # 65db initial loudness
    if ! pgrep carla ; then
        killall utility_loop.sh > /dev/null 2>&1
        if [ -n "$1" ]; then
            # export PIPEWIRE_LATENCY="64/48000"
            pw-metadata -n settings 0 clock.force-quantum 64
            echo "low_latency" > /tmp/low_latency
            pactl set-sink-volume myeffects_sink -18db  # 65db initial loudness
        else
            # export PIPEWIRE_LATENCY="2048/48000"
            pw-metadata -n settings 0 clock.force-quantum 1024
            echo "default" > /tmp/low_latency
        fi
        carla ~/.config/myeffects/carla.carxp > /tmp/carla.log 2>&1 & disown
        # pid="$!"
        # while [ "$(ps -o etimes= -p "$pid")" -lt 7 ]; do
        #     sleep 1
        # done
        while ! pactl list clients | grep "LSP Loudness Compensator Stereo" > /dev/null 2>&1 ; do
            sleep 1
        done
        ~/.scripts/audio/link_nodes.sh "$1" > /dev/null 2>&1
        ~/.scripts/audio/utility_loop.sh "$1" > /dev/null 2>&1 & disown
    fi
else
    echo "audio effects startup failed"
fi

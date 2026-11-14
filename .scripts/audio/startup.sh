#!/bin/bash

if ! pactl list short sinks | grep -q myeffects_sink ; then
    pw-cli create-node adapter '{ factory.name=support.null-audio-sink node.name="myeffects_sink" node.description="myeffects_sink" media.class=Audio/Sink object.linger=true monitor.channel-volumes=true audio.position=[FL FR] }'
fi

regex=".* ([0-9]+)\. myeffects_sink.*"
if [[ "$(wpctl status | grep -F ". myeffects_sink")" =~ $regex ]]; then
    wpctl set-default "${BASH_REMATCH[1]}"
    pactl set-sink-volume myeffects_sink 100%
    echo 65 > /tmp/loudness  # 65db initial loudness
    if ! pgrep carla ; then
        if [[ -n "$1" ]]; then
            # echo "Set CPU governor to performance"
            # sudo cpupower frequency-set -g performance
            pw-metadata -n settings 0 clock.force-quantum 96
            # pw-metadata -n settings 0 clock.force-rate 0

            pactl set-sink-volume myeffects_sink -18db  # 65db initial loudness
        else
            pw-metadata -n settings 0 clock.force-quantum 1024
            # pw-metadata -n settings 0 clock.force-rate 0

            carla ~/.config/myeffects/carla.carxp > /tmp/carla.log 2>&1 & disown
            until pactl list clients | grep -q "LSP Loudness Compensator Stereo" ; do
                sleep 1
            done
            sleep 1
            ~/.scripts/audio/link_nodes.sh
        fi
        ~/.scripts/audio/detect_sink_change.sh
        systemctl --user start dbus-monitor.service
    fi
else
    echo "audio effects startup failed"
fi

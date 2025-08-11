#!/bin/bash

case "$1" in 
  play-pause|next|previous|status|metadata)
    ~/.scripts/audio/player.sh "$1"
    pkill -USR2 hyprlock
    exit 0
  ;;
  mute)
    for active_sink in $(~/.scripts/audio/list_active_sinks.sh) ; do
        pactl set-sink-mute "$active_sink" toggle
    done
    case "$(pactl get-sink-mute "$active_sink")" in
      *yes)
        echo 1 > /tmp/muted
        message="󰖁  Mute sound"
      ;;
      *)
        echo 0 > /tmp/muted
        message="󰕾  Unmute sound"
      ;;
    esac
    hyprctl activewindow | grep "fullscreen: 0" || notify-send -e -h string:x-canonical-private-synchronous:volume_notif -h boolean:SWAYNC_BYPASS_DND:true -u low "$message"
  ;;
  *)
    if [[ "$(cat /tmp/low_latency)" == "low_latency" ]]; then
        ~/.scripts/audio/bypass_volume.sh "$1"
    else
        ~/.scripts/audio/volume.sh "$1"
    fi
    volume="$(cat /tmp/loudness | awk '$0<40{$0=40}$0>83{$0=83}1')"
    volume=$(((volume - 40) * 100 / (83 - 40)))
    if ! hyprctl activewindow | grep "fullscreen: 0" ; then
        case "$1" in
          *up)
            icon="󰝝 "
          ;;
          *down)
            icon="󰝞 "
          ;;
        esac
        notify-send -e -h int:value:"$volume" -h string:x-canonical-private-synchronous:volume_notif -h boolean:SWAYNC_BYPASS_DND:true -u low --expire-time 1000 "$icon $(cat /tmp/loudness)db"
    fi
  ;;
esac

pkill -RTMIN+1 waybar

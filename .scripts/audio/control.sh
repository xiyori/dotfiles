#!/bin/bash

argument="$1"
case "$argument" in
  custom_action)
    if [[ "$(cat /tmp/tablet_mode)" -eq 1 ]]; then
      eww active-windows | grep "sound-window" && eww close sound-window || ( eww update volume="$(cat /tmp/loudness)" && eww open sound-window )
      exit 0
    fi
    argument="play-pause"
  ;&
  play-pause|next|previous|status|metadata)
    ~/.scripts/audio/player.sh "$argument"
    pkill -USR2 hyprlock
    exit 0
  ;;
  mute)
    for active_sink in $(~/.scripts/audio/list_active_sinks.sh) ; do
        pactl set-sink-mute "$active_sink" toggle
    done
    message="$(~/.scripts/audio/mute_status.sh "$active_sink")"
    hyprctl activewindow | grep "fullscreen: 0" || notify-send -e -h string:x-canonical-private-synchronous:volume_notif -h boolean:SWAYNC_BYPASS_DND:true -u low "$message"
  ;;
  *)
    if [[ "$(cat /tmp/low_latency)" == "low_latency" ]]; then
        ~/.scripts/audio/bypass_volume.sh "$argument"
    else
        ~/.scripts/audio/volume.sh "$argument"
    fi
    volume="$(cat /tmp/loudness | awk '$0<40{$0=40}$0>83{$0=83}1')"
    volume=$(((volume - 40) * 100 / (83 - 40)))
    if ! hyprctl activewindow | grep "fullscreen: 0" ; then
        case "$argument" in
          *up)
            icon="󰝝 "
          ;;
          *down)
            icon="󰝞 "
          ;;
          *)
            icon=""
          ;;
        esac
        [[ -n "$icon" ]] && notify-send -e -h int:value:"$volume" -h string:x-canonical-private-synchronous:volume_notif -h boolean:SWAYNC_BYPASS_DND:true -u low --expire-time 1000 "$icon $(cat /tmp/loudness)db"
    fi
    pkill -RTMIN+1 waybar
  ;;
esac


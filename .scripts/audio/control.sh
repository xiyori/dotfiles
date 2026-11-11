#!/bin/bash

argument="$1"
notify="${2:-notify}"

case "$argument" in
  custom_action)
    if [[ "$(cat /tmp/tablet_mode)" -eq 1 ]]; then
      ~/.scripts/widget_toggle sound
      exit 0
    fi
    argument="play-pause"
  ;&
  play-pause|next|previous|status|metadata)
    ~/.scripts/audio/player.sh "$argument"
  ;;
  mute)
    pactl get-sink-mute "$(~/.scripts/audio/get_active_sink.sh)" | grep -q no
    muted="$?"
    (( muted ^= 1 ))
    for active_sink in $(~/.scripts/audio/list_active_sinks.sh) ; do
      pactl set-sink-mute "$active_sink" "$muted"
    done
    ~/.scripts/audio/muted_update.sh "$muted"
    if [[ "$notify" == "notify" ]]; then
      if [[ "$muted" -eq 1 ]]; then
        message="󰖁  Mute sound"
      else
        message="$(~/.scripts/audio/volume_icon.sh)  Unmute sound"
      fi
      notify-send -e -h string:x-canonical-private-synchronous:volume_notif -h boolean:SWAYNC_BYPASS_DND:true -u low "$message"
    fi
    ~/.scripts/bar_refresh sound
  ;;
  *)
    if [[ "$(pactl get-default-sink)" == "Home Theater" ]]; then
      ~/.scripts/audio/bypass_volume.sh "$argument"
    elif pactl list clients | grep -q "LSP Loudness Compensator Stereo"; then
      ~/.scripts/audio/volume.sh "$argument"
    else
      ~/.scripts/audio/bypass_volume.sh "$argument"
    fi
    if [[ "$notify" == "notify" ]]; then
      case "$argument" in
        *up|*down)
          volume="$(cat /tmp/loudness | awk '$0<40{$0=40}$0>83{$0=83}1')"
          volume=$(( (volume - 40) * 100 / (83 - 40) ))
          icon="$(~/.scripts/audio/volume_icon.sh)"
          notify-send -e -h int:value:"$volume" -h string:x-canonical-private-synchronous:volume_notif -h boolean:SWAYNC_BYPASS_DND:true -u low --expire-time 1000 "$icon $(cat /tmp/loudness)db"
        ;;
      esac
    fi
    ~/.scripts/bar_refresh sound
  ;;
esac
exit 0

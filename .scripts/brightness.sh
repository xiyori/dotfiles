#!/usr/bin/bash

argument="$1"
current="$(brightnessctl -m | awk -F, '{print substr($4, 0, length($4)-1)}')"

case "$argument" in
  up)
    # increase the backlight by 5%
    delta="$(( current < 5 ? 1 : 5 ))"
    brightnessctl set "$(( current + delta ))%"
  ;;
  down)
    # decrease the backlight by 5%
    delta="$(( current <= 5 ? 1 : 5 ))"
    brightnessctl set "$(( current <= 1 ? 1 : current - delta ))%"
  ;;
  custom_action)
    if [[ "$(cat /tmp/tablet_mode)" -eq 1 ]]; then
      if [[ "$current" -lt 5 ]]; then
        eww_var="$(( current - 1 ))"
      else
        eww_var="$(( current / 5 + 3 ))"
      fi
      eww active-windows | grep -q "brightness-window" && eww close brightness-window || ( eww update brightness="$eww_var" && eww open brightness-window )
    fi
  ;;
  *)
    if [[ "$argument" -lt 4 ]]; then
      target="$(( argument + 1 ))"
    else
      target="$(( (argument - 3) * 5 ))"
    fi
    brightnessctl set "${target}%"
  ;;
esac

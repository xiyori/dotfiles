#!/usr/bin/bash

current="$(brightnessctl -m | awk -F, '{print substr($4, 0, length($4)-1)}')"
max="$(brightnessctl -m | awk -F, '{print $5}')"
case $1 in
  up)
    # increase the backlight by 5%
    brightnessctl set "$(( (current + 5) * max / 100 ))"
    ;;
  down)
    # decrease the backlight by 5%
    brightnessctl set "$(( (current < 5 ? 0 : current - 5) * max / 100 ))"
    ;;
esac

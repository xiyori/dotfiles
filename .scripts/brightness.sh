#!/usr/bin/bash

current="$(brightnessctl -m | awk -F, '{print substr($4, 0, length($4)-1)}')"
case $1 in
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
esac

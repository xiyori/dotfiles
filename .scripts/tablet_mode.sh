#!/usr/bin/env bash

function tablet_mode ()
{
  squeekboard & disown
  iio-hyprland & disown
  eww daemon
  gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true
  echo 1 > /tmp/tablet_mode
}

function laptop_mode ()
{
  killall squeekboard
  killall iio-hyprland
  eww kill
  gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled false
  echo 0 > /tmp/tablet_mode
}

echo 0 > /tmp/tablet_mode
while read -r line; do
  if (( "$(echo "$line" | awk '{print $7}')" )); then
    tablet_mode
  else
    laptop_mode
  fi
done < <(tail -n0 -f /tmp/tablet_switch)

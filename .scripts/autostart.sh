#!/usr/bin/bash

# Policy Authentication Agent
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# https://wiki.hyprland.org/FAQ/#some-of-my-apps-take-a-really-long-time-to-open
# https://gist.github.com/PowerBall253/2dea6ddf6974ba4e5d26c3139ffb7580
systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &
dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP --all &

# waybar
echo "" > /tmp/custom_monitor_waybar
~/.scripts/launch_waybar &

# wallpaper
nohup swww-daemon &
swww img "$WALLPAPER1" -t none

# other
hyprctl setcursor Bibata-Modern-Classic 24

# applets
blueman-applet &
nm-applet &
wlsunset -l 56.2 -L 36.3 &

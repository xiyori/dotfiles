#!/usr/bin/bash

# hyprlock
{ ~/.scripts/lock || hyprctl dispatch exit ; } &

# Policy Authentication Agent
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# https://wiki.hyprland.org/FAQ/#some-of-my-apps-take-a-really-long-time-to-open
# https://gist.github.com/PowerBall253/2dea6ddf6974ba4e5d26c3139ffb7580
systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &
dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP --all &

~/.scripts/audio/startup.sh

# waybar
ln -s $XDG_RUNTIME_DIR/hypr /tmp/hypr
echo "" > /tmp/custom_monitor_waybar
~/.scripts/launch_waybar &

# wallpaper
swww-daemon > /tmp/swww.log 2>&1 & disown
swww img "$WALLPAPER1" -t none

# other
powerline-daemon
hyprctl setcursor "$XCURSOR_THEME" $XCURSOR_SIZE
xsetroot -xcf "/usr/share/icons/$XCURSOR_THEME/cursors/left_ptr" $XCURSOR_SIZE
wl-clip-persist --clipboard regular &
wl-paste --watch cliphist store &

# applets
blueman-applet &
nm-applet &
wlsunset -l 56.2 -L 36.3 > /dev/null 2>&1 & disown

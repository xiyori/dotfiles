#!/usr/bin/bash

# Policy Authentication Agent
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# https://wiki.hyprland.org/FAQ/#some-of-my-apps-take-a-really-long-time-to-open
# https://gist.github.com/PowerBall253/2dea6ddf6974ba4e5d26c3139ffb7580
systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP LATITUDE LONGITUDE &
dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP --all &

# monitors
xrdb -merge ~/.Xresources
~/.scripts/startup_monitor.sh &

# wallpaper
swww-daemon > /tmp/swww.log 2>&1 & disown
~/.scripts/wallpaper.sh init

# hyprlock
{ ~/.scripts/lock || hyprctl dispatch exit && swww img "$(~/.scripts/wallpaper.sh query)" ; } &

# other
powerline-daemon
hyprctl setcursor "$XCURSOR_THEME" $XCURSOR_SIZE
xsetroot -xcf "/usr/share/icons/$XCURSOR_THEME/cursors/left_ptr" $XCURSOR_SIZE
killall wl-clip-persist ; wl-clip-persist --clipboard regular > /dev/null 2>&1 & disown
# killall wl-paste ; cliphist wipe ; wl-paste --watch cliphist store &

# applets
blueman-applet & disown
nm-applet & disown
swaync & disown

# wlsunset
# killall wlsunset ; wlsunset -t 3400 -T 4600 -l $LATITUDE -L $LONGITUDE > /tmp/wlsunset.log 2>&1 & disown
killall wlsunset ; wlsunset -l $LATITUDE -L $LONGITUDE > /tmp/wlsunset.log 2>&1 & disown

# audio
~/.scripts/audio/startup.sh

# waybar
ln -s $XDG_RUNTIME_DIR/hypr /tmp/hypr
echo "" > /tmp/custom_monitor_waybar
~/.scripts/launch_waybar

# touch
~/.scripts/tablet_mode.sh > /dev/null 2>&1 & disown
hyprpm reload -n

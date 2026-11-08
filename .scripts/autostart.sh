#!/usr/bin/bash

# lock & wallpaper
~/.scripts/wallpaper.sh init  # should be instanteneous

( ~/.scripts/lock || niri msg action quit --skip-confirmation ) &
awww-daemon > /tmp/awww.log 2>&1 & disown
awww img "$(~/.scripts/wallpaper.sh query)" -t none

# Policy Authentication Agent
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 2>&1 & disown

# https://yalter.github.io/niri/Important-Software.html

( systemctl --user import-environment LATITUDE LONGITUDE
dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP --all
) &

# monitors
( xrdb -merge ~/.Xresources ; ~/.scripts/startup_monitor.sh ) &

# other
powerline-daemon
xsetroot -xcf "/usr/share/icons/$XCURSOR_THEME/cursors/left_ptr" $XCURSOR_SIZE
killall wl-clip-persist ; wl-clip-persist --clipboard regular > /dev/null 2>&1 & disown
# killall wl-paste ; cliphist wipe ; wl-paste --watch cliphist store &

# applets
blueman-applet & disown
nm-applet & disown
# swaync & disown

# wlsunset
# killall wlsunset ; wlsunset -t 3400 -T 4600 -l $LATITUDE -L $LONGITUDE > /tmp/wlsunset.log 2>&1 & disown
killall wlsunset ; wlsunset -l $LATITUDE -L $LONGITUDE > /tmp/wlsunset.log 2>&1 & disown

# audio
~/.scripts/audio/startup.sh

# waybar
echo "" > /tmp/custom_monitor_waybar
~/.scripts/launch_waybar

# librewolf extension popups
~/.scripts/librewolf_extension_float.sh > /dev/null 2>&1 & disown

# touch
# iio-niri & disown
# ~/.scripts/tablet_mode.sh > /dev/null 2>&1 & disown

# prevent silent power on
# cat /proc/acpi/button/lid/LID0/state | grep -q open || ( date >> ~/unexpected_power_on ; shutdown now )

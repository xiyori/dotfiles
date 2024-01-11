#!/usr/bin/bash

# Policy Authentication Agent
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# https://wiki.hyprland.org/FAQ/#some-of-my-apps-take-a-really-long-time-to-open
# https://gist.github.com/PowerBall253/2dea6ddf6974ba4e5d26c3139ffb7580
systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &
dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP --all &

# gsettings
# gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Mocha-Standard-Blue-Dark'
# gsettings set org.gnome.desktop.interface font-name 'Noto Sans'
# gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
# gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'

# waybar
echo "{\"text\": \"us\", \"tooltip\": \"English (US)\"}" > /tmp/kb_layout
~/.scripts/launch_waybar &

# wallpaper
swww init
swww img ~/Pictures/wallpaper/cirno_3.jpg -t none

# applets
blueman-applet &
nm-applet &

# other
hyprctl setcursor Bibata-Modern-Classic 24

#exec-once=redshift

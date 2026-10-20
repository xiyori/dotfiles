#!/bin/bash

if ! systemctl --user is-active --quiet mpd.service ; then
    systemctl --user start mpd.service && { kitty rmpc & } || { notify-send "Library is not connected!" ; exit 1 ; }
    systemctl --user start mpd-mpris.service
else
    kitty rmpc
fi

pragma Singleton

import QtQuick
import Quickshell

// Replacement for waybar's `pkill -RTMIN+N waybar`: scripts call
// `~/.scripts/bar_refresh <name>` which ends up here through IPC.
Singleton {
    signal requested(string name)
}

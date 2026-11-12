pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Backlight status module similar to waybar's backlight module.
// Shows current brightness level with icons.
Singleton {
    id: root

    property string device: ""
    // property int updateInterval: 5000

    readonly property var icons: [
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        "",
        ""
    ]

    readonly property int percent: backlightPercent
    readonly property bool powered: backlightPercent > 0

    property int backlightPercent: 0

    function getIcon(percent) {
        const idx = Math.min(icons.length - 1, Math.floor(percent * icons.length / 100))
        return icons[idx] ?? ""
    }

    function getTooltip() {
        return `Brightness: ${backlightPercent}%`
    }

    Process {
        id: brightnessProc
        command: ["sh", "-c", `brightnessctl -m | awk -F, '{print substr($4, 0, length($4)-1)}' || echo 0`]
        stdout: StdioCollector {
            onStreamFinished: {
                backlightPercent = parseInt(text.trim())
            }
        }
    }

    Component.onCompleted: {
        brightnessProc.running = true
    }

    Connections {
        target: Refresh
        function onRequested(name) {
            if (name === "brightness")
                brightnessProc.running = true
        }
    }
}

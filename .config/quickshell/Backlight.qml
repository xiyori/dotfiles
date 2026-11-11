pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Backlight status module similar to waybar's backlight module.
// Shows current brightness level with icons.
Singleton {
    id: root

    property string device: ""
    property int updateInterval: 2000

    readonly property var icons: [
        "\ue90c", // 0%
        "\ue90d", // 10%
        "\ue90e", // 20%
        "\ue90f", // 30%
        "\ue910", // 40%
        "\ue911", // 50%
        "\ue912", // 60%
        "\ue913", // 70%
        "\ue914", // 80%
        "\ue915", // 90%
        "\ue916"  // 100%
    ]

    readonly property int percent: backlightPercent
    readonly property bool powered: backlightPercent > 0

    property int backlightPercent: 100
    property int maxBrightness: 100
    property int currentBrightness: 100

    function updateBrightness(text) {
        const value = parseInt(text)
        if (!isNaN(value)) {
            currentBrightness = value
            maxBrightness = getMaximumBrightness()
            const percent = maxBrightness > 0 ? Math.round(100 * currentBrightness / maxBrightness) : 100
            backlightPercent = percent
        }
    }

    function getMaximumBrightness() {
        // Returns max brightness from the device
        return maxBrightness
    }

    function getIcon(percent) {
        const idx = Math.min(10, Math.floor(percent / 10))
        return icons[idx]
    }

    function getTooltip() {
        return `Brightness: ${backlightPercent}%`
    }

    Process {
        id: maxBrightnessProc
        command: ["sh", "-c", `cat /sys/class/backlight/${device === '' ? '' : device + '/'}max_brightness 2>/dev/null || echo 100`]
        stdout: StdioCollector {
            onStreamFinished: {
                const value = parseInt(text.trim())
                if (!isNaN(value)) {
                    maxBrightness = value
                }
            }
        }
    }

    Process {
        id: brightnessProc
        command: ["sh", "-c", `cat /sys/class/backlight/${device === '' ? '' : device + '/'}actual_brightness 2>/dev/null || echo 100`]
        stdout: StdioCollector {
            onStreamFinished: root.updateBrightness(text)
        }
    }

    Timer {
        interval: updateInterval
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            maxBrightnessProc.running = true
            brightnessProc.running = true
        }
    }
}

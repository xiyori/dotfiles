pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Battery status module similar to waybar's battery module.
// Shows battery percentage with icons based on state and capacity.
Singleton {
    id: root

    property int warning: 30
    property int critical: 10
    property int updateInterval: 5000
    property int flashInterval: 2000

    readonly property var icons: [
        "󰁺", // 0%
        "󰁻", // 10%
        "󰁼", // 20%
        "󰁽", // 30%
        "󰁾", // 40%
        "󰁿", // 50%
        "󰂀", // 60%
        "󰂁", // 70%
        "󰂂", // 80%
        "󰁹"  // 90%
    ]

    readonly property string iconFull: "󱟢"
    readonly property string iconCharging: "󰂄"
    readonly property string iconPlugged: "󰚥"

    readonly property int capacity: capacityBattery
    readonly property string status: batteryStatus
    readonly property bool isPlugged: batteryStatus === "fully-charged" || batteryStatus === "charging" || batteryStatus === "pending-charge" || batteryStatus === "pending-discharge"
    readonly property bool isLow: capacityBattery < 25
    readonly property bool isCritical: capacityBattery < 15

    property int capacityBattery: 0
    property string batteryStatus: "Unknown"
    property string batteryTime: ""
    property int healthBattery: 0

    function updateInfo(text) {
        const lines = text.trim().split("\n")
        for (const line of lines) {
            {
                const match = line.match(/percentage:\s*(\d+).*/)
                if (match) {
                    capacityBattery = parseInt(match[1])
                    continue
                }
            }
            {
                const match = line.match(/state:\s*([a-z\-]+)/)
                if (match) {
                    batteryStatus = match[1]
                    continue
                }
            }
            {
                const match = line.match(/time to empty:\s*(.+)/)
                if (match) {
                    batteryTime = match[1]
                    continue
                }

            }            
            {
                const match = line.match(/capacity:\s*(\d+).*/)
                if (match) {
                    healthBattery = parseInt(match[1])
                    continue
                }
            }
        }
        if (!root.isCritical)
            flashRed = false
    }

    function getStatusIcon() {
        if (batteryStatus === "fully-charged")
            return iconFull
        if (batteryStatus === "charging")
            return iconCharging
        if (batteryStatus === "pending-charge" || batteryStatus === "pending-discharge")
            return iconPlugged
        const idx = Math.min(icons.length - 1, Math.floor(capacityBattery * icons.length / 100))
        return icons[idx] ?? ""
    }

    function getTooltip() {
        var tooltip = `${batteryStatus.charAt(0).toUpperCase() + batteryStatus.slice(1)}`
        if (batteryTime !== "")
            tooltip += `\n${batteryTime} left`
        if (healthBattery !== 0)
            tooltip += `\nHealth: ${healthBattery}%`
        return tooltip
    }

    Process {
        id: infoProc
        command: ["sh", "-c", `upower -i "$(upower -e | grep BAT | head -1)"`]
        stdout: StdioCollector {
            onStreamFinished: root.updateInfo(text)
        }
    }

    Timer {
        interval: root.updateInterval
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            infoProc.running = true
        }
    }

    property bool flashRed: false

    Timer {
        interval: root.flashInterval
        running: root.isCritical
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root.flashRed = !root.flashRed
        }
    }
}

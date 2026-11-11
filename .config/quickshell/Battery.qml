pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Battery status module similar to waybar's battery module.
// Shows battery percentage with icons based on state and capacity.
Singleton {
    id: root

    property string bat: ""
    property int warning: 30
    property int critical: 10
    property int updateInterval: 2000

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
    readonly property bool isCharging: batteryStatus === "Charging"
    readonly property bool isPlugged: batteryStatus === "Full" || batteryStatus === "Charging"

    property int capacityBattery: 0
    property string batteryStatus: "Unknown"

    function updateCapacity(text) {
        const lines = text.trim().split("\n")
        for (const line of lines) {
            const match = line.match(/POWER_SUPPLY_CAPACITY=(\d+)/)
            if (match) {
                capacityBattery = parseInt(match[1])
                return
            }
        }
    }

    function updateStatus(text) {
        const lines = text.trim().split("\n")
        for (const line of lines) {
            const match = line.match(/POWER_SUPPLY_STATUS=(\w+)/)
            if (match) {
                batteryStatus = match[1]
                return
            }
        }
    }

    function getIcon(capacity) {
        if (batteryStatus === "Full")
            return iconFull
        if (isCharging)
            return iconCharging
        if (isPlugged)
            return iconPlugged
        const idx = Math.min(9, Math.floor(capacity / 10))
        return icons[idx]
    }

    function getFormattedTime() {
        // Get remaining time in format HH:MM
        // This is a simplified implementation
        return ""
    }

    function getStatusIcon() {
        if (isCharging)
            return iconCharging
        if (isPlugged)
            return iconPlugged
        return getIcon(capacityBattery)
    }

    function getTooltip() {
        const time = getFormattedTime()
        if (time !== "")
            return `${batteryStatus}: ${capacityBattery}% (${time})`
        return `${batteryStatus}: ${capacityBattery}%`
    }

    Process {
        id: capacityProc
        command: ["sh", "-c", `cat /sys/class/power_supply/${bat === '' ? '' : bat + '/'}capacity 2>/dev/null || echo 0`]
        stdout: StdioCollector {
            onStreamFinished: root.updateCapacity(text)
        }
    }

    Process {
        id: statusProc
        command: ["sh", "-c", `cat /sys/class/power_supply/${bat === '' ? '' : bat + '/'}status 2>/dev/null || echo Unknown`]
        stdout: StdioCollector {
            onStreamFinished: root.updateStatus(text)
        }
    }

    Timer {
        interval: updateInterval
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            capacityProc.running = true
            statusProc.running = true
        }
    }
}

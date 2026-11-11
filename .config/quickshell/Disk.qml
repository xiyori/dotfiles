pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Disk usage module similar to waybar's disk module.
// Shows disk usage percentage for specified paths.
Singleton {
    id: root

    property var paths: ["/"]
    property string separator: " "
    property string unit: "B"

    readonly property int system: diskPercentages[0] ?? 0
    readonly property int data: diskPercentages[1] ?? 0

    property var diskPercentages: []
    property string diskTooltip: ""

    function updateTooltip() {
        const labels = []
        for (let i = 0; i < root.paths.length; i++) {
            const path = root.paths[i]
            const percent = root.diskPercentages[i] ?? 0
            labels.push(`${path}: ${percent}% used`)
        }
        root.diskTooltip = labels.join("\n")
    }

    function getTooltip() {
        return root.diskTooltip
    }

    Process {
        id: diskProc
        command: ["sh", "-c", "stat -f -c '%b %a' / /mnt/data"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n")
                const percentages = []
                for (const line of lines) {
                    const parts = line.split(" ").map(Number)
                    if (parts.length >= 2) {
                        const total = parts[0]
                        const avail = parts[1]
                        const usedPercent = total > 0 ? Math.round(100 * (total - avail) / total) : 0
                        percentages.push(usedPercent)
                    }
                }
                root.diskPercentages = percentages
                root.updateTooltip()
            }
        }
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: diskProc.running = true
    }
}

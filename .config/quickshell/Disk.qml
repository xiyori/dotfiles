pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Disk usage module similar to waybar's disk module.
// Shows disk usage percentage for specified paths.
Singleton {
    id: root

    property var paths: ["/"]
    readonly property string unit: "GB"

    property var diskTotals: []
    property var diskAvails: []
    property string diskText: ""
    property string diskTooltip: ""

    function updateText() {
        const labels = []
        for (let i = 0; i < root.paths.length; i++) {
            const total = root.diskTotals[i]
            const avail = root.diskAvails[i]
            const percent = total > 0 ? Math.round(100 * (total - avail) / total) : 0
            labels.push(`${percent}%`)
        }
        root.diskText = labels.join(",")
    }

    function updateTooltip() {
        const labels = []
        for (let i = 0; i < root.paths.length; i++) {
            const path = root.paths[i]
            const total = Math.round(root.diskTotals[i])
            const used = Math.round(total - root.diskAvails[i])
            labels.push(`${path}: ${used}${unit} / ${total}${unit} used`)
        }
        root.diskTooltip = labels.join("\n")
    }

    Process {
        id: diskProc
        command: ["sh", "-c", "stat -f -c '%b %a %S' " + paths.join(" ")]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n")
                const totals = []
                const avails = []
                for (const line of lines) {
                    const parts = line.split(" ").map(Number)
                    if (parts.length >= 3) {
                        const total = parts[0]
                        const avail = parts[1]
                        const block = parts[2]
                        totals.push(total * block / 2 ** 30)
                        avails.push(avail * block / 2 ** 30)
                    } else {
                        totals.push(0)
                        avails.push(0)
                    }
                }
                root.diskTotals = totals
                root.diskAvails = avails
                root.updateText()
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

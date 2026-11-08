import QtQuick
import Quickshell
import Quickshell.Io

// swaync notification indicator (`swaync-client -swb` streams its state as JSON).
TextPill {
    id: root

    property string alt: "none"

    readonly property string icon: alt.startsWith("dnd") ? "\uf1f7" : "\uf0a2"
    readonly property bool pending: alt.endsWith("notification")

    richText: true
    text: icon + (pending ? "<span style='color:red'><sup>\uf444</sup></span>" : "")
    leftRadius: 0
    leftPadding: 5
    clickCommand: "swaync-client -t -sw"
    rightClickCommand: "swaync-client -d -sw"

    Process {
        id: stream
        running: true
        command: ["swaync-client", "-swb"]
        stdout: SplitParser {
            onRead: data => {
                try {
                    root.alt = JSON.parse(data).alt ?? "none";
                } catch (e) {}
            }
        }
        onExited: retry.start()
    }

    Timer {
        id: retry
        interval: 5000
        onTriggered: stream.running = true
    }
}

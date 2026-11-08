import QtQuick
import Quickshell
import Quickshell.Io

// Equivalent of a waybar `custom/*` module with `return-type: json`: runs
// `exec` at startup, every `interval` seconds and whenever `signalName` is
// refreshed, and hides itself when the script prints nothing.
TextPill {
    id: root

    property string exec: ""
    property int interval: 0
    property string signalName: ""

    // Pango markup in waybar tooltips; `plainTooltip` shows them verbatim
    property bool plainTooltip: false

    visible: text !== ""

    function refresh() {
        if (!proc.running)
            proc.running = true;
    }

    function parse(raw) {
        const out = raw.trim();
        if (out === "") {
            text = "";
            tooltip = "";
            return;
        }
        try {
            const data = JSON.parse(out);
            text = data.text ?? "";
            tooltip = data.tooltip ?? "";
        } catch (e) {
            text = out;
            tooltip = "";
        }
    }

    tooltipMarkup: !plainTooltip
    Component.onCompleted: refresh()

    Process {
        id: proc
        command: ["sh", "-c", root.exec]
        stdout: StdioCollector {
            onStreamFinished: root.parse(text)
        }
    }

    Timer {
        interval: root.interval * 1000
        running: root.interval > 0
        repeat: true
        onTriggered: root.refresh()
    }

    Connections {
        target: Refresh
        function onRequested(name) {
            if (name === root.signalName)
                root.refresh();
        }
    }
}

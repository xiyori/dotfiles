import QtQuick
import Quickshell
import Quickshell.Io

// Brightness slider for tablet mode (formerly the eww brightness-window).
// The slider has 25 steps: 0-3 are 1-4%, 4-24 are 5% increments.
PanelWindowBase {
    id: root

    property real level: 10
    property bool opening: false

    anchors {
        top: true
        left: true
    }
    margins.left: Math.round((screen?.width ?? 0) * 0.16) - pad

    function toggle() {
        if (shown) {
            shown = false;
        } else if (!reader.running) {
            opening = true;
            reader.running = true;
        }
    }

    Process {
        id: reader
        command: ["sh", "-c", "brightnessctl -m | awk -F, '{print substr($4, 0, length($4)-1)}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                const current = parseInt(text);
                if (!isNaN(current))
                    root.level = current < 5 ? current - 1 : Math.floor(current / 5) + 3;
                if (root.opening) {
                    root.opening = false;
                    root.shown = true;
                }
            }
        }
    }

    PanelSlider {
        anchors.verticalCenter: parent.verticalCenter
        from: 0
        to: 24
        value: root.level
        onCommitted: v => Quickshell.execDetached(["sh", "-c", "~/.scripts/brightness.sh " + v])
    }
}

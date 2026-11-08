import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland

// Floating overlay panel for the touch widgets (replaces the eww windows).
// Content is laid out horizontally inside a rounded, pink-bordered frame.
PanelWindow {
    id: root

    default property alias content: row.data
    property bool shown: false
    readonly property int pad: 12

    screen: Quickshell.screens[0] ?? null
    visible: shown
    color: "transparent"
    exclusiveZone: 0
    implicitWidth: frame.width + 2 * pad
    implicitHeight: frame.y + frame.height + pad
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-widget"

    MultiEffect {
        source: frame
        anchors.fill: frame
        shadowEnabled: true
        shadowColor: "#aa1a1a1a"
        shadowBlur: 1.0
        shadowOpacity: 1.0
    }

    Rectangle {
        id: frame
        x: root.pad
        y: 5
        width: row.width + 30
        height: row.height + 30
        radius: 10
        color: "#1e1e2e"
        border.color: Theme.pink
        border.width: 2

        Row {
            id: row
            anchors.centerIn: parent
            spacing: 10
        }
    }
}

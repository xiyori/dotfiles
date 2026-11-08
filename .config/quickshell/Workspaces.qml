import QtQuick
import Quickshell

// Inactive workspaces as icons, followed by the active workspace icon and a
// minimap of its niri columns. Click a column to focus it, scroll to move
// focus between columns.
Pill {
    id: root

    required property var screen

    readonly property var workspaces: Niri.workspacesOf(screen.name)
    readonly property var activeWorkspace: workspaces.find(w => w.is_active) ?? null

    readonly property var icons: ({
        "Music": "\u{f0387}",
        "Carla": "\u{f067d}",
        "Telegram": "\ue217",
        "1": "\u{f0ca0}",
        "2": "\u{f0ca2}",
        "3": "\u{f0ca4}",
        "4": "\u{f0ca6}",
        "5": "\u{f0ca8}",
        "6": "\u{f0caa}",
        "7": "\u{f0cac}",
        "8": "\u{f0cae}",
        "9": "\u{f0cb0}",
        "10": "\u{f0fec}"
    })
    readonly property string defaultIcon: "\uf111"

    function iconOf(ws) {
        return icons[ws.name ?? ""] ?? icons[String(ws.idx)] ?? defaultIcon;
    }

    leftPadding: 8
    rightPadding: 8

    // Rebuild the icon delegates only when something visible changed
    property var iconModel: []
    property string iconSignature: ""

    function syncIcons() {
        const signature = JSON.stringify(workspaces.map(w => [w.id, w.idx, w.name, w.is_active]));
        if (signature === iconSignature)
            return;
        iconSignature = signature;
        iconModel = workspaces;
    }

    onWorkspacesChanged: syncIcons()
    Component.onCompleted: syncIcons()

    Row {
        Repeater {
            model: root.iconModel

            delegate: Item {
                id: button

                required property var modelData
                readonly property bool active: modelData.is_active

                width: icon.implicitWidth + 16
                height: Theme.pillHeight

                Text {
                    id: icon
                    x: 5
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.iconOf(button.modelData)
                    color: button.active ? Theme.pink : (area.containsMouse ? Theme.text : Theme.overlay1)
                    font.family: Theme.font
                    font.pixelSize: 15

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }

                MouseArea {
                    id: area
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: Niri.focusWorkspace(button.modelData)
                }
            }
        }

        Item {
            id: minimap

            readonly property var columns: root.activeWorkspace ? Niri.columnsOf(root.activeWorkspace.id) : []
            readonly property int cellWidth: 28
            readonly property int cellSpacing: 2
            readonly property int maxWidth: 420
            property int cursor: -1
            property real wheelAccum: 0

            visible: columns.length > 0
            width: Math.min(strip.width, maxWidth)
            height: Theme.pillHeight

            function focusedIndex() {
                return columns.findIndex(c => c.focused);
            }

            function step(direction) {
                const base = cursor >= 0 ? cursor : focusedIndex();
                const target = Math.max(0, Math.min(columns.length - 1, (base < 0 ? 0 : base) + direction));
                if (target === base)
                    return;
                cursor = target;
                Niri.focusWindow(columns[target].targetId);
            }

            // Keep the focused column inside the visible part of the strip
            function reveal() {
                if (flick.width <= 0)
                    return;
                let x = flick.contentX;
                const i = focusedIndex();
                if (i >= 0) {
                    const left = i * (cellWidth + cellSpacing);
                    const right = left + cellWidth;
                    if (left < x)
                        x = left;
                    else if (right > x + flick.width)
                        x = right - flick.width;
                }
                flick.contentX = Math.max(0, Math.min(strip.width - flick.width, x));
            }

            onColumnsChanged: {
                cursor = -1;
                Qt.callLater(reveal);
            }

            Flickable {
                id: flick
                anchors.fill: parent
                contentWidth: strip.width
                contentHeight: height
                interactive: false
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                onWidthChanged: Qt.callLater(minimap.reveal)

                Behavior on contentX {
                    NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                }

                Row {
                    id: strip
                    height: parent.height
                    spacing: minimap.cellSpacing
                    onWidthChanged: Qt.callLater(minimap.reveal)

                    Repeater {
                        model: minimap.columns

                        delegate: Rectangle {
                            id: cell

                            required property var modelData

                            readonly property int count: modelData.windows.length
                            readonly property bool focused: modelData.focused

                            width: minimap.cellWidth
                            height: 28
                            anchors.verticalCenter: parent.verticalCenter
                            radius: 5
                            color: focused ? Theme.surface3 : (area.containsMouse ? Theme.surface1 : "transparent")

                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }

                            // One icon per window; stacked columns shrink the icons
                            // and wrap into two rows beyond two windows.
                            Grid {
                                anchors.centerIn: parent
                                columns: cell.count > 2 ? 2 : 1
                                spacing: 0

                                Repeater {
                                    model: cell.modelData.windows.slice(0, 4)

                                    delegate: Text {
                                        required property var modelData

                                        horizontalAlignment: Text.AlignHCenter
                                        text: AppIcons.iconFor(modelData.appId, modelData.title)
                                        color: cell.focused ? Theme.pink : (area.containsMouse ? Theme.text : Theme.overlay1)
                                        font.family: Theme.font
                                        font.pixelSize: cell.count === 1 ? 15 : (cell.count === 2 ? 11 : 10)
                                    }
                                }
                            }

                            MouseArea {
                                id: area
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: Niri.focusWindow(cell.modelData.targetId)
                            }

                            Tip {
                                target: cell
                                markup: false
                                text: cell.modelData.windows.map(w => w.title || w.appId).join("\n")
                                shown: area.containsMouse
                            }
                        }
                    }
                }
            }

            WheelHandler {
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                onWheel: event => {
                    minimap.wheelAccum += event.angleDelta.y;
                    while (Math.abs(minimap.wheelAccum) >= 120) {
                        const dir = minimap.wheelAccum > 0 ? -1 : 1;
                        minimap.step(dir);
                        minimap.wheelAccum -= -dir * 120;
                    }
                }
            }
        }
    }
}

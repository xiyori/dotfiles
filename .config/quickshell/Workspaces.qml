import QtQuick
import Quickshell
import Quickshell.Io

// Non-empty inactive workspaces as icons; the active workspace is rendered
// as a minimap of its niri columns in its position. Click a column to focus
// it, scroll to move focus between columns.
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

    readonly property int namedCount: 3

    // Content is centered on the pill, so this height spans from the top of
    // the bar down to the same distance below the pill center.
    readonly property real hitHeight: 2 * Theme.pillTop + Theme.pillHeight

    function iconOf(ws) {
        // Unmarked workspaces are numbered after the named ones
        return icons[ws.name ?? ""] ?? icons[String(ws.idx - namedCount)] ?? defaultIcon;
    }

    property bool isScrolling: false

    Timer {
        id: scrollCooldown
        interval: 250 // Slightly longer than the 150ms flick animation
        onTriggered: root.isScrolling = false
    }

    leftPadding: 6
    rightPadding: 6

    // Rebuild the icon delegates only when something visible changed
    property var iconModelBefore: []
    property var iconModelAfter: []
    property string iconSignature: ""

    function syncIcons() {
        const signature = JSON.stringify(workspaces.map(w => [w.id, w.idx, w.name, w.is_active, w.active_window_id]));
        if (signature === iconSignature)
            return;
        iconSignature = signature;
        // Hide workspaces without windows; split around the active one
        const visible = workspaces.filter(w => w.active_window_id != null);
        const activeIdx = visible.findIndex(w => w.is_active);
        iconModelBefore = activeIdx >= 0 ? visible.slice(0, activeIdx) : visible;
        iconModelAfter = activeIdx >= 0 ? visible.slice(activeIdx + 1) : [];
    }

    onWorkspacesChanged: syncIcons()
    Component.onCompleted: syncIcons()

    Row {
        id: row

        readonly property int cellWidth: 28

        Repeater {
            model: root.iconModelBefore

            delegate: Item {
                id: button

                required property var modelData
                readonly property bool hovered: area.containsMouse && !root.isScrolling

                width: row.cellWidth
                height: root.hitHeight

                Text {
                    id: icon
                    anchors.centerIn: parent
                    text: root.iconOf(button.modelData)
                    color: button.hovered ? Theme.text : Theme.overlay1
                    font.family: Theme.font
                    font.pixelSize: 15

                    Behavior on color {
                        enabled: !root.isScrolling
                        ColorAnimation { duration: 150 }
                    }
                }

                MouseArea {
                    id: area
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: Niri.focusWorkspace(button.modelData)
                    onWheel: event => minimap.scroll(event.angleDelta.y)
                }

                Tip {
                    target: icon
                    markup: false
                    text: button.modelData.name ? button.modelData.name : "Workspace " + (button.modelData.idx - root.namedCount)
                    shown: button.hovered
                }
            }
        }

        Item {
            id: minimap

            readonly property var columns: root.activeWorkspace ? Niri.columnsOf(root.activeWorkspace.id) : []
            readonly property int cellSpacing: 0
            readonly property int maxWidth: 420
            property int cursor: -1
            property real wheelAccum: 0

            visible: columns.length > 0
            width: Math.min(strip.width, maxWidth)
            height: root.hitHeight

            Process {
                id: scrollRunner
                property string direction: "next"
                command: ["sh", "-c", "~/.scripts/workspace_swipe.py " + direction]
            }

            function focusedIndex() {
                return columns.findIndex(c => c.focused);
            }

            // function step(direction) {
            //     const base = cursor >= 0 ? cursor : focusedIndex();
            //     const target = Math.max(0, Math.min(columns.length - 1, (base < 0 ? 0 : base) + direction));
            //     if (target === base)
            //         return;
            //     cursor = target;
            //     Niri.focusWindow(columns[target].targetId);
            // }

            function scroll(delta) {
                root.isScrolling = true;
                scrollCooldown.restart();

                wheelAccum += delta;
                while (Math.abs(wheelAccum) >= 120) {
                    const dir = wheelAccum > 0 ? -1 : 1;
                    const dirText = dir < 0 ? "prev" : "next";
                    scrollRunner.direction = dirText;
                    scrollRunner.running = true;
                    wheelAccum -= -dir * 120;
                }
            }

            // Keep the focused column inside the visible part of the strip
            function reveal() {
                if (flick.width <= 0)
                    return;
                let x = flick.contentX;
                const i = focusedIndex();
                if (i >= 0) {
                    const left = i * (row.cellWidth + cellSpacing);
                    const right = left + row.cellWidth;
                    if (left < x)
                        x = left;
                    else if (right > x + flick.width)
                        x = right - flick.width;
                }
                flick.contentX = Math.max(0, Math.min(strip.width - flick.width, x));
            }

            onColumnsChanged: {
                cursor = -1;
                Qt.callLater(() => reveal());
            }

            Flickable {
                id: flick
                anchors.fill: parent
                contentWidth: strip.width
                contentHeight: height
                interactive: false
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                onWidthChanged: Qt.callLater(() => minimap.reveal())

                Behavior on contentX {
                    NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                }

                Row {
                    id: strip
                    height: parent.height
                    spacing: minimap.cellSpacing
                    onWidthChanged: Qt.callLater(() => minimap.reveal())

                    Repeater {
                        model: minimap.columns

                        delegate: Rectangle {
                            id: cell

                            required property var modelData

                            readonly property int count: modelData.windows.length
                            readonly property bool focused: modelData.focused
                            readonly property bool hovered: area.containsMouse && !root.isScrolling

                            width: row.cellWidth
                            height: Theme.pillHeight - 10
                            anchors.verticalCenter: parent.verticalCenter
                            radius: 5
                            color: focused ? Theme.surface3 : (cell.hovered ? Theme.surface1 : "transparent")

                            Behavior on color {
                                enabled: !root.isScrolling
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

                                        // horizontalAlignment: Text.AlignHLeft
                                        text: AppIcons.iconFor(modelData.appId, modelData.title)
                                        color: cell.focused ? Theme.pink : (cell.hovered ? Theme.text : Theme.overlay1)
                                        font.family: Theme.font
                                        font.pixelSize: cell.count === 1 ? 15 : 10

                                        Behavior on color {
                                            enabled: !root.isScrolling
                                            ColorAnimation { duration: 150 }
                                        }
                                    }
                                }
                            }

                            // Spans the full bar height, not just the cell background
                            MouseArea {
                                id: area
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width
                                height: root.hitHeight
                                hoverEnabled: true
                                onClicked: Niri.focusWindow(cell.modelData.targetId)
                                onWheel: event => minimap.scroll(event.angleDelta.y)
                            }

                            Tip {
                                target: cell
                                markup: false
                                text: cell.modelData.windows.map(w => w.title || w.appId).join("\n")
                                shown: cell.hovered
                            }
                        }
                    }
                }
            }
        }

        Repeater {
            model: root.iconModelAfter

            delegate: Item {
                id: button

                required property var modelData
                readonly property bool hovered: area.containsMouse && !root.isScrolling

                width: row.cellWidth
                height: root.hitHeight

                Text {
                    id: icon
                    anchors.centerIn: parent
                    text: root.iconOf(button.modelData)
                    color: button.hovered ? Theme.text : Theme.overlay1
                    font.family: Theme.font
                    font.pixelSize: 15

                    Behavior on color {
                        enabled: !root.isScrolling
                        ColorAnimation { duration: 150 }
                    }
                }

                MouseArea {
                    id: area
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: Niri.focusWorkspace(button.modelData)
                    onWheel: event => minimap.scroll(event.angleDelta.y)
                }

                Tip {
                    target: icon
                    markup: false
                    text: button.modelData.name ? button.modelData.name : "Workspace " + (button.modelData.idx - root.namedCount)
                    shown: button.hovered
                }
            }
        }

    }

    // Wheel over the margins and gaps falls through to the pill's full-height area
    onScrolled: direction => minimap.scroll(direction * 120)
}

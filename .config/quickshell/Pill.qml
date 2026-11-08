import QtQuick
import Quickshell

// Rounded bar module background. Adjacent pills merge into one block by
// zeroing the touching corners and the right margin.
Item {
    id: root

    default property alias content: holder.data
    property real leftPadding: 13
    property real rightPadding: 13
    property real minWidth: 0
    property real leftRadius: Theme.radius
    property real rightRadius: Theme.radius
    property real rightMargin: 10
    property string tooltip: ""
    property bool tooltipMarkup: true
    readonly property bool hovered: hover.hovered
    readonly property alias background: bg

    signal clicked(int button)
    signal scrolled(int direction)

    implicitWidth: bg.width + rightMargin
    implicitHeight: Theme.barHeight

    Rectangle {
        id: bg
        y: Theme.pillTop
        height: Theme.pillHeight
        width: Math.max(root.minWidth, holder.width) + root.leftPadding + root.rightPadding
        color: Theme.surface0
        topLeftRadius: root.leftRadius
        bottomLeftRadius: root.leftRadius
        topRightRadius: root.rightRadius
        bottomRightRadius: root.rightRadius

        MouseArea {
            id: mouseArea
            property real wheelAccum: 0

            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            onClicked: mouse => root.clicked(mouse.button)
            onWheel: event => {
                wheelAccum += event.angleDelta.y;
                while (Math.abs(wheelAccum) >= 120) {
                    const dir = wheelAccum > 0 ? 1 : -1;
                    root.scrolled(dir);
                    wheelAccum -= dir * 120;
                }
            }
        }

        Item {
            id: holder
            width: childrenRect.width
            height: childrenRect.height
            x: root.leftPadding + (Math.max(root.minWidth, width) - width) / 2
            y: (bg.height - height) / 2
        }
    }

    HoverHandler {
        id: hover
    }

    Tip {
        target: bg
        text: root.tooltip
        markup: root.tooltipMarkup
        shown: root.hovered
    }
}

import QtQuick
import Quickshell

// Hover tooltip shown below `target` after a short delay.
PopupWindow {
    id: root

    required property Item target
    property string text: ""
    property bool markup: true
    property bool shown: false
    property bool ready: false

    readonly property string html: {
        const escaped = markup ? text : text.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
        return escaped.replace(/\n/g, "<br>");
    }

    visible: shown && ready && text !== ""
    color: "transparent"
    implicitWidth: label.implicitWidth + 20
    implicitHeight: label.implicitHeight + 12

    anchor.item: target
    anchor.rect.x: target.width / 2
    anchor.rect.y: target.height + 4
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom
    anchor.adjustment: PopupAdjustment.Slide

    onShownChanged: {
        ready = false;
        if (shown)
            delay.restart();
    }

    Timer {
        id: delay
        interval: 400
        onTriggered: root.ready = true
    }

    Rectangle {
        anchors.fill: parent
        radius: 5
        color: Theme.surface0

        Text {
            id: label
            anchors.centerIn: parent
            text: root.html
            textFormat: Text.RichText
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: Theme.fontSize
        }
    }
}

import QtQuick

// Round glyph button used by the touch widgets.
Rectangle {
    id: root

    property string glyph: ""
    property real fontSize: 24
    property real size: 50

    signal clicked

    width: size
    height: size
    radius: size / 2
    color: area.pressed ? Theme.surface2 : (area.containsMouse ? Theme.surface1 : "#313244")

    Text {
        anchors.centerIn: parent
        text: root.glyph
        color: Theme.text
        font.family: Theme.font
        font.pixelSize: root.fontSize
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }
}

import QtQuick
import Quickshell

// Pill with a single label and optional shell commands for click and scroll.
Pill {
    id: root

    property string text: ""
    property color textColor: Theme.text
    property real fontSize: Theme.fontSize
    property bool richText: false
    property string clickCommand: ""
    property string rightClickCommand: ""
    property string middleClickCommand: ""
    property string scrollUpCommand: ""
    property string scrollDownCommand: ""

    function run(command) {
        if (command !== "")
            Quickshell.execDetached(["sh", "-c", command]);
    }

    onClicked: button => {
        if (button === Qt.LeftButton)
            run(clickCommand);
        else if (button === Qt.RightButton)
            run(rightClickCommand);
        else if (button === Qt.MiddleButton)
            run(middleClickCommand);
    }
    onScrolled: direction => run(direction > 0 ? scrollUpCommand : scrollDownCommand)

    Text {
        text: root.text
        color: root.textColor
        textFormat: root.richText ? Text.RichText : Text.PlainText
        font.family: Theme.font
        font.pixelSize: root.fontSize
    }
}

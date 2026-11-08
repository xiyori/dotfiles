import QtQuick
import QtQuick.Controls.Basic

// Slider for the touch widgets; `committed` fires while dragging, throttled.
Slider {
    id: root

    property alias interval: throttle.interval
    property var pending: null

    signal committed(int value)

    implicitWidth: 172
    implicitHeight: 30
    stepSize: 1
    snapMode: Slider.SnapAlways

    function flush() {
        if (pending === null)
            return;
        const v = pending;
        pending = null;
        committed(v);
    }

    onMoved: {
        pending = Math.round(value);
        if (!throttle.running) {
            flush();
            throttle.start();
        }
    }

    Timer {
        id: throttle
        interval: 120
        repeat: true
        onTriggered: {
            if (root.pending === null)
                stop();
            else
                root.flush();
        }
    }

    background: Rectangle {
        x: root.leftPadding
        y: root.topPadding + root.availableHeight / 2 - height / 2
        width: root.availableWidth
        height: 6
        radius: 3
        color: Theme.surface1

        Rectangle {
            width: root.visualPosition * parent.width
            height: parent.height
            radius: 3
            color: Theme.pink
        }
    }

    handle: Rectangle {
        x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
        y: root.topPadding + root.availableHeight / 2 - height / 2
        width: 20
        height: 20
        radius: 10
        color: Theme.pink
    }
}

import QtQuick
import Quickshell
import Quickshell.Io

// Media and volume controls for tablet mode (formerly the eww sound-window).
PanelWindowBase {
    id: root

    property real volume: 65
    property bool muted: false
    property bool playing: false
    property bool opening: false

    anchors {
        top: true
        right: true
    }
    margins.right: 20 - pad

    function toggle() {
        if (shown) {
            shown = false;
        } else {
            opening = true;
            refresh();
        }
    }

    function refresh() {
        if (!reader.running)
            reader.running = true;
    }

    function act(command) {
        if (runner.running) {
            Quickshell.execDetached(["sh", "-c", command]);
        } else {
            runner.command = ["sh", "-c", command];
            runner.running = true;
        }
    }

    Process {
        id: reader
        command: ["sh", "-c", "echo \"p=$(cat /tmp/player_status) v=$(cat /tmp/loudness) m=$(cat /tmp/muted)\""]
        stdout: StdioCollector {
            onStreamFinished: {
                const field = key => text.match(new RegExp(key + "=(\\S*)"))?.[1] ?? "";
                root.playing = field("p") === "2";
                root.muted = field("m") === "1";
                const v = parseFloat(field("v"));
                if (!isNaN(v) && !slider.pressed)
                    root.volume = v;
                if (root.opening) {
                    root.opening = false;
                    root.shown = true;
                }
            }
        }
    }

    Process {
        id: runner
        onExited: root.refresh()
    }

    Timer {
        interval: 5000
        running: root.shown
        repeat: true
        onTriggered: root.refresh()
    }

    Connections {
        target: Refresh
        function onRequested(name) {
            if (name === "sound" && root.shown)
                root.refresh();
        }
    }

    PanelButton {
        glyph: "\u{f04ae}"
        size: 40
        fontSize: 20
        anchors.verticalCenter: parent.verticalCenter
        onClicked: root.act("~/.scripts/audio/control.sh previous")
    }

    PanelButton {
        glyph: root.playing ? "\u{f040a}" : "\u{f03e4}"
        onClicked: root.act("~/.scripts/audio/control.sh play-pause")
    }

    PanelButton {
        glyph: "\u{f04ad}"
        size: 40
        fontSize: 20
        anchors.verticalCenter: parent.verticalCenter
        onClicked: root.act("~/.scripts/audio/control.sh next")
    }

    PanelSlider {
        id: slider
        anchors.verticalCenter: parent.verticalCenter
        from: 40
        to: 84
        value: root.volume
        onCommitted: v => Quickshell.execDetached(["sh", "-c", "~/.scripts/audio/control.sh " + v])
    }

    PanelButton {
        glyph: root.muted ? "\u{f057e}" : "\u{f0581}"
        onClicked: root.act("~/.scripts/audio/control.sh mute quiet")
    }

    PanelButton {
        glyph: "\u{f1120}"
        onClicked: root.act("~/.scripts/audio/auto_gain.sh default quiet")
    }

    PanelButton {
        glyph: "\uebcb"
        fontSize: 20
        onClicked: root.act("~/.scripts/audio/next_active_sink.sh")
    }
}

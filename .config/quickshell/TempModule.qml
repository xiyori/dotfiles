import QtQuick
import Quickshell

// Temperature readout with a level icon and a critical colour.
TextPill {
    id: root

    property real temp: -1
    property real critical: 75
    property var levelIcons: []

    readonly property string icon: {
        const n = levelIcons.length;
        const idx = Math.max(0, Math.min(n - 1, Math.floor(temp / (critical / n))));
        return levelIcons[idx] ?? "";
    }
    readonly property string label: icon + " " + Math.round(temp) + "°C"

    visible: temp >= 0
    richText: true
    text: temp >= critical ? "<span style='color:#F38BA8'>" + label + "</span>" : label
    clickCommand: "alacritty -e nvtop"
}

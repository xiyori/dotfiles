pragma Singleton

import QtQuick
import Quickshell

// Catppuccin Mocha palette and bar metrics (ported from the old waybar style.css)
Singleton {
    readonly property color base: "#1e1e2e"
    readonly property color text: "#cdd6f4"
    readonly property color subtext1: "#bac2de"
    readonly property color surface0: "#e61e1e2e" // rgba(30, 30, 46, 0.9)
    readonly property color surface1: "#45475a"
    readonly property color surface2: "#585b70"
    readonly property color surface3: "#394161"
    readonly property color overlay0: "#6c7086"
    readonly property color overlay1: "#7f849c"
    readonly property color lavender: "#b4befe"
    readonly property color sky: "#89dceb"
    readonly property color green: "#a6e3a1"
    readonly property color peach: "#fab387"
    readonly property color maroon: "#eba0ac"
    readonly property color red: "#f38ba8"
    readonly property color mauve: "#cba6f7"
    readonly property color pink: "#f5c2e7"
    readonly property color flamingo: "#f2cdcd"
    readonly property color rosewater: "#f5e0dc"

    readonly property string font: "NotoMono Nerd Font"
    readonly property int fontSize: 13

    readonly property int barHeight: 50
    readonly property int pillTop: 10
    readonly property int pillHeight: 38
    readonly property int radius: 8
}

import QtQuick
import Quickshell

ShellRoot {
    id: root

    // Toggle this from external scripts/signals as needed
    property bool clockVisible: true

    // Global widget config
    property int clockSize: 280

    PopupWindow {
        id: clockWindow
        visible: true

        // Keep window alive; animate content opacity for appear/disappear
        implicitWidth: root.clockSize
        implicitHeight: root.clockSize

        // NOTE:
        // Configure anchor/window placement to your layout if needed.
        // This minimal example keeps the popup generic.

        Item {
            id: content
            width: root.clockSize
            height: root.clockSize

            opacity: root.clockVisible ? 1.0 : 0.0

            Behavior on opacity {
                NumberAnimation {
                    duration: 220
                    easing.type: Easing.InOutQuad
                }
            }

            AnalogClock {
                id: analogClock
                anchors.fill: parent

                // Example styling (customize freely)
                faceColor: "#00000000"
                borderColor: "#cdd6f4"
                borderWidth: 3

                markingColor: "#cdd6f4"
                minuteMarkLength: clockSize * 0.045
                hourMarkLength: clockSize * 0.09
                markingWidth: Math.max(1, clockSize * 0.008)

                showNumerals: true
                numeralStyle: "roman"      // "arabic" or "roman"
                rotateNumerals: false
                numeralFontSize: Math.max(11, Math.round(clockSize * 0.085))
                numeralFontFamily: "JetBrainsMono Nerd Font"
                numeralFontWeight: Font.DemiBold
                numeralItalic: false
                numeralColor: "#cdd6f4"

                hourHandColor: "#f5e0dc"
                minuteHandColor: "#89dceb"
                secondHandColor: "#f38ba8"

                hourHandLengthFactor: 0.50
                minuteHandLengthFactor: 0.72
                secondHandLengthFactor: 0.84

                hourHandWidth: Math.max(3, clockSize * 0.024)
                minuteHandWidth: Math.max(2, clockSize * 0.016)
                secondHandWidth: Math.max(1, clockSize * 0.008)

                centerDotColor: "#cdd6f4"
                centerDotRadius: Math.max(2, clockSize * 0.018)

                smoothSeconds: true
            }
        }
    }
}

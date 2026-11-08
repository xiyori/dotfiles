//@ pragma IconTheme Papirus-Dark
import QtQuick
import Quickshell
import Quickshell.Io

ShellRoot {
    Variants {
        model: Quickshell.screens

        Bar {
            required property var modelData

            screen: modelData
        }
    }

    SoundPanel {
        id: soundPanel
    }

    BrightnessPanel {
        id: brightnessPanel
    }

    // `~/.scripts/bar_refresh <module>` re-runs a bar module's script
    IpcHandler {
        target: "bar"

        function refresh(module: string): void {
            Refresh.requested(module);
        }
    }

    // Tablet-mode widgets, toggled by ~/.scripts/audio/control.sh and ~/.scripts/brightness.sh
    IpcHandler {
        target: "widgets"

        function toggleSound(): void {
            soundPanel.toggle();
        }

        function toggleBrightness(): void {
            brightnessPanel.toggle();
        }
    }
}

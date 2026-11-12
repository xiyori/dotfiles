import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

PanelWindow {
    id: bar

    anchors {
        top: true
        left: true
        right: true
    }
    margins {
        left: 10
        right: 10
    }
    implicitHeight: Theme.barHeight
    color: "transparent"

    Row {
        id: leftRow
        anchors.left: parent.left

        TextPill {
            text: "\u{f08c7}"
            textColor: Theme.pink
            fontSize: 24
            tooltip: "Launcher"
            leftPadding: 10
            rightPadding: 10
            clickCommand: "pkill rofi || ~/GitHub/rofi/build/rofi -show drun"
        }

        TextPill {
            text: "\uf4bc " + SysStats.cpu + "%"
            textColor: Theme.lavender
            minWidth: 40
            rightRadius: 0
            rightMargin: 0
            rightPadding: 5
            tooltip: SysStats.cpuUsageByCore.length > 0 ? (
                SysStats.cpuUsageByCore.map((u, i) => `Core ${i}: ${u}%`).join("\n")
            ) : "CPU: " + SysStats.cpu + "%"
            clickCommand: "alacritty -e btop"
        }

        TextPill {
            text: "\uf2db " + SysStats.memory + "%"
            textColor: Theme.lavender
            minWidth: 40
            leftRadius: 0
            rightRadius: 0
            rightMargin: 0
            leftPadding: 5
            rightPadding: 5
            tooltip: SysStats.memoryTotalGB > 0 ? (
                "RAM: " + SysStats.memoryUsedGB.toFixed(1) + "GB / " + SysStats.memoryTotalGB.toFixed(1) + "GB"
            ) : ""
            clickCommand: "alacritty -e btop"
        }

        TempModule {
            temp: SysStats.cpuTemp
            critical: 75
            levelIcons: ["\uf2cb", "\uf2c9", "\uf2c7"]
            minWidth: 48
            leftRadius: 0
            rightRadius: 0
            rightMargin: 0
            leftPadding: 5
            rightPadding: 5
            tooltip: (SysStats.cpuFanSpeed >= 0 ? "CPU Fan: " + SysStats.cpuFanSpeed + " RPM" : "") +
                (SysStats.pumpSpeed >= 0 ? "\nPump: " + SysStats.pumpSpeed + " RPM" : "")
        }

        // TempModule {
        //     temp: SysStats.gpuTemp
        //     critical: 70
        //     levelIcons: ["\uefa7"]
        //     minWidth: 48
        //     leftRadius: 0
        //     rightRadius: 0
        //     rightMargin: 0
        //     leftPadding: 5
        //     rightPadding: 5
        //     tooltip: (SysStats.gpuFanSpeed >= 0 ? "GPU Fan: " + SysStats.gpuFanSpeed + " RPM" : "") +
        //         (SysStats.intakeFanSpeed >= 0 ? "\nIntake Fan: " + SysStats.intakeFanSpeed + " RPM" : "")
        // }

        TextPill {
            text: "\uf0a0 " + Disk.diskText
            textColor: Theme.flamingo
            minWidth: 48
            leftRadius: 0
            rightRadius: 0
            rightMargin: 0
            leftPadding: 5
            rightPadding: 5
            tooltip: Disk.diskTooltip
        }

        TextPill {
            text: Battery.getStatusIcon() + " " + Battery.capacity + "%"
            textColor: Battery.isCharging ? Theme.green : Battery.flashRed ? Theme.base : Battery.isLow ? Theme.red : Theme.text
            backgroundColor: Battery.flashRed ? Theme.red : Theme.surface0
            minWidth: 40
            leftRadius: 0
            rightRadius: 0
            rightMargin: 0
            leftPadding: 5
            rightPadding: 5
            tooltip: Battery.getTooltip()
        }

        TextPill {
            text: Backlight.getIcon(Backlight.percent) + " " + Backlight.percent + "%"
            textColor: Theme.mauve
            minWidth: 40
            leftRadius: 0
            leftPadding: 5
            tooltip: Backlight.getTooltip()
            clickCommand: "~/.scripts/brightness.sh custom_action"
            rightClickCommand: "~/.scripts/brightness.sh down"
            scrollUpCommand: "~/.scripts/brightness.sh up"
            scrollDownCommand: "~/.scripts/brightness.sh down"
        }

        ScriptModule {
            exec: "~/.scripts/backup_status.sh"
            interval: 60
            textColor: Theme.green
            rightPadding: 11
        }

        // ScriptModule {
        //     exec: "~/.scripts/fancontrol_status.sh"
        //     interval: 60
        //     textColor: Theme.red
        //     rightPadding: 11
        // }

        ScriptModule {
            exec: "cat /tmp/custom_monitor_waybar"
            signalName: "monitor"
            textColor: Theme.sky
            rightPadding: 11
            clickCommand: "~/.scripts/mirror.sh"
            rightClickCommand: "~/.scripts/external.sh"
        }

        Workspaces {
            screen: bar.screen
        }
    }

    Pill {
        id: windowTitle

        readonly property string title: Niri.focusedWindow?.title ?? ""

        anchors.horizontalCenter: parent.horizontalCenter
        visible: title !== ""
        rightMargin: 0

        // Stay clear of the side modules while keeping the title centred
        Text {
            width: Math.min(implicitWidth, Math.max(0, bar.width - 2 * Math.max(leftRow.width, rightRow.width) - 80))
            text: windowTitle.title
            elide: Text.ElideRight
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: Theme.fontSize
        }
    }

    Row {
        id: rightRow
        anchors.right: parent.right

        Pill {
            id: tray

            visible: SystemTray.items.values.length > 0
            rightRadius: 0
            rightMargin: 0
            rightPadding: 5

            // Tray items handle their own clicks
            fullHeightInteraction: false

            Row {
                spacing: 9

                Repeater {
                    model: SystemTray.items

                    delegate: Item {
                        id: trayItem

                        required property var modelData
                        readonly property bool hovered: trayHover.hovered

                        width: 18
                        height: 18
                        anchors.verticalCenter: parent.verticalCenter

                        Image {
                            anchors.fill: parent
                            source: trayItem.modelData.icon
                            sourceSize: Qt.size(28, 28)
                            smooth: true
                        }

                        HoverHandler {
                            id: trayHover
                        }

                        Tip {
                            target: trayItem
                            text: {
                                const t = trayItem.modelData.tooltipTitle ?? "";
                                const d = trayItem.modelData.tooltipDescription ?? "";
                                if (t !== "" && d !== "")
                                    return t + "\n" + d;
                                return t !== "" ? t : d;
                            }
                            markup: false
                            shown: trayItem.hovered
                        }

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                            onClicked: mouse => {
                                const item = trayItem.modelData;
                                const showMenu = () => {
                                    const p = trayItem.mapToItem(null, 0, trayItem.height);
                                    item.display(bar, p.x, p.y);
                                };
                                if (mouse.button === Qt.RightButton && item.hasMenu)
                                    showMenu();
                                else if (mouse.button === Qt.MiddleButton)
                                    item.secondaryActivate();
                                else if (item.onlyMenu && item.hasMenu)
                                    showMenu();
                                else
                                    item.activate();
                            }
                        }
                    }
                }
            }
        }

        NotificationsModule {}

        ScriptModule {
            exec: "~/.scripts/updates"
            interval: 7320
            signalName: "updates"
            textColor: Theme.sky
            clickCommand: "~/.scripts/updates update"
        }

        ScriptModule {
            exec: "~/.scripts/audio/auto_gain_status.sh"
            signalName: "autogain"
            textColor: Theme.red
            plainTooltip: true
            clickCommand: "~/.scripts/audio/auto_gain.sh"
            rightClickCommand: "~/.scripts/audio/auto_gain.sh reset"
            scrollUpCommand: "~/.scripts/audio/manual_gain.sh up"
            scrollDownCommand: "~/.scripts/audio/manual_gain.sh down"
        }

        ScriptModule {
            exec: "~/.scripts/audio/profile_status.sh"
            signalName: "soundprofile"
            textColor: Theme.subtext1
            plainTooltip: true
            clickCommand: "~/.scripts/audio/next_profile.sh"
            rightClickCommand: "~/.scripts/audio/theater.sh"
        }

        ScriptModule {
            exec: "~/.scripts/audio/custom_sound.sh"
            signalName: "sound"
            textColor: Theme.mauve
            plainTooltip: true
            minWidth: 48
            rightRadius: 0
            rightMargin: 0
            rightPadding: 5
            // play-pause or open the widget depending on tablet mode
            clickCommand: "~/.scripts/audio/control.sh custom_action"
            rightClickCommand: "~/.scripts/audio/next_active_sink.sh"
            scrollUpCommand: "~/.scripts/audio/control.sh up quiet"
            scrollDownCommand: "~/.scripts/audio/control.sh down quiet"
        }

        TextPill {
            text: Niri.layoutShort
            textColor: Theme.peach
            minWidth: 25
            leftRadius: 0
            rightRadius: 0
            rightMargin: 0
            leftPadding: 5
            rightPadding: 5
            clickCommand: "niri msg action switch-layout next"
        }

        ScriptModule {
            exec: "~/.scripts/wttr"
            interval: 7320
            leftRadius: 0
            rightRadius: 0
            rightMargin: 0
            leftPadding: 5
            rightPadding: 5
        }

        ClockModule {}

        TextPill {
            text: "\u23fb"
            textColor: Theme.pink
            fontSize: 16
            tooltip: "Power"
            leftPadding: 12
            rightPadding: 12
            rightMargin: 0
            clickCommand: "~/.scripts/logout.sh"
            rightClickCommand: "~/.scripts/wallpaper.sh next"
        }
    }
}

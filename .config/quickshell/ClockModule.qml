import QtQuick
import Quickshell

// Date and time with a calendar tooltip; left click toggles the long format.
TextPill {
    id: root

    readonly property var locale: Qt.locale("en_US")
    property bool alternate: false

    readonly property string calendar: {
        const now = clock.date;
        const year = now.getFullYear();
        const month = now.getMonth();
        const today = now.getDate();
        const pad = n => String(n).padStart(2, " ");
        const weekdays = [1, 2, 3, 4, 5, 6, 7].map(d => locale.dayName(d, Locale.ShortFormat).slice(0, 2)).join(" ");
        const offset = (new Date(year, month, 1).getDay() + 6) % 7;
        const days = new Date(year, month + 1, 0).getDate();

        const cells = Array(offset).fill("  ");
        for (let d = 1; d <= days; d++) {
            const label = pad(d);
            cells.push(d === today
                ? "<span style='color:" + Theme.green + "'><b><u>" + label + "</u></b></span>"
                : "<span style='color:" + Theme.text + "'><b>" + label + "</b></span>");
        }
        const rows = [];
        for (let i = 0; i < cells.length; i += 7)
            rows.push(cells.slice(i, i + 7).join(" "));

        const date = pad(today).trim().padStart(2, "0") + "." + pad(month + 1).trim().padStart(2, "0") + "." + year;
        return "<pre style='font-size:" + (Theme.fontSize - 2) + "px'>"
            + "<div style='text-align: right;'>"
            + "<span style='color:" + Theme.flamingo + "'><b>" + date + "</b></span>"
            + "</div>"
            + "<span style='color:" + Theme.maroon + "'><b>" + weekdays + "</b></span>\n"
            + rows.join("\n") + "</pre>";
    }

    text: alternate
        ? locale.toString(clock.date, "dddd MMMM dd yyyy | HH:mm:ss")
        : locale.toString(clock.date, "dd") + " <span style='font-size:" + (Theme.fontSize - 2) + "px'>"
            + locale.toString(clock.date, "ddd") + "</span> " + locale.toString(clock.date, "HH:mm")
    richText: true
    textColor: Theme.rosewater
    tooltip: calendar
    leftRadius: 0
    leftPadding: 5
    rightClickCommand: "alacritty --class \"tty-flex,tty-flex\" -e calcurse"

    onClicked: button => {
        if (button === Qt.LeftButton)
            alternate = !alternate;
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}

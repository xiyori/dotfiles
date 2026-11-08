pragma Singleton

import QtQuick
import Quickshell

// App icons for the niri columns minimap. The rules use the waybar
// `window-rewrite` syntax: `class<regex>` matches the app id, `title<regex>`
// matches the window title, both are full, case-insensitive matches.
// Priority: class + title, then title only, then class only; ties go to the
// first rule listed.
Singleton {
    readonly property string defaultIcon: "\uf111"

    readonly property var rewrite: ({
        "class<kitty> title<rmpc>": "\u{f0387}",
        "class<carla>": "\u{f067d}",
        "title<.*youtube.*>": "\uf16a",
        "class<librewolf>": "\uf269",
        "class<firefox>": "\u{f0239}",
        "class<chromium>": "\uf268",
        "class<.*Thunderbird>": "\uf370",
        "class<.*telegram.*>": "\ue217",
        "class<.*VSCode>": "\u{f0a1e}",
        "class<thunar>": "\uf07c",
        "class<Alacritty>": "\uf489",
        "class<gimp>": "\uf1fc",
        "class<qimgv>": "\uf03e",
        "class<.*roomeqwizard.*>": "\u{f0c50}",
        "class<Tor Browser>": "\uf371",
        "class<Vncviewer>": "\u{f011b}",
        "class<.*joplin.*>": "\uf05f",
        "class<mpv>": "\uf36e",
        "class<libreoffice-writer>": "\u{f0219}",
        "class<libreoffice-calc>": "\uf0ce",
        "class<Throne>": "\u{f0582}"
    })

    readonly property var rules: {
        const parsed = [];
        for (const key of Object.keys(rewrite)) {
            const m = key.match(/^\s*(?:class<(.*?)>)?\s*(?:title<(.*?)>)?\s*$/);
            if (!m || (m[1] === undefined && m[2] === undefined))
                continue;
            const compile = p => p === undefined ? null : new RegExp("^(?:" + p + ")$", "i");
            parsed.push({
                cls: compile(m[1]),
                title: compile(m[2]),
                priority: (m[1] !== undefined ? 1 : 0) + (m[2] !== undefined ? 2 : 0),
                icon: rewrite[key]
            });
        }
        // title only (2) ranks above class only (1), both together (3) above all
        return parsed.map((r, i) => ({ r, i }))
            .sort((a, b) => b.r.priority - a.r.priority || a.i - b.i)
            .map(x => x.r);
    }

    function iconFor(appId, title) {
        for (const r of rules) {
            if (r.cls && !r.cls.test(appId || ""))
                continue;
            if (r.title && !r.title.test(title || ""))
                continue;
            return r.icon;
        }
        return defaultIcon;
    }
}

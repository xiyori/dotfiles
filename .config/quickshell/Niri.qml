pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Live niri state (workspaces, windows, keyboard layout) from `niri msg event-stream`.
Singleton {
    id: root

    property var workspaceList: []
    property var windowList: []
    property var layoutNames: []
    property int layoutIndex: 0

    readonly property var focusedWindow: windowList.find(w => w.is_focused) ?? null

    readonly property var layoutAbbreviations: ({
        "English (US)": "en",
        "Russian": "ru"
    })
    readonly property string layoutShort: {
        const name = layoutNames[layoutIndex] ?? "";
        return layoutAbbreviations[name] ?? name.slice(0, 2).toLowerCase();
    }

    function workspacesOf(output) {
        return workspaceList.filter(w => w.output === output).sort((a, b) => a.idx - b.idx);
    }

    function focusedOutput() {
        return workspaceList.find(w => w.is_focused)?.output ?? "";
    }

    // Scrolling-layout columns of a workspace, left to right. Floating windows
    // have no column and are skipped.
    function columnsOf(workspaceId) {
        const ws = workspaceList.find(w => w.id === workspaceId);
        if (!ws)
            return [];
        const byColumn = {};
        for (const w of windowList) {
            const pos = w.layout?.pos_in_scrolling_layout;
            if (w.workspace_id !== workspaceId || w.is_floating || !pos)
                continue;
            (byColumn[pos[0]] = byColumn[pos[0]] ?? []).push(w);
        }
        const stamp = w => w.focus_timestamp.secs * 1e9 + w.focus_timestamp.nanos;
        return Object.keys(byColumn).map(Number).sort((a, b) => a - b).map(index => {
            const windows = byColumn[index].sort((a, b) => a.layout.pos_in_scrolling_layout[1] - b.layout.pos_in_scrolling_layout[1]);
            const focused = windows.find(w => w.id === ws.active_window_id);
            const target = focused ?? windows.reduce((a, b) => stamp(b) > stamp(a) ? b : a);
            return {
                index: index,
                focused: focused !== undefined,
                targetId: target.id,
                windows: windows.map(w => ({ id: w.id, appId: w.app_id ?? "", title: w.title ?? "" }))
            };
        });
    }

    function action(args) {
        Quickshell.execDetached(["niri", "msg", "action"].concat(args));
    }

    function focusWindow(id) {
        action(["focus-window", "--id", String(id)]);
    }

    function focusWorkspace(ws) {
        // Workspace indexes are relative to the focused output
        const cmd = ["niri msg action focus-workspace " + (ws.name ? "'" + ws.name.replace(/'/g, "'\\''") + "'" : ws.idx)];
        if (ws.output !== focusedOutput())
            cmd.unshift("niri msg action focus-monitor '" + ws.output + "'");
        Quickshell.execDetached(["sh", "-c", cmd.join(" && ")]);
    }

    function patchWorkspaces(fn) {
        workspaceList = workspaceList.map(w => fn(Object.assign({}, w)));
    }

    function patchWindows(fn) {
        windowList = windowList.map(w => fn(Object.assign({}, w)));
    }

    function handle(line) {
        let event;
        try {
            event = JSON.parse(line);
        } catch (e) {
            return;
        }
        const kind = Object.keys(event)[0];
        const d = event[kind];
        switch (kind) {
        case "WorkspacesChanged":
            workspaceList = d.workspaces;
            break;
        case "WorkspaceActivated": {
            const target = workspaceList.find(w => w.id === d.id);
            if (!target)
                break;
            patchWorkspaces(w => {
                if (w.output === target.output)
                    w.is_active = w.id === d.id;
                if (d.focused)
                    w.is_focused = w.id === d.id;
                return w;
            });
            break;
        }
        case "WorkspaceActiveWindowChanged":
            patchWorkspaces(w => {
                if (w.id === d.workspace_id)
                    w.active_window_id = d.active_window_id;
                return w;
            });
            break;
        case "WorkspaceUrgencyChanged":
            patchWorkspaces(w => {
                if (w.id === d.id)
                    w.is_urgent = d.urgent;
                return w;
            });
            break;
        case "WindowsChanged":
            windowList = d.windows;
            break;
        case "WindowOpenedOrChanged": {
            const rest = windowList.filter(w => w.id !== d.window.id);
            if (d.window.is_focused)
                rest.forEach(w => w.is_focused = false);
            windowList = rest.concat([d.window]);
            break;
        }
        case "WindowClosed":
            windowList = windowList.filter(w => w.id !== d.id);
            break;
        case "WindowFocusChanged":
            patchWindows(w => {
                w.is_focused = w.id === d.id;
                return w;
            });
            break;
        case "WindowFocusTimestampChanged":
            patchWindows(w => {
                if (w.id === d.id)
                    w.focus_timestamp = d.focus_timestamp;
                return w;
            });
            break;
        case "WindowUrgencyChanged":
            patchWindows(w => {
                if (w.id === d.id)
                    w.is_urgent = d.urgent;
                return w;
            });
            break;
        case "WindowLayoutsChanged": {
            const layouts = {};
            for (const [id, layout] of d.changes)
                layouts[id] = layout;
            patchWindows(w => {
                if (layouts[w.id] !== undefined)
                    w.layout = layouts[w.id];
                return w;
            });
            break;
        }
        case "KeyboardLayoutsChanged":
            layoutNames = d.keyboard_layouts.names;
            layoutIndex = d.keyboard_layouts.current_idx;
            break;
        case "KeyboardLayoutSwitched":
            layoutIndex = d.idx;
            break;
        }
    }

    Process {
        id: events
        running: true
        command: ["niri", "msg", "--json", "event-stream"]
        stdout: SplitParser {
            onRead: data => root.handle(data)
        }
        onExited: restart.start()
    }

    Timer {
        id: restart
        interval: 1000
        onTriggered: events.running = true
    }
}

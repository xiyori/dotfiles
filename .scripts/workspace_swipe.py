#!/usr/bin/env python3
import json
import os
import socket
import sys


class NiriIPC:
    def __init__(self):
        sock_path = os.environ.get("NIRI_SOCKET")
        if not sock_path:
            sys.exit("Error: NIRI_SOCKET environment variable not set.")
        self.sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self.sock.connect(sock_path)
        self.reader = self.sock.makefile("r", encoding="utf-8")

    def call(self, payload):
        self.sock.sendall((json.dumps(payload) + "\n").encode("utf-8"))
        line = self.reader.readline()
        if not line:
            raise RuntimeError("Niri socket closed unexpectedly")
        res = json.loads(line)
        if "Err" in res:
            raise RuntimeError(f"Niri IPC error: {res['Err']}")
        return res["Ok"]

    def action(self, name, **kwargs):
        return self.call({"Action": {name: kwargs}})

    def close(self):
        self.reader.close()
        self.sock.close()


def main():
    if len(sys.argv) < 2 or sys.argv[1] not in ("next", "prev"):
        sys.exit("Usage: scroll-columns-or-workspaces.py [next|prev]")

    direction = sys.argv[1]
    ipc = NiriIPC()

    try:
        # 1. Fetch focused window first
        focused = ipc.call("FocusedWindow").get("FocusedWindow")

        # Fast exit if workspace is empty
        if not focused:
            act = "FocusWorkspaceUp" if direction == "prev" else "FocusWorkspaceDown"
            ipc.action(act)
            return

        pos = focused.get("layout", {}).get("pos_in_scrolling_layout")
        ws_id = focused.get("workspace_id")

        # Fast exit if focused window is floating
        if not pos:
            ipc.action("SwitchFocusBetweenFloatingAndTiling")
            return

        cur_col = pos[0]

        # Fast path for "prev": move left without querying all windows/workspaces
        if direction == "prev" and cur_col > 1:
            ipc.action("FocusColumnLeft")
            return

        # 2. Fetch all windows only when at a column edge
        windows = ipc.call("Windows").get("Windows", [])

        if direction == "next":
            max_col = max(
                (
                    w["layout"]["pos_in_scrolling_layout"][0]
                    for w in windows
                    if w.get("workspace_id") == ws_id
                    and w.get("layout", {}).get("pos_in_scrolling_layout")
                ),
                default=0,
            )
            if cur_col < max_col:
                ipc.action("FocusColumnRight")
                return

        # 3. Fetch workspaces only when jumping across workspaces
        workspaces = ipc.call("Workspaces").get("Workspaces", [])
        cur_ws = next((w for w in workspaces if w.get("id") == ws_id), None)
        if not cur_ws:
            return

        out = cur_ws.get("output")
        cur_idx = cur_ws.get("idx")

        mon_ws = sorted(
            (w for w in workspaces if w.get("output") == out),
            key=lambda w: w.get("idx", 0),
        )

        max_named = max(
            (w["idx"] for w in mon_ws if w.get("name") is not None),
            default=0,
        )
        first_unnamed = max_named + 1

        # O(1) set lookup for occupied workspaces
        occupied = {w.get("workspace_id") for w in windows}

        valid_ws = [
            w
            for w in mon_ws
            if w.get("id") in occupied
            or (w.get("idx") == first_unnamed and w.get("name") is None)
        ]

        if direction == "prev":
            candidates = [w["idx"] for w in valid_ws if w["idx"] < cur_idx]
            target_idx = candidates[-1] if candidates else None
        else:
            candidates = [w["idx"] for w in valid_ws if w["idx"] > cur_idx]
            target_idx = candidates[0] if candidates else None

        if target_idx is not None:
            ipc.action("FocusWorkspace", reference={"Index": target_idx})

    finally:
        ipc.close()


if __name__ == "__main__":
    main()

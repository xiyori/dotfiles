-- See https://wiki.hyprland.org/Configuring/Keywords/ for more

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("~/.scripts/suspend.sh"), { locked = true })

local terminal = "alacritty"
local fileManager = "thunar"
local menu = "pkill rofi || rofi -show drun"
local mainMod = "SUPER"

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("librewolf"))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("chromium"))
hl.bind(mainMod .. " + M", hl.dsp.focus({ workspace = "name:Telegram" }))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("pgrep Telegram || Telegram"))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("thunderbird"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprctl kill"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("pkill rofi || rofi -modi emoji -show emoji"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu), { release = true })
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + J", hl.dsp.exec_cmd("joplin-desktop"))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("~/.scripts/audio/next_active_sink.sh"))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd("~/.scripts/audio/next_profile.sh"))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("~/.scripts/audio/auto_gain.sh"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("~/.scripts/logout.sh"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("pkill hyprpicker || ~/.scripts/color-picker"))

hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd("~/.scripts/lock"))

hl.bind("Print", hl.dsp.exec_cmd("pkill slurp || ~/.scripts/screenshot"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("~/.scripts/screenshot_full"))

hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("qalculate-gtk"))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("code"))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("~/.scripts/clock.sh"))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd("~/.scripts/donut.sh"))
hl.bind(mainMod .. " + A", hl.dsp.focus({ workspace = "name:Music" }))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("pgrep rmpc || kitty rmpc"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("~/.scripts/cava.sh"))
hl.bind(mainMod .. " + S", hl.dsp.focus({ workspace = "name:Carla" }))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("pgrep carla || ~/.scripts/audio/startup.sh"))

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + left", hl.dsp.window.bring_to_top())
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + right", hl.dsp.window.bring_to_top())
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))

hl.bind(mainMod .. " + comma", hl.dsp.layout("splitratio -0.1"), { repeating = true })
hl.bind(mainMod .. " + period", hl.dsp.layout("splitratio +0.1"), { repeating = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.scripts/audio/control.sh up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.scripts/audio/control.sh down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("~/.scripts/audio/control.sh mute"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("~/.scripts/audio/control.sh play-pause"), { locked = true })
hl.bind(mainMod .. " + ALT + F11", hl.dsp.exec_cmd("~/.scripts/audio/control.sh play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("~/.scripts/audio/control.sh next"), { locked = true })
hl.bind(mainMod .. " + ALT + F12", hl.dsp.exec_cmd("~/.scripts/audio/control.sh next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("~/.scripts/audio/control.sh previous"), { locked = true })
hl.bind(mainMod .. " + ALT + F10", hl.dsp.exec_cmd("~/.scripts/audio/control.sh previous"), { locked = true })
hl.bind("XF86Sleep", hl.dsp.exec_cmd("~/.scripts/suspend.sh"), { locked = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("~/.scripts/brightness.sh up notify"), { locked = true, release = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.scripts/brightness.sh down notify"), { locked = true, release = true })
hl.bind(mainMod .. " + ALT + up", hl.dsp.exec_cmd("~/.scripts/brightness.sh up notify"), { locked = true, repeating = true })
hl.bind(mainMod .. " + ALT + down", hl.dsp.exec_cmd("~/.scripts/brightness.sh down notify"), { locked = true, repeating = true })

hl.bind(mainMod .. " + Tab", hl.dsp.window.cycle_next({ next = true }))
hl.bind(mainMod .. " + Tab", hl.dsp.window.bring_to_top())
hl.bind("ALT + Tab", hl.dsp.focus({ workspace = "previous_per_monitor" }))
hl.bind("ALT + SHIFT + Tab", hl.dsp.focus({ workspace = "previous_per_monitor" }))
hl.bind(mainMod .. " + S", hl.dsp.focus({ monitor = "+1" }))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.workspace.swap_monitors({ monitor1 = "DP-3", monitor2 = "DP-4" }))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.focus({ monitor = "+1" }))
hl.bind(mainMod .. " + N", hl.dsp.focus({ workspace = "empty" }))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.window.move({ workspace = "empty" }))

hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

hl.bind(mainMod .. " + mouse_up", hl.dsp.exec_cmd("~/.scripts/workspace_swipe.py next"))
hl.bind(mainMod .. " + mouse_down", hl.dsp.exec_cmd("~/.scripts/workspace_swipe.py prev"))

hl.bind(mainMod .. " + SHIFT + mouse_up", hl.dsp.window.move({ workspace = "m+1" }))
hl.bind(mainMod .. " + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "m-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())
hl.config({
    binds = {
        allow_workspace_cycles = true,
        scroll_event_delay = 10,
    },
    -- gesture = 3, down, dispatcher, workspace, empty
    -- gesture = 3, up, dispatcher, workspace, previous_per_monitor
    -- Set programs that you use
    -- $menu = pkill tofi || tofi-drun --drun-launch=true
    -- Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
    -- bind = $mainMod CTRL, Q, exit, 
    -- bindr = $mainMod, SUPER_L, exec, $menu
    -- bind = $mainMod SHIFT, F, fullscreenstate, 2
    -- bind = $mainMod, J, togglesplit, # dwindle
    -- bind = $mainMod SHIFT, B, exec, ~/.scripts/toggle_bluetooth.sh
    -- bind = $mainMod, P, pseudo, # dwindle
    -- bind = ALT, F4, killactive, 
    -- bind = CTRL ALT, Delete, exit
    -- bindr = CTRL SHIFT, Shift_L, exec, ~/.scripts/switch_kb_layout.sh
    -- bindr = CTRL SHIFT, Control_L, exec, ~/.scripts/switch_kb_layout.sh
    -- Move focus with mainMod + arrow keys
    -- Something is broken on my laptop
    -- bind = $mainMod SHIFT, Tab, workspace, m-1
    -- bind = $mainMod SHIFT, Tab, bringactivetotop
    -- bindr = CTRL, Control_R, workspace, previous_per_monitor
    -- bind = $mainMod CTRL SHIFT, left, exec, hyprctl keyword monitor "HDMI-A-1,preferred,-1920x-216,2"
    -- bind = $mainMod CTRL SHIFT, right, exec, hyprctl keyword monitor "HDMI-A-1,preferred,1536x-216,2"
    -- Switch workspaces with mainMod + [0-9]
    -- bind = $mainMod, End, workspace, last
    -- Move active window to a workspace with mainMod + SHIFT + [0-9]
    -- Example special workspace (scratchpad)
    -- bind = $mainMod, S, togglespecialworkspace, magic
    -- bind = $mainMod SHIFT, S, movetoworkspace, special:magic
    -- Scroll through existing workspaces with mainMod + scroll
    -- Move/resize windows with mainMod + LMB/RMB and dragging
})

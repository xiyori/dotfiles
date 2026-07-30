-- Example windowrule v2
-- windowrule = float on,match:class ^(kitty)$,match:title ^(kitty)$
-- See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

hl.window_rule({
    match = {
        class = ".*",
    },
    suppress_event = "maximize",
})

hl.window_rule({
    match = {
        class = "^(blueman|file-).*",
    },
    float = true,
})

hl.window_rule({
    match = {
        class = "^(org.pulseaudio.pavucontrol)$",
    },
    float = true,
    size = "(monitor_w*0.4) (monitor_h*0.6)",
})

hl.window_rule({
    match = {
        class = "^(ristretto|qimgv|mpv)$",
    },
    opacity = "1 override",
})

hl.window_rule({
    match = {
        class = "^(engrampa|qalculate-gtk|tty-flex|font-viewer|nm-connection-editor)$",
    },
    float = true,
})

hl.window_rule({
    match = {
        class = "^(tty-flex)$",
    },
    animation = "slide",
})

hl.window_rule({
    match = {
        class = "^(tty-flex)$",
        title = "^(cava)$",
    },
    size = "650 240",
})

hl.window_rule({
    match = {
        class = "^(tty-flex)$",
        title = "^(tty-clock)$",
    },
    size = "480 165",
})

hl.window_rule({
    match = {
        class = "^(tty-flex)$",
        title = "^(donut)$",
    },
    size = "650 420",
})

-- windowrule=noanim,match:class ^(qimgv)$,workspace:name:Music
-- windowrule=stay_focused on,match:class ^(Rofi)$
hl.window_rule({
    match = {
        class = "^(file-).*",
    },
    stay_focused = true,
})

hl.window_rule({
    match = {
        class = "^(gamescope|geometrydash.exe)$",
    },
    fullscreen = true,
})

hl.window_rule({
    match = {
        title = "^(Wine Desktop)$",
    },
    fullscreen = true,
})

hl.window_rule({
    match = {
        class = "^(thunar|Thunar)$",
        title = "^(Confirm to replace files|Attention|File Operation Progress|Rename |Create New ).*",
    },
    float = true,
})

-- windowrule=center on,match:class ^(thunar|Thunar)$,match:title ^(Confirm to replace files|Attention|File Operation Progress|Rename |Create New ).*
-- windowrule=stay_focused on,match:class ^(thunar|Thunar)$,match:title ^(Confirm to replace files|Rename |Create New ).*
hl.window_rule({
    match = {
        class = "^(gimp)$",
        title = "^(Export Image)$",
    },
    stay_focused = true,
})

hl.window_rule({
    match = {
        title = ".*(- Properties)$",
    },
    float = true,
})

hl.window_rule({
    match = {
        class = "^(firefox|Tor Browser|librewolf)$",
        title = "^(Enter name of file to save|Save Image).*",
    },
    size = "(monitor_w*0.8) (monitor_h*0.8)",
})

hl.window_rule({
    match = {
        class = "^(firefox|Tor Browser|LibreWolf)$",
        title = "^(Enter name of file to save|Save Image).*",
    },
    center = true,
})

hl.window_rule({
    match = {
        class = "^(org\\.telegram\\.desktop)",
    },
    workspace = "name:Telegram",
})

hl.window_rule({
    match = {
        title = "^(Select fonts to remove)$",
    },
    size = "(monitor_w*0.4) (monitor_h*0.4)",
    center = true,
})

hl.window_rule({
    match = {
        class = "^$",
        title = "^(LSP ).*",
    },
    center = true,
})

hl.window_rule({
    match = {
        class = "^(carla)$",
    },
    workspace = "name:Carla silent",
})

-- windowrule=move 100%+1 100%+1,match:title ^(app.zoom.us is sharing your screen.)$

hl.env("XCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("GTK_THEME", "catppuccin-mocha-mauve-standard+default")
hl.env("BAT_THEME", "Catppuccin Mocha")

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            inactive_border = "rgb(1E1E2E)",
            active_border = "rgba(f5c2e7ff)",
        },
    },
    decoration = {
        -- See https://wiki.hyprland.org/Configuring/Variables/ for more
        rounding = 5,
        active_opacity = 1,
        inactive_opacity = 0.92,
        fullscreen_opacity = 1,
        dim_inactive = false,
        dim_strength = 0.05,
        blur = {
            enabled = true,
            size = 5,
            passes = 3,
            new_optimizations = true,
            xray = true,
            ignore_opacity = true,
        },
        shadow = {
            enabled = true,
            range = 10,
            render_power = 4,
            color = "rgba(1a1a1aaa)",
            color_inactive = "rgba(0000001e)",
        },
    },
    animations = {
        enabled = true,
        -- Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
        -- animation = fadeSwitch, 0
    },
})

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 2,
    bezier = "myBezier",
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 4,
    bezier = "default",
    style = "popin 80%",
})
hl.animation({
    leaf = "border",
    enabled = true,
    speed = 8,
    bezier = "default",
})
hl.animation({
    leaf = "borderangle",
    enabled = true,
    speed = 8,
    bezier = "default",
})
hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 2,
    bezier = "default",
})
hl.animation({
    leaf = "fadeOut",
    enabled = true,
    speed = 4,
    bezier = "default",
})
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 2,
    bezier = "default",
})

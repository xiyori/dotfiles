hl.config({
    plugin = {
        hyprgrass = {
            -- The default sensitivity is probably too low on tablet screens,
            -- I recommend turning it up to 4.0
            sensitivity = 4.0,

            -- in milliseconds
            long_press_delay = 400,

            -- resize windows by long-pressing on window borders and gaps.
            -- If general:resize_on_border is enabled, general:extend_border_grab_area is
            -- used for floating windows
            resize_on_border_long_press = true,

            -- in pixels, the distance from the edge that is considered an edge
            edge_margin = 10,
        }
    }
})

hl.plugin.hyprgrass.bind {
    pattern = {kind = "swipe", fingers = 3, direction = "l"},
    action = hl.dsp.exec_cmd("~/.scripts/workspace_swipe.py next"),
}
hl.plugin.hyprgrass.bind {
    pattern = {kind = "swipe", fingers = 3, direction = "r"},
    action = hl.dsp.exec_cmd("~/.scripts/workspace_swipe.py prev"),
}
hl.plugin.hyprgrass.bind {
    pattern = {kind = "swipe", fingers = 3, direction = "d"},
    action = hl.dsp.window.close(),
}
-- longpress can trigger mouse binds:
hl.plugin.hyprgrass.bind {
    pattern = {kind = "longpress", fingers = 2},
    action = hl.dsp.window.drag(),
    mouse = true,
}

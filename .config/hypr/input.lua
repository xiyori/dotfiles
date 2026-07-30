-- For all categories, see https://wiki.hyprland.org/Configuring/Variables/

hl.device({
    name = "synps/2-synaptics-touchpad",
    sensitivity = 0.15,
    accel_profile = "adaptive",
})

hl.device({
    name = "syna3503:00-06cb:cfc6-touchpad",
    -- sensitivity = 0.15
    accel_profile = "adaptive",
    scroll_factor = 0.5,
})

hl.device({
    name = "syna3503:00-06cb:cfc6-mouse",
    enabled = false,
})

hl.config({
    input = {
        kb_layout = "us,ru",
        kb_options = "grp:win_space_toggle",
        -- kb_variant =
        numlock_by_default = false,
        follow_mouse = 2,
        float_switch_override_focus = 0,
        touchpad = {
            natural_scroll = true,
            scroll_factor = 1,
            -- disable_while_typing = false
        },
        accel_profile = "flat",
    },
    -- device {
    --     name = wacom-intuos-bt-m-pen
    --     output = current
    --     active_area_size = 216 121.5
    --     active_area_position = 0.0 13.5
    -- }
})

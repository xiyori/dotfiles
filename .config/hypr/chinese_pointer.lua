hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("mpv --background=none /home/sergej/GitHub/dotfiles/assets/arrow.mov"))
hl.window_rule({
    match = {
        class = "^(mpv)$",
        title = "^(arrow.mov).*",
    },
    no_blur = true,
    no_anim = true,
    no_focus = true,
    decorate = false,
    float = true,
    size = "256 144",
    move = {"(cursor_x-(window_w*0.3))", "(cursor_y-(window_h*0.15))"},
})

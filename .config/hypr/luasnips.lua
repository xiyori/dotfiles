hl.on("window.open", function(w)
    if w.class ~= "librewolf" then return end
    if w.initial_title ~= "LibreWolf" then return end

    local ff_windows = hl.get_windows({ class = "librewolf" })
    if #ff_windows <= 1 then return end

    local sub
    sub = hl.on("window.title", function(tw)
        if tw.address ~= w.address then return end

        if tw.title:match("^Extension:") then
            sub:remove()

            hl.dispatch(hl.dsp.window.float({ action = "set", window = tw }))
            hl.dispatch(hl.dsp.window.resize({ x = 800, y = 600, window = tw }))
            hl.dispatch(hl.dsp.window.center({ window = tw }))
            hl.dispatch(hl.dsp.focus({ window = tw }))
        end
    end)
end)

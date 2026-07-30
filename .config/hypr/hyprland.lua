--
-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- Source a file (multi-file configs)

require("environment")
require("general")
require("input")
require("windowrules")
require("binds")
require("appearance")
require("monitors")
require("hyprgrass")
require("chinese_pointer")

-- See https://wiki.hyprland.org/Configuring/Keywords/ for more

-- Execute your favorite apps at launch

hl.on("hyprland.start", function()
    hl.exec_cmd("~/.scripts/autostart.sh")
    hl.exec_cmd("pkill hypridle ; hypridle")
end)



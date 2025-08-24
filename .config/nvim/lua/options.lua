require "nvchad.options"

-- add yours here!
local opt = vim.opt
local o = vim.o

vim.api.nvim_create_user_command('Vb', 'normal! <C-v>', {})
o.shell = '/usr/bin/fish'
-- o.tabstop = 4
-- o.shiftwidth = 4
-- o.softtabstop = 4
-- o.smarttab = true
o.wrap = true
-- o.autoindent = true
-- o.cin = true
o.hlsearch = true
o.incsearch = true
o.listchars = "tab:⋅⋅,trail:-,nbsp:+"
o.list = true
o.clipboard = ""
opt.iskeyword:remove("_")

-- o.cursorlineopt ='both' -- to enable cursorline!

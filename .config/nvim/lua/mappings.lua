require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("v", "<C-c>", '"+yi')
map("v", "<C-x>", '"+c')
map("v", "<C-v>", 'c<ESC>"+p')
map("i", "<C-v>", "<C-r><C-o>+")
map("n", "<BS>", "a<C-W>")
map("n", "<C-z>", ":u<CR>")
map("i", "<C-z>", "<C-o>:u<CR>")
map("n", "<C-a>", "ggVG")
map("i", "<C-a>", "<ESC>ggVG")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

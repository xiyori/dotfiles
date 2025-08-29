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
map("i", "<C-/>", "<ESC>gcci", { desc = "toggle comment", remap = true })
map("n", "<C-/>", "gcc", { desc = "toggle comment", remap = true })
map("v", "<C-/>", "gc", { desc = "toggle comment", remap = true })
map("i", "<C-TAB>", function()
  require("nvchad.tabufline").next()
end)
map("n", "<C-TAB>", function()
  require("nvchad.tabufline").next()
end)
map("i", "<CS-TAB>", function()
  require("nvchad.tabufline").prev()
end)
map("n", "<CS-TAB>", function()
  require("nvchad.tabufline").prev()
end)
map("v", "<TAB>", ">")
map("v", "<S-TAB>", "<")
map("v", "(", "Sb", { desc = "surround parentheses", remap = true })
map("v", "[", "S]", { desc = "surround brackets", remap = true })
map("v", "{", "SB", { desc = "surround braces", remap = true })

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<Leader>nf", ":lua require('neogen').generate()<CR>", opts)

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

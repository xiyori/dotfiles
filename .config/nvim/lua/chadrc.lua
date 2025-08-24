-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

local utils = require "nvchad.stl.utils"

local sep_style = "arrow"
local sep_icons = utils.separators
local separators = (type(sep_style) == "table" and sep_style) or sep_icons[sep_style]

-- local sep_l = separators["left"]
local sep_r = separators["right"]

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "catppuccin",

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },

  changed_themes = {
    catppuccin = {
      base_30 = {
        grey = "#515160",
        grey_fg = "#6c6b7f",
      },
    },
  },
}

-- M.nvdash = { load_on_startup = true }
-- M.ui = {
--   tabufline = {
--     lazyload = false,
--   },
-- }

local myutils = {
  file = function()
    local icon = "󰈚"
    local buf = utils.stbufnr()
    local path = vim.api.nvim_buf_get_name(buf)
    local name = (path == "" and "Empty") or path:match "([^/\\]+)[/\\]*$"

    if name ~= "Empty" then
      local devicons_present, devicons = pcall(require, "nvim-web-devicons")

      if devicons_present then
        local ft_icon = devicons.get_icon(name)
        icon = (ft_icon ~= nil and ft_icon) or icon
      end
    end

    if vim.api.nvim_get_option_value("modified", { buf = buf }) then
      name = name .. "*"
    end

    return { icon, name }
  end,
  lsp = function()
    if rawget(vim, "lsp") then
      for _, client in ipairs(vim.lsp.get_clients()) do
        if client.attached_buffers[utils.stbufnr()] then
          return (vim.o.columns > 100 and " " .. client.name .. " ") or " LSP "
        end
      end
    end

    return ""
  end,
}

M.ui = {
  statusline = {
    theme = "default",
    separator_style = sep_style,
    order = { "mode", "myfile", "git", "%=", "lsp_msg", "%=", "diagnostics", "mylsp", "cwd", "cursor" },
    modules = {
      myfile = function()
        local x = myutils.file()
        local name = " " .. x[2]
        return "%#St_file# " .. x[1] .. name .. "%#St_file_sep#" .. sep_r
      end,
      mylsp = function()
        return "%#St_Lsp#" .. myutils.lsp()
      end,
    },
  },
}

return M

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

return {
  {
    "saghen/blink.cmp",
    opts = {
      -- snippets = { preset = "luasnip" },
      -- cmdline = { enabled = true },
      -- appearance = { nerd_font_variant = "normal" },
      -- fuzzy = { implementation = "prefer_rust" },
      -- sources = { default = { "lsp", "snippets", "buffer", "path" } },

      keymap = {
        preset = "super-tab",
        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          function(cmp)
            if cmp.snippet_active() then
              return cmp.snippet_forward()
            end
          end,
          function(cmp)
            if has_words_before() then
              return cmp.show()
            end
          end,
          "fallback",
        },
        ["<S-Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.snippet_backward()
            end
          end,
          "fallback",
        },
        ["<Esc>"] = {
          "cancel",
          "fallback",
        },
      },

      -- completion = {
      --   -- ghost_text = { enabled = true },
      --   documentation = {
      --     auto_show = true,
      --     auto_show_delay_ms = 200,
      --     window = { border = "single" },
      --   },
      --
      --   -- from nvchad/ui plugin
      --   -- exporting the ui config of nvchad blink menu
      --   -- helps non nvchad users
      --   menu = require("nvchad.blink").menu,
      -- },
    },
  },
}

-- using packer.nvim
return {
  {
    "nmac427/guess-indent.nvim",
    lazy = false,
    config = function()
      require("guess-indent").setup {}
    end,
  },
}

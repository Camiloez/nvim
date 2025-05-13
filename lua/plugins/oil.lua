return {
  "stevearc/oil.nvim",
  opts = {},
  keys = {
    {
      "<leader>od",
      function()
        require("oil").open "."
      end,
      desc = "Open directory",
    },
    {
      "<leader>of",
      function()
        require("oil").open_float "."
      end,
      desc = "Open float directory",
    },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
}

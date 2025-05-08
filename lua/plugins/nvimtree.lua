return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  keys = {
    { "<C-n>",      "<cmd>NvimTreeToggle<cr>", desc = "Toggle nvimtree" },
    { "<leader>nf", "<cmd>NvimTreeFocus<cr>",  desc = "Focus nvimtree" },
  },
  opts = {},
}

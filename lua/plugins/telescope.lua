return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")


      vim.keymap.set("n", "<leader>ff", builtin.find_files, {}, "find files")
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
      vim.keymap.set("n", "<leader>dr", "<cmd> Telescope lsp_references <cr>")
      vim.keymap.set("n", "<leader>fz", "<cmd> Telescope current_buffer_fuzzy_find <cr>")
      vim.keymap.set("n", "<leader>fh", "<cmd> Telescope help_tags <cr>")
      vim.keymap.set("n", "<leader>fd", "<cmd> Telescope file_browser hidden=true respect_gitignore=false <cr>")
      vim.keymap.set("n", "<leader>ss", "<cmd> :sp <cr>")
      vim.keymap.set("n", "<leader>sv", "<cmd> :vsp <cr>")
      vim.keymap.set("n", "<leader>st", "<cmd> :tabnew <cr>")
      vim.keymap.set("n", "<leader>q", "<cmd> :q <cr>")
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      require("telescope").load_extension("ui-select")
    end,
  },
}

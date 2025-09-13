return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    theme = "hyper",
    config = {
      week_header = { enable = true },
      project = { enable = false },
      mru = { enable = false },

      shortcut = {
        {
          desc = " Open file from current folder",
          key = "f",
          action = function()
            local files = vim.fn.readdir(vim.fn.getcwd())
            vim.ui.select(files, { prompt = "Select file:" }, function(choice)
              if choice then
                vim.cmd("edit " .. vim.fn.fnameescape(choice))
              end
            end)
          end,
        },
      },
    },
  },
}

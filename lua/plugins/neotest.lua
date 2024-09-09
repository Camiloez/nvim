return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-neotest/nvim-nio",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
  },
  opts = function()
    local options = {
      adapters = {
        require("neotest-python")({
          -- Extra arguments for nvim-dap configuration
          -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
          -- dap = { justMyCode = false },
          -- Command line arguments for runner
          -- Can also be a function to return dynamic values
          args = { "--log-level", "DEBUG" },
          -- Runner to use. Will use pytest if available by default.
          -- Can be a function to return dynamic value.
          runner = "pytest",
          -- Custom python path for the runner.
          -- Can be a string or a list of strings.
          -- Can also be a function to return dynamic value.
          -- If not provided, the path will be inferred by checking for
          -- virtual envs in the local directory and for Pipenev/Poetry configs
          python = nil,
          -- Returns if a given file path is a test file.
          -- NB: This function is called a lot so don't perform any heavy tasks within it.
          -- is_test_file = function(file_path)
          --   ...
          -- end,
          -- !!EXPERIMENTAL!! Enable shelling out to `pytest` to discover test
          -- instances for files containing a parametrize mark (default: false)
          pytest_discover_instances = true,
        }),
      },
    }
    return options
  end,
  config = function(_, opts)
    require("neotest").setup(opts)

    vim.keymap.set("n", "<leader>rt", function()
      require("neotest").run.run()
    end)

    vim.keymap.set("n", "<leader>rl", function()
      require("neotest").run.run_last()
    end)

    vim.keymap.set("n", "<leader>rd", function()
      require("neotest").run.run({ strategy = "dap" })
    end)

    vim.keymap.set("n", "<leader>rs", function()
      require("neotest").run.stop()
    end)

    vim.keymap.set("n", "<leader>rf", function()
      require("neotest").run.run({ file = vim.fn.expand("%") })
    end)

    vim.keymap.set("n", "<leader>op", function()
      require("neotest").run.output_panel.open()
    end)


    vim.keymap.set("n", "<leader>tt", function()
      require("neotest").summary.toggle()
    end)
  end,
}

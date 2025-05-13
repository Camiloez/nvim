return {
  -- debug adapter protocol (dap) client
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>db",
        function()
          vim.cmd "DapToggleBreakpoint"
        end,
        desc = "Create or remove debug breakpoint",
      },
      {
        "<leader>dc",
        function()
          vim.cmd "DapContinue"
        end,
        desc = "Start debug session or jump to next breakpoint",
      },
      {
        "<leader>dx",
        function()
          vim.cmd "DapTerminate"
        end,
        desc = "Terminate debug session",
      },
    },
  },
  -- nvim-dap UI
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.after.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.after.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  -- dap for python
  {
    "mfussenegger/nvim-dap-python",
    ft = { "python" },
    dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" },
    keys = { { "<leader>dt", desc = "Run test in debug" } },
    config = function()
      local dp = require "dap-python"
      dp.setup()
      dp.test_runner = "pytest"
      vim.keymap.set("n", "<leader>dt", function()
        require("dap-python").test_method()
      end, { desc = "Run test in debug session" })
    end,
  },
}

return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "black",
      "copilot-language-server",
      "debugpy",
      "flake8",
      "gopls",
      "isort",
      "lua-language-server",
      "mypy",
      "pyright",
      "python-lsp-server",
      "ruff",
      "sqls",
      "stylua",
      "terraform-ls",
      "texlab",
    },
    ui = {
      border = require("utils").border "CmpBorder",
      icons = {
        package_pending = " ",
        package_installed = "󰄳 ",
        package_uninstalled = " 󰚌",
      },
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)

    -- custom cmd to install all mason binaries listed
    vim.api.nvim_create_user_command("MasonInstallAll", function()
      vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
    end, {})

    vim.g.mason_binaries_list = opts.ensure_installed
  end,
}

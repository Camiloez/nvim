return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "ruff_lsp",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      vim.diagnostic.config({
      	signs = true,
      	underline = true,
      	update_in_insert = false,
      	virtual_text = false,
      	float = {
      		show_header = true,
      		source = "always",
      		border = "rounded",
      		focusable = true,
      	},
      })

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        filetypes = { "lua" },
      })
      lspconfig.ts_ls.setup({ capabilities = capabilities })
      lspconfig.html.setup({ capabilities = capabilities })

      lspconfig.pyright.setup({
        capabilities = capabilities,
        filetypes = { "python" },
      })

      -- lspconfig.ruff_lsp.setup({
      --   init_options = {
      --     settings = {
      --       args = {},
      --     },
      --   },
      -- })
      --
      --
      vim.keymap.set('n', "<leader>ld", vim.diagnostic.open_float, {})
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
      vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<CR>", "o<Esc>")
      vim.keymap.set("n", "<S-CR>", "O<Esc>")
    end,
  },
}

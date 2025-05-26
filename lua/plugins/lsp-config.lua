return {
	{
		"williamboman/mason-lspconfig.nvim",
    version="1.29.0",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"gopls",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local on_attach = function(client, bufnr)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false

				if client.supports_method("textDocument/semanticTokens") then
					client.server_capabilities.semanticTokensProvider = nil
				end
			end

			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			lspconfig.lua_ls.setup({})

			-- General mappings
			vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, {})
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
			vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<CR>", "o<Esc>")
			vim.keymap.set("n", "<S-CR>", "O<Esc>")
			vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format, {})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set({ "n" }, "<leader>rn", vim.lsp.buf.rename, {})
			vim.keymap.set({ "n"}, "gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, {})

			--- Go
			lspconfig.gopls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				settings = {
					gopls = {
						completeUnimported = true,
						analyses = {
							unusedparams = true,
              unusedwrite = true,
						},
					},
				},
			})
		end,
	},
}

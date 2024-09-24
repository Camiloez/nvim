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
					focusable = false,
				},
			})

			vim.api.nvim_create_autocmd("CursorHold", {
				pattern = "*",
				callback = function()
					local opts = {
						focusable = false,
						close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
						border = "rounded",
						source = "always",
					}
					vim.diagnostic.open_float(nil, opts)
				end,
			})

			-- Set a short CursorHold delay to trigger after 0.1 seconds (100 ms)
			vim.o.updatetime = 100 -- Update time for CursorHold

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

			lspconfig.ruff_lsp.setup({
				init_options = {
					settings = {
						args = {},
					},
				},
			})

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

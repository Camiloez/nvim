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
					"ruff",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			local util = require("lspconfig/util")

			lspconfig.gopls.setup({
				capabilities = capabilities,
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_dir = util.root_pattern("go.work", "go.mod", ".git"),
				settings = {
					gopls = {
						completeUnimported = true,
						usePlaceholders = true,
						analyses = {
							unusedparams = true,
						},
					},
				},
			})

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
				before_init = function(_, config)
					local venv = os.getenv("VIRTUAL_ENV")
					if venv then
						config.settings.python.pythonPath = venv .. "/bin/python"
					else
						-- fallback to system python
						config.settings.python.pythonPath = "/usr/bin/python3"
					end
				end,
			})

			-- ✅ Ruff LSP (for linting + formatting)
			lspconfig.ruff.setup({
				cmd = { "/Users/camilo/.pyenv/shims/ruff", "server" },
				capabilities = capabilities,
				init_options = {
					settings = {
						args = {}, -- you can add "--select" or "--fix" here if needed
					},
				},
			})

			vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, {})
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
			vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<CR>", "o<Esc>")
			vim.keymap.set("n", "<S-CR>", "O<Esc>")
			vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format, {})
		end,
	},
}

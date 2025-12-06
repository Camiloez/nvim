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
					"svelte",
					"gopls",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Go LSP
			vim.lsp.config("gopls", {
				capabilities = capabilities,
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_markers = { "go.work", "go.mod", ".git" },
				settings = {
					gopls = {
						completeUnimported = true,
						usePlaceholders = true,
						analyses = {
							unusedparams = true,
						},
						gofumpt = true,
					},
				},
			})

			-- Lua LSP
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				cmd = { "lua-language-server" },
				filetypes = { "lua" },
				root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
			})

			-- TypeScript LSP
			vim.lsp.config("ts_ls", {
				capabilities = capabilities,
				cmd = { "typescript-language-server", "--stdio" },
				filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
				root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
			})

			-- HTML LSP
			vim.lsp.config("html", {
				capabilities = capabilities,
				cmd = { "vscode-html-language-server", "--stdio" },
				filetypes = { "html", "templ" },
				root_markers = { "package.json", ".git" },
			})

			-- Pyright (Python LSP)
			vim.lsp.config("pyright", {
				capabilities = capabilities,
				cmd = { "pyright-langserver", "--stdio" },
				filetypes = { "python" },
				root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
				before_init = function(_, config)
					local venv = os.getenv("VIRTUAL_ENV")
					if venv then
						config.settings = config.settings or {}
						config.settings.python = config.settings.python or {}
						config.settings.python.pythonPath = venv .. "/bin/python"
					else
						config.settings = config.settings or {}
						config.settings.python = config.settings.python or {}
						config.settings.python.pythonPath = "/usr/bin/python3"
					end
				end,
			})

			-- Ruff LSP
			vim.lsp.config("ruff", {
				cmd = { "/Users/camilo/.pyenv/shims/ruff", "server" },
				capabilities = capabilities,
				filetypes = { "python" },
				root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
				init_options = {
					settings = {
						args = {},
					},
				},
			})

			-- Svelte LSP
			vim.lsp.config("svelte", {
				capabilities = capabilities,
				cmd = { "svelteserver", "--stdio" },
				filetypes = { "svelte" },
				root_markers = { "package.json", ".git" },
			})

			-- Enable all LSP servers
			vim.lsp.enable({ "gopls", "lua_ls", "ts_ls", "html", "pyright", "ruff", "svelte" })

			-- Diagnostics config
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

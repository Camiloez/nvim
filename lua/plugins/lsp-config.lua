return {
	{
		"williamboman/mason-lspconfig.nvim",
		version = "1.29.0",
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

			capabilities.textDocument.completion.completionItem = {
				documentationFormat = { "markdown", "plaintext" },
				snippetSupport = true,
				preselectSupport = true,
				insertReplaceSupport = true,
				labelDetailsSupport = true,
				deprecatedSupport = true,
				commitCharactersSupport = true,
				tagSupport = { valueSet = { 1 } },
				resolveSupport = {
					properties = {
						"documentation",
						"detail",
						"additionalTextEdits",
					},
				},
			}

			lspconfig.lua_ls.setup({})

			-- General mappings
			vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, {})
			vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", {})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", {})
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
			vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "<CR>", "o<Esc>")
			vim.keymap.set("n", "<S-CR>", "O<Esc>")
			vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format, {})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set({ "n" }, "<leader>rn", vim.lsp.buf.rename, {})
			vim.keymap.set({ "n" }, "gR", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, {})
			vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", {})

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

			-- Typescript react native to ignore bad imports

			lspconfig.vtsls.setup({
				capabilities = capabilities,
				filetypes = {
					"typescript",
					"typescriptreact",
					"typescript.tsx",
					"javascript",
					"javascriptreact",
					"javascript.jsx",
				},
				root_dir = lspconfig.util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git"),
				settings = {
					typescript = {
						inlayHints = {
							parameterNames = { enabled = "all" },
							parameterTypes = { enabled = true },
							variableTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							enumMemberValues = { enabled = true },
						},
						watchOptions = {
							watchFile = "useFsEvents",
							excludeDirectories = {
								"**/node_modules",
								"**/android",
								"**/ios",
								"**/vendor",
								"**/build",
							},
						},
					},
					javascript = {
						inlayHints = {
							parameterNames = { enabled = "all" },
							parameterTypes = { enabled = true },
							variableTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							enumMemberValues = { enabled = true },
						},
					},
				},
				on_attach = function(client, bufnr)
					-- Optional: filter noisy diagnostics
				end,
			})

			--- Emmet
			require("lspconfig").emmet_ls.setup({
				filetypes = {
					"html",
					"css",
					"javascript",
					"javascriptreact",
					"typescriptreact",
					"svelte",
					"vue",
					"xml",
				},
				init_options = {
					html = {
						options = {
							["bem.enabled"] = true,
						},
					},
				},
			})

			--- Python
			local get_path = function(package)
				local path = lspconfig.util.path

				-- Use activated virtualenv
				if vim.env.VIRTUAL_ENV then
					return path.join(vim.env.VIRTUAL_ENV, "bin", package)
				end

				local status, workspace = pcall(vim.lsp.buf.list_workspace_folders()[1])
				if status then
					-- Find and use local virtualenv
					local match = vim.fn.glob(path.join(workspace, ".venv"))
					if match ~= "" then
						return path.join(match, "bin", package)
					end

					-- Find and use virtualenv via poetry in workspace directory
					match = vim.fn.glob(path.join(workspace, "poetry.lock"))
					if match ~= "" then
						local venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
						return path.join(venv, "bin", package)
					end
				end

				-- Fallback to system package
				local system_path = vim.fn.exepath(package)
				return system_path
			end

			local cmd_from_path = function(package)
				local path = get_path(package)
				if path ~= "" then
					return path
				end
				return package
			end

			---@param package string
			---@return boolean
			local is_package_in_pyproject = function(package)
				local path = lspconfig.util.path
				local match = vim.fn.glob(path.join(vim.fn.getcwd(), "pyproject.toml"))
				if match ~= "" then
					local f = assert(io.open(match, "r"))
					local content = f:read("*all")
					f:close()
					if string.find(content, package) then
						return true
					end
				end
				return false
			end

			local is_pyright = is_package_in_pyproject("pyright")
			local is_ruff = is_package_in_pyproject("ruff")

			if is_pyright then
				-- Automatically set up to use the .venv in your project
				local project_root = vim.fn.getcwd()
				local venv_dir = ".venv"
				lspconfig.pyright.setup({
					on_attach = on_attach,
					capabilities = capabilities,
					cmd = { cmd_from_path("pyright-langserver"), "--stdio" },
					filetypes = { "python" },
					settings = {
						python = {
							venvPath = project_root,
							venv = venv_dir,
						},
					},
					root_dir = lspconfig.util.root_pattern(
						"pyproject.toml",
						"setup.py",
						"setup.cfg",
						"requirements.txt",
						".git"
					),
				})
			end

			if is_ruff then
				lspconfig.ruff.setup({
					cmd = { cmd_from_path("ruff"), "server" },
					on_attach = function(client, bufnr)
						on_attach(client, bufnr)
						client.server_capabilities.hoverProvider = false
						local bufopts = { noremap = true, silent = true, buffer = bufnr }
						vim.keymap.set("n", "<leader>fm", function()
							local buf_path = vim.api.nvim_buf_get_name(bufnr)
							vim.api.nvim_command("!" .. get_path("ruff") .. " format " .. buf_path)
							vim.api.nvim_command("!" .. get_path("ruff") .. " check " .. buf_path .. " --fix")
						end, bufopts)
					end,
					filetypes = { "python" },
				})
			end
			if not is_pyright and not is_ruff then
				lspconfig.pylsp.setup({
					on_attach = on_attach,
					capabilities = capabilities,
					filetypes = { "python" },
					cmd = { "pylsp" },
					settings = {
						pylsp = {
							configurationSources = { "flake8", "black", "isort", "mypy" },
							plugins = {
								pycodestyle = { enabled = false },
								flake8 = {
									enabled = true,
									ignore = { "E203", "W503" },
									max_line_length = 79,
								},
								isort = { enabled = true, profile = "black", multi_line_output = 3, line_length = 79 },
								black = { enabled = true, line_length = 79 },
							},
						},
					},
				})
				vim.g.pylsp = true
			end
		end,
	},
}

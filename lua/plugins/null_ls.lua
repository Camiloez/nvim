return {
	"nvimtools/none-ls.nvim",
	ft = { "lua", "python", "go" },
	config = function()
		local null_ls = require("null-ls")
		local sources = {}

		-- Always use stylua for lua
		table.insert(sources, null_ls.builtins.formatting.stylua)

		-- Only enable for Python when vim.g.pylsp is true
		if vim.g.pylsp then
			table.insert(sources, null_ls.builtins.formatting.black.with({ filetypes = { "python" } }))
			table.insert(sources, null_ls.builtins.formatting.isort.with({ filetypes = { "python" } }))
			table.insert(
				sources,
				null_ls.builtins.diagnostics.mypy.with({
					filetypes = { "python" },
					-- Use poetry for mypy to ensure venv/flask is found
					command = "poetry",
					args = { "run", "mypy", "--show-column-numbers", "$FILENAME" },
				})
			)
		end

		-- Always register go formatters, but restrict to go files
		table.insert(sources, null_ls.builtins.formatting.gofumpt.with({ filetypes = { "go" } }))
		table.insert(sources, null_ls.builtins.formatting.goimports.with({ filetypes = { "go" } }))

		null_ls.setup({ sources = sources })
	end,
}

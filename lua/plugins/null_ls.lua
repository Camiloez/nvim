return {
	"nvimtools/none-ls.nvim",
	ft = { "lua", "python", "go" },
	config = function()
		local null_ls = require("null-ls")
		local sources = {}

		-- Always use stylua for lua
		table.insert(sources, null_ls.builtins.formatting.stylua)


		-- Always register go formatters, but restrict to go files
		table.insert(sources, null_ls.builtins.formatting.gofumpt.with({ filetypes = { "go" } }))
		table.insert(sources, null_ls.builtins.formatting.goimports.with({ filetypes = { "go" } }))

		null_ls.setup({ sources = sources })
	end,
}

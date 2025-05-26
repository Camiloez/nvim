return {
	"olexsmir/gopher.nvim",
	ft = "go",
	build = function()
		vim.cmd.GoInstallDeps()
	end,
	opts = {},
	keys = {
		{
			"<leader>gj",
			function()
				vim.cmd("silent GoTagAdd json")
			end,
			desc = "Add JSON tags to Go struct",
		},
	},
}

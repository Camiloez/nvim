return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"mfussenegger/nvim-dap",
		"mfussenegger/nvim-dap-python", --optional
		{ "nvim-telescope/telescope.nvim", branch = "regexp", dependencies = { "nvim-lua/plenary.nvim" } },
	},
	lazy = false,
	keys = {
		{ "<leader>vs", "<cmd>VenvSelect<cr>" },
	},
	opts = {
		options = {
			debug = true,
			enable_cached_venvs = false, -- disables the cache
		},
	},
}

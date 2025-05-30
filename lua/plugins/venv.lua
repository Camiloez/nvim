return {
	"linux-cultist/venv-selector.nvim",
	branch = "regexp",
	dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
	lazy = false,
	keys = {
		{ "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select virtual environment" },
	},
	config = function()
		require("venv-selector").setup()
	end,
}

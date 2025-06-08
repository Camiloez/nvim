return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	opts = {
		indent = {
			char = "┆", -- softer vertical line
			highlight = "IblIndent",
		},
	},
	config = function(_, opts)
		require("ibl").setup(opts)

		-- Set custom dimmed highlight for indent guides
		vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3a3a3a", nocombine = true })
	end,
}

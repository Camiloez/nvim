return {
	"nvim-treesitter/nvim-treesitter-context",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		enable = true, -- Enable the plugin
		max_lines = 0, -- Unlimited context lines (show all parent scopes)
		trim_scope = "outer", -- Remove outer scopes when max_lines is hit (we don’t hit it here)
		mode = "cursor", -- Update based on cursor position
		separator = nil, -- No visual separator line
		zindex = 20, -- Ensure it stays on top
	},
	config = function(_, opts)
		require("treesitter-context").setup(opts)
	end,
}

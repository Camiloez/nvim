return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	opts = {
		indent = {
			char = "│",
			tab_char = "│",
			smart_indent_cap = true,
			priority = 1,
		},
		scope = {
			enabled = true,
			show_start = false,
			show_end = false,
		},
		exclude = {
			filetypes = {
				"help",
				"terminal",
				"lazy",
				"lspinfo",
				"TelescopePrompt",
				"TelescopeResults",
        "dashboard",
				"",
			},
			buftypes = {
				"terminal",
				"nofile",
				"quickfix",
				"prompt",
			},
		},
	},
}

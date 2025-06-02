return {
	"NvChad/nvim-colorizer.lua",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		filetypes = {
			"css",
			"scss",
			"html",
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"lua",
			"vim",
			"json",
		},
		user_default_options = {
			RGB = true, -- #RGB hex codes
			RRGGBB = true, -- #RRGGBB hex codes
			names = false, -- "blue" or "red"
			RRGGBBAA = true, -- #RRGGBBAA hex codes
			AARRGGBB = false, -- 0xAARRGGBB hex codes
			rgb_fn = true, -- css rgb() and rgba()
			hsl_fn = true, -- css hsl() and hsla()
			css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, etc
			css_fn = true, -- Enable parsing css functions like `rgb()`
			tailwind = true, -- Enable tailwind colors (class names)
			mode = "background", -- Set the display mode: foreground / background / virtualtext
		},
	},
	config = function(_, opts)
		require("colorizer").setup(opts.filetypes, opts.user_default_options)
	end,
}

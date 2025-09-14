return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	lazy = false,
	version = false,
	opts = {
		provider = "copilot",
		auto_suggestion_provider = "copilot",
		providers = {
			copilot = {
				model = "gpt-4o",
				frequency_penalty = 0,
				presence_penalty = 0,
				extra_request_body = {
					max_tokens = 2000,
					temperature = 0,
					top_p = 1,
					n = 1,
				},
				keymap = {
					open = "", -- disables Option+Enter
				},
			},
		},
	},
	build = "make", -- run :AvanteBuild if failed to load avante_repo_map
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"zbirenbaum/copilot.lua", -- for providers='copilot'
		{
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
	config = function(_, opts)
		require("img-clip").setup()
		require("copilot").setup(opts.providers.copilot)
		require("render-markdown").setup()
		require("avante_lib").load(opts)
		require("avante").setup(opts)

		-- Disable Option+Enter in insert mode entirely
		vim.keymap.set("i", "<A-CR>", function() end, { noremap = true, silent = true })
	end,
}

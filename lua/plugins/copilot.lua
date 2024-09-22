return {
	"CopilotC-Nvim/CopilotChat.nvim",
	branch = "canary",
	dependencies = {
		{ "github/copilot.vim" }, -- or github/copilot.vim
		{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
	},
	build = "make tiktoken",
	opts = {
		debug = true,
	},
	config = function()
		require("CopilotChat").setup({
			window = {
				layout = "float",
				relative = "cursor",
				width = 1,
				height = 0.4,
				row = 1,
			},
			prompts = {
				Append = {
					prompt = "hello from append",
				},
			},
		})
	end,
	keys = {
		{
			"<Leader>cch",
			":'<,'>CopilotChat<CR>",
			mode = { "v" },
			desc = "Copilot Chat Selection",
		},
		{
			"<Leader>cch",
			":CopilotChatToggle<CR>",
			mode = { "n" },
			desc = "Toggle Copilot Chat",
		},
		{
			"<Leader>cce",
			":CopilotChatExplain<CR>",
			mode = { "v" },
			desc = "Copilot explain",
		},
		{
			"<Leader>ccf",
			":CopilotChatFix<CR>",
			mode = { "v" },
		},
	},
}

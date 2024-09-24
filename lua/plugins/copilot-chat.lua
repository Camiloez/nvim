return {
	"CopilotC-Nvim/CopilotChat.nvim",
	lazy = false, -- load only when required/called
  branch = "canary",
	dependencies = {
    {"zbirenbaum/copilot.lua"},
		-- { "github/copilot.vim" }, -- or github/copilot.vim
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
				Summarize = {
					prompt = "Please summarize the following text.",
				},
				Documentation = {
					prompt = "Please provide documentation for the following code.",
				},
				MyTests = {
					prompt = "Please generate unit tests for this code using pytest.",
				},
				MyReview = {
					prompt = "Please review the following code and provide suggestions for improvement.",
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
		{
			"<Leader>ccr",
			":CopilotChatMyReview<CR>",
			mode = { "v", "n" },
		},
		{
			"<Leader>ccs",
			":CopilotChatSummarize<CR>",
			mode = { "v", "n" },
		},
    {
      "<Leader>ccd",
      ":CopilotChatDocumentation<CR>",
      mode = { "v", "n" },
    },
    {
      "<Leader>cct",
      ":CopilotChatMyTests<CR>",
      mode = { "v", "n" },
    },
	},
}

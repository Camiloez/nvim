return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		dependencies = {
			--{"zbirenbaum/copilot.lua"},
			{ "github/copilot.vim" }, -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		build = function()
			vim.notify("Please Update remote plugins by running :UpdateRemotePlugins")
		end,
		opts = function()
			return {
				show_help = "yes",
				debug = true,
				{
					window = {
						layout = "float",
						relative = "cursor",
						width = 1,
						height = 0.5,
						row = 1,
					},
				},
			}
		end,
		config = function()
			require("CopilotChat").setup({

				window = {
					layout = "float",
					relative = "cursor",
					width = 1,
					height = 0.4,
					row = 1,
				},
			})

			vim.keymap.set("n", "<leader>ccq", function()
				local input = vim.fn.input("Quick Chat: ")
				if input ~= "" then
					require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
				end
			end)

			vim.keymap.set("n", "<leader>cca", function()
				local actions = require("CopilotChat.actions")
				require("CopilotChat.integrations.telescope").pick(actions.help_actions())
			end)

			vim.keymap.set("n", "<leader>ccp", function()
				local actions = require("CopilotChat.actions")
				require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
			end)
		end,
	},
}

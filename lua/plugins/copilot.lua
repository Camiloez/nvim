return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	config = function()
		-- Setup Copilot with the following configuration

		local copilot = require("copilot")

		copilot.setup({
			suggestion = {
				enabled = true,
				auto_trigger = false,
				keymap = {},
			},
		})

		vim.keymap.set("i", "<C-t>", function()
			require("copilot.suggestion").next()
		end, { silent = true })

		vim.keymap.set("i", "<Tab>", function()
			if require("copilot.suggestion").is_visible() then
				require("copilot.suggestion").accept()
			else
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
			end
		end, {
			silent = true,
		})

		vim.keymap.set("i", "<Right>", function()
			if require("copilot.suggestion").is_visible() then
				require("copilot.suggestion").accept_line()
			else
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Right>", true, false, true), "n", false)
			end
		end)

		vim.keymap.set("i", "<S-w>", function()
			if require("copilot.suggestion").is_visible() then
				require("copilot.suggestion").accept_word()
			else
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-w>", true, false, true), "n", false)
			end
		end)
	end,
}

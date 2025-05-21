return {
	"akinsho/bufferline.nvim",
  event = "VeryLazy",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local bl = require("bufferline")
		bl.setup({
			options = {
				show_buffer_close_icons = false,
				show_close_icon = false,
			},
		})

		vim.keymap.set("n", "<leader>x", ":bp<bar>sp<bar>bn<bar>bd<CR>", { desc = "Close buffer" })
		vim.keymap.set("n", "<Tab>", function()
			vim.cmd("BufferNext")
		end, { desc = "Go to next buffer" })
		vim.keymap.set("n", "<S-Tab>", function()
			vim.cmd("BufferPrevious")
		end, { desc = "Go to previous buffer" })

		for i = 1, 8 do
			vim.keymap.set("n", "<leader>" .. i, function()
				bl.go_to(i, true)
			end, { desc = "Go to buffer " .. i })
		end
		vim.keymap.set("n", "<leader>9", function()
			bl.go_to(-1, true)
		end, { desc = "Go to last buffer" })
	end,
}

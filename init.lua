local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local opts = {}

require("vim-options")
require("lazy").setup("plugins")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<Esc>", "<cmd> noh <CR>")

vim.keymap.set("n", "<C-a>", "<Esc>ggVG", { noremap = true, silent = true })
vim.keymap.set("i", "<C-a>", "<Esc>ggVG", { noremap = true, silent = true })

vim.keymap.set("i", "<S-Tab>", "<C-d>", { noremap = true, silent = true })


vim.opt.number = true
vim.opt.relativenumber = true

vim.keymap.set('i', '<fn><bs>', '<C-w>')
vim.api.nvim_set_keymap('i', '<C-d>', '<Del>', { noremap = true, silent = true })



vim.keymap.set("n", "<C-UP>", "<cmd>resize -2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-DOWN>", "<cmd>resize +2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-RIGHT>", ":vertical resize +2<cr>", { desc = "Increase Window Width" })
vim.keymap.set("n", "<C-LEFT>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })


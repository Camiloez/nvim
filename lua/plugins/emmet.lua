return {
	"mattn/emmet-vim",
	ft = { "html", "css", "typescriptreact", "javascriptreact", "vue", "svelte" },
	config = function()
		vim.g.user_emmet_leader_key = "<C-y>"
	end,
}

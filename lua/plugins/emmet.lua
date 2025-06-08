return {
	"mattn/emmet-vim",
	ft = { "html", "css", "typescriptreact", "javascriptreact", "vue", "svelte", "python" },
	config = function()
		-- Explicitly disable Emmet's built-in leader key
		vim.g.user_emmet_leader_key = ""

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "python",
			callback = function()
				vim.b.emmet_language = "html"

				-- Direct mapping in insert mode without expr, using true Vimscript fallback
				vim.cmd([[
          inoremap <buffer> <C-y> <C-o>:call emmet#expandAbbr(0, '')<CR>
        ]])
			end,
		})
	end,
}

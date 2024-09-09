return {
	"linux-cultist/venv-selector.nvim",
	dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
	branch = "regexp",
	lazy = false,
	config = function()
		require("venv-selector").setup({
			on_venv_activate_callback = nil, -- callback function for after a venv activates
			enable_default_searches = true, -- switches all default searches on/off
			enable_cached_venvs = true, -- use cached venvs that are activated automatically when a python file is registered with the LSP.
			cached_venv_automatic_activation = true, -- if set to false, the VenvSelectCached command becomes available to manually activate them.
			activate_venv_in_terminal = true, -- activate the selected python interpreter in terminal windows opened from neovim
			set_environment_variables = true, -- sets VIRTUAL_ENV or CONDA_PREFIX environment variables
			notify_user_on_venv_activation = true, -- notifies user on activation of the virtual env
			search_timeout = 5, -- if a search takes longer than this many seconds, stop it and alert the user
			debug = true,

			on_telescope_result_callback = nil,
			show_telescope_search_type = true,
			telescope_filter_type = "substring",
		})
	end,
	keys = {
		{ "<leader>vs", "<cmd>VenvSelect<cr>" },
	},
}

local live_multigrep = function(opts)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local make_entry = require("telescope.make_entry")
	local conf = require("telescope.config").values

	opts = opts or {}
	opts.cwd = opts.cwd or vim.fn.getcwd()

	local finder = finders.new_async_job({
		command_generator = function(prompt)
			if not prompt or prompt == "" then
				return nil
			end

			local pieces = vim.split(prompt, "  ")
			local args = { "rg" }
			if pieces[1] then
				table.insert(args, "-e")
				table.insert(args, pieces[1])
			end

			if pieces[2] then
				table.insert(args, "-g")
				table.insert(args, pieces[2])
			end

			return vim.iter({
				args,
				{ "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
			})
				:flatten()
				:totable()
		end,
		entry_maker = make_entry.gen_from_vimgrep(opts),
		cwd = opts.cwd,
	})

	pickers
		.new(opts, {
			debounce = 100,
			prompt_title = "Multi Grep",
			finder = finder,
			previewer = conf.grep_previewer(opts),
			sorter = require("telescope.sorters").empty(),
		})
		:find()
end

return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		cmd = "Telescope",
		keys = {
			-- find
			{
				"<leader>ff",
				"<cmd>Telescope find_files<cr>",
				desc = "Find files",
			},
			{
				"<leader>fd",
				"<cmd>Telescope file_browser hidden=true respect_gitignore=false<cr>",
				desc = "Open file browser",
			},
			{ "<leader>fa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<cr>", desc = "Find all" },
			{
				"<leader>fg",
				live_multigrep,
				desc = "Live grep",
			},
			{
				"<leader>fb",
				"<cmd>Telescope buffers<cr>",
				desc = "Find buffers",
			},
			{
				"<leader>fh",
				"<cmd>Telescope help_tags<cr>",
				desc = "Help page",
			},
			{
				"<leader>fo",
				"<cmd>Telescope oldfiles<cr>",
				desc = "Find oldfiles",
			},
			{
				"<leader>fz",
				"<cmd>Telescope current_buffer_fuzzy_find<cr>",
				desc = "Find in current buffer",
			},
			-- lsp
			{
				"<leader>jd",
				"<cmd>Telescope lsp_definitions<cr>",
				desc = "Jump to definition",
			},
			{
				"<leader>tr",
				"<cmd>Telescope lsp_references<cr>",
				desc = "Display references",
			},
			{
				"<leader>ic",
				"<cmd>Telescope lsp_incoming_calls<cr>",
				desc = "Display incoming calls",
			},
			{
				"<leader>oc",
				"<cmd>Telescope lsp_outgoing_calls<cr>",
				desc = "Display outgoing calls",
			},
			{
				"<leader>ds",
				"<cmd>Telescope lsp_document_symbols<cr>",
				desc = "Display document symbols",
			},
			{
				"<leader>ws",
				function()
					local telescope = require("telescope.builtin")
					telescope.lsp_workspace_symbols({ query = vim.fn.input("Query: ") })
				end,
				desc = "Display query workspace symbols",
			},
			{
				"<leader>di",
				"<cmd> Telescope diagnostics<cr>",
				desc = "Display diagnostic",
			},
			{
				"<leader>K",
				"<cmd>vsplit<bar>Telescope lsp_definitions<cr>",
				desc = "Open definition into vertical right split window",
			},
			-- git
			{
				"<leader>gb",
				"<cmd>Telescope git_branches<cr>",
				desc = "Git branches, select to checkout branch",
			},
			{
				"<leader>gs",
				"<cmd>Telescope git_status<cr>",
				desc = "Git status, select to jump to file",
			},
			{
				"<leader>gc",
				"<cmd>Telescope git_commits<cr>",
				desc = "Git commits, select to checkout commit",
			},
			{
				"<leader>gf",
				"<cmd>Telescope git_files<cr>",
				desc = "Display files tracked by git",
			},
			-- pick a hidden term
			{
				"<leader>ht",
				"<cmd>Telescope terms<cr>",
				desc = "Pick hidden term",
			},
			-- pick marks, type m followd by a letter to mark a line
			-- press '<char> to jump to <char> mark
			-- :marks to see all marks
			-- :delmarks! to delete all marks
			{ "<leader>ma", "<cmd>Telescope marks<cr>", desc = "Marks" },
			-- project
			{
				"<leader>p",
				"<cmd>Telescope projects<cr>",
				desc = "Pick project",
			},
			-- tmux
			{
				"<leader>tp",
				"<cmd>Telescope tmux pane_contents<cr>",
				desc = "Tmux pane content",
			},
			{
				"<leader>tw",
				"<cmd>Telescope tmux windows<cr>",
				desc = "Tmux windows",
			},
			{
				"<leader>ts",
				"<cmd>Telescope tmux sessions<cr>",
				desc = "Tmux sessions",
			},
		},
		opts = {
			extensions_list = { "fzf", "file_browser", "tmux", "projects" },
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
			defaults = {
				file_ignore_patterns = {
					"^node_modules/",
					"^android/",
					"^ios/",
					"^vendor/",
					"^build/",
					"^dist/",
					"^coverage/",
					"%.pyc$",
          "%.bin$",
          "/bin/",
          "^tmp/",
          "/tmp/"
				},
				mappings = {
					i = {
						["<C-x>"] = false, -- disables the default select_horizontal
						["<C-s>"] = require("telescope.actions").select_horizontal,
					},
					n = {
						["<C-x>"] = false, -- disables the default select_horizontal
						["<C-s>"] = require("telescope.actions").select_horizontal,
					},
				},
			},
		},

		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)

			for _, ext in ipairs(opts.extensions_list) do
				telescope.load_extension(ext)
			end
		end,
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
	{
		"camgraff/telescope-tmux.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "norcalli/nvim-terminal.lua" },
	},
}

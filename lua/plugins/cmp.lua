return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		{ "nvim-neotest/nvim-nio" },
		{
			-- snippet plugin
			"L3MON4D3/LuaSnip",
			dependencies = "rafamadriz/friendly-snippets",
			opts = { history = true, updateevents = "TextChanged,TextChangedI" },
			config = function(_, opts)
				require("luasnip").config.set_config(opts)
				-- vscode format
				require("luasnip.loaders.from_vscode").lazy_load({
					include = { "typescriptreact" },
				})
				require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.g.vscode_snippets_path or "" })
				-- snipmate format
				require("luasnip.loaders.from_snipmate").load()
				require("luasnip.loaders.from_snipmate").lazy_load({ paths = vim.g.snipmate_snippets_path or "" })
				-- lua format
				require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets" })

				-- -- ✅ Add this line to extend TS snippets to JS React files
				require("luasnip").filetype_extend("javascript", { "typescriptreact" })
				require("luasnip").filetype_extend("javascript", { "javascriptreact" })

				vim.api.nvim_create_autocmd("InsertLeave", {
					callback = function()
						if
							require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
							and not require("luasnip").session.jump_active
						then
							require("luasnip").unlink_current()
						end
					end,
				})
			end,
		},
		-- autopairing of (){}[] etc
		{
			"windwp/nvim-autopairs",
			opts = {
				fast_wrap = {},
				disable_filetype = { "TelescopePrompt", "vim" },
			},
			config = function(_, opts)
				require("nvim-autopairs").setup(opts)

				-- setup cmp for autopairs
				local cmp_autopairs = require("nvim-autopairs.completion.cmp")
				require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
			end,
		},

		-- cmp sources plugins
		{
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp",
			-- completion for buffer word
			"hrsh7th/cmp-buffer",
			-- completion for filesystem paths
			"hrsh7th/cmp-path",
			-- completion for commands
			{
				"hrsh7th/cmp-cmdline",
				config = function()
					local cmp = require("cmp")
					-- completion for command mode
					cmp.setup.cmdline(":", {
						mapping = cmp.mapping.preset.cmdline(),
						sources = cmp.config.sources({
							{ name = "path" },
						}, {
							{ name = "cmdline" },
						}),
					})
					-- completion for search mode
					cmp.setup.cmdline({ "/", "?" }, {
						mapping = cmp.mapping.preset.cmdline(),
						sources = {
							{ name = "buffer" },
						},
					})
				end,
			},
			"jc-doyle/cmp-pandoc-references",
			-- completion for debug mode
			{
				"rcarriga/cmp-dap",
				config = function()
					local cmp = require("cmp")
					cmp.setup({
						enabled = function()
							return vim.api.nvim_get_option_value("buftype", { buf = 0 }) ~= "prompt"
								or require("cmp_dap").is_dap_buffer()
						end,
					})
					cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
						sources = {
							{ name = "dap" },
						},
					})
				end,
			},
			-- -- to enable popupmenu-completion for copilot
			-- { "zbirenbaum/copilot-cmp", opts = {} },
		},
	},
	opts = function()
		local cmp = require("cmp")
		local border = require("utils").border
		local options = {
			completion = {
				completeopt = "menuone,noselect,noinsert",
			},
			window = {
				completion = {
					border = border("CmpBorder"),
					side_padding = 1,
					scrollbar = false,
				},
				documentation = {
					border = border("CmpDocBorder"),
					winhighlight = "Normal:CmpDoc",
				},
			},
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = {
				["<Up>"] = cmp.mapping.select_prev_item(),
				["<Down>"] = cmp.mapping.select_next_item(),
				["<C-d>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.close(),
				["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false }),
				["<Tab>"] = cmp.mapping(function(fallback)
					local cmp = require("cmp")
					local luasnip = require("luasnip")

					if cmp.visible() then
						-- Just select next suggestion (don't confirm)
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),

				["<S-Tab>"] = cmp.mapping(function(fallback)
					local cmp = require("cmp")
					local luasnip = require("luasnip")

					if cmp.visible() then
						-- Select previous suggestion
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp", priority = 1000 },
				{ name = "buffer", priority = 700 },
				{ name = "nvim_lua", priority = 600 },
				{ name = "path", priority = 500 },
				{ name = "luasnip", priority = 400 },
				{ name = "pandoc_references", priority = 300 },
				{ name = "copilot", priority = 200 },
			}),
			sorting = {
				priority_weight = 2,
				comparators = {
					cmp.config.compare.offset,
					cmp.config.compare.exact,
					cmp.config.compare.score,

					-- Prefer lower kind (Variable < Snippet)
					function(entry1, entry2)
						local kind1 = entry1:get_kind()
						local kind2 = entry2:get_kind()
						if kind1 ~= kind2 then
							return kind1 < kind2
						end
					end,

					cmp.config.compare.sort_text,
					cmp.config.compare.length,
					cmp.config.compare.order,
				},
			},
		}
		return options
	end,
}

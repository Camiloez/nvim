return {
	-- debug adapter protocol (dap) client
	{
		"mfussenegger/nvim-dap",
		keys = {
			{
				"<leader>db",
				function()
					vim.cmd("DapToggleBreakpoint")
				end,
				desc = "Create or remove debug breakpoint",
			},
			{
				"<leader>dc",
				function()
					vim.cmd("DapContinue")
				end,
				desc = "Start debug session or jump to next breakpoint",
			},
			{
				"<leader>dx",
				function()
					vim.cmd("DapTerminate")
				end,
				desc = "Terminate debug session",
			},
			{
				"<leader>dus",
				function()
					local widgets = require("dapui").widgets
					local sidebar = widgets.sidebar(widgets.scopes)
					sidebar.open()
				end,
				desc = "Open debugging sidebar",
			},
		},
	},
	-- nvim-dap UI
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.after.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.after.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},
	-- dap for python
	-- dap for python
	{
		"mfussenegger/nvim-dap-python",
		ft = { "python" },
		dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" },
		keys = { { "<leader>dt", desc = "Run test in debug" } },
config = function()
			local function get_python_path()
				-- 1. Check VIRTUAL_ENV
				if vim.env.VIRTUAL_ENV then
					return vim.env.VIRTUAL_ENV .. "/bin/python"
				end

				-- 2. Check for local .venv or venv directories
				local cwd = vim.fn.getcwd()
				for _, venv in ipairs({ ".venv", "venv" }) do
					local path = cwd .. "/" .. venv .. "/bin/python"
					if vim.fn.executable(path) == 1 then
						return path
					end
				end

				-- 3. Fallback to pyenv’s current global python
				return vim.fn.system("pyenv which python"):gsub("\n", "")
			end

			local dap = require("dap")
			local dap_python = require("dap-python")
			local python_path = get_python_path()

			-- setup dap-python with proper interpreter
			dap_python.setup(python_path, {})
			dap_python.test_runner = "pytest"

			-- test keymap
			vim.keymap.set("n", "<leader>dt", function()
				require("dap-python").test_method()
			end, { desc = "Run test in debug session" })

			-- run file keymap
			vim.keymap.set("n", "<leader>dr", function()
				dap.continue()
			end, { desc = "Run current Python file in debugger" })

			-- default configuration for running current file
			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Launch file",
					program = "${file}", -- current buffer
					pythonPath = get_python_path,
				},
			}
		end,
	},
	-- dap for go
	{
		"leoluz/nvim-dap-go",
		ft = "go",
		dependencies = "mfussenegger/nvim-dap",
		keys = { { "<leader>dt", desc = "Run test in debug" } },
		config = function()
			local dp = require("dap-go")
			dp.setup()

			vim.keymap.set("n", "<leader>dt", function()
				require("dap-go").debug_test()
			end, { desc = "Run go test" })
		end,
	},
}

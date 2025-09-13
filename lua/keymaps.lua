local keymaps = {
	i = {
		["<C-h>"] = { "<Left>", "Move left" },
		["<C-l>"] = { "<Right>", "Move right" },
		["<C-j>"] = { "<Down>", "Move down" },
		["<C-k>"] = { "<Up>", "Move up" },
	},
	n = {
		["<Esc>"] = { "<cmd> noh <CR>", "Clear highlights" },
		["<C-DOWN>"] = { "<cmd>resize -2<cr>", "Increase window height" },
		["<C-UP>"] = { "<cmd>resize +2<cr>", "Increase window height" },
		-- Splits
		["<leader>nh"] = { ":nohl<CR>", "Clear search highlights" },
		["<leader>sv"] = { "<C-w>v", "split window vertically" },
		["<leader>ss"] = { "<C-w>s", "split horizontally" },
		["<leader>sx"] = { "<cmd>close<CR>", "close current split" },
		-- Tabs
		["<leader>to"] = { "<cmd>tabnew<CR>", "open new tab" },
		["<leader>tx"] = { "<cmd>tabclose<CR>", "close current tab" },
	},
	v = {
		["J"] = { ":m '>+1<CR>gv=gv", "Move selected text one line down" },
		["K"] = { ":m '<-2<CR>gv=gv", "Move selected text one line up" },
	},
}

for mode, mappings in pairs(keymaps) do
	for key, mapping in pairs(mappings) do
		local action = mapping[1]
		local desc = mapping[2]
		vim.keymap.set(mode, key, action, { desc = desc })
	end
end

vim.keymap.set("n", "<C-a>", "<Esc>ggVG", { noremap = true, silent = true })
vim.keymap.set("i", "<C-a>", "<Esc>ggVG", { noremap = true, silent = true })

vim.keymap.set("i", "<S-Tab>", "<C-d>", { noremap = true, silent = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("i", "<fn><bs>", "<C-w>")

-- Indent text to the right using <Tab>
vim.keymap.set("v", "<Tab>", ">gv", { silent = true })

-- Indent text to the left using <S-Tab>
vim.keymap.set("v", "<S-Tab>", "<gv", { silent = true })

-- Normal mode
vim.keymap.set("n", "↑", ":m .-2<CR>==", { desc = "Option+Up", silent = true })
vim.keymap.set("n", "↓", ":m .+1<CR>==", { desc = "Option+Down", silent = true })

vim.keymap.set("n", "<leader>tt", function()
	require("telescope.builtin").grep_string(require("telescope.themes").get_ivy({
		prompt_title = "Incomplete Tasks",
		-- search = "- \\[ \\]", -- Fixed search term for tasks
		-- search = "^- \\[ \\]", -- Ensure "- [ ]" is at the beginning of the line
		search = "^\\s*- \\[ \\]", -- also match blank spaces at the beginning
		search_dirs = { vim.fn.getcwd() }, -- Restrict search to the current working directory
		use_regex = true, -- Enable regex for the search term
		initial_mode = "normal", -- Start in normal mode
		layout_config = {
			preview_width = 0.5, -- Adjust preview width
		},
		additional_args = function()
			return { "--no-ignore" } -- Include files ignored by .gitignore
		end,
	}))
end, { desc = "[P]Search for incomplete tasks" })

-- Iterate throuth completed tasks in telescope lamw25wmal
vim.keymap.set("n", "<leader>tc", function()
	require("telescope.builtin").grep_string(require("telescope.themes").get_ivy({
		prompt_title = "Completed Tasks",
		-- search = [[- \[x\] `done:]], -- Regex to match the text "`- [x] `done:"
		-- search = "^- \\[x\\] `done:", -- Matches lines starting with "- [x] `done:"
		search = "^\\s*- \\[x\\] `done:", -- also match blank spaces at the beginning
		search_dirs = { vim.fn.getcwd() }, -- Restrict search to the current working directory
		use_regex = true, -- Enable regex for the search term
		initial_mode = "normal", -- Start in normal mode
		layout_config = {
			preview_width = 0.5, -- Adjust preview width
		},
		additional_args = function()
			return { "--no-ignore" } -- Include files ignored by .gitignore
		end,
	}))
end, { desc = "[P]Search for completed tasks" })

vim.keymap.set({ "n", "i" }, "∑", function()
	-- Get the current line/row/column
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local row, _ = cursor_pos[1], cursor_pos[2]
	local line = vim.api.nvim_get_current_line()
	-- 1) If line is empty => replace it with "- [ ] " and set cursor after the brackets
	if line:match("^%s*$") then
		local final_line = "- [ ] "
		vim.api.nvim_set_current_line(final_line)
		-- "- [ ] " is 6 characters, so cursor col = 6 places you *after* that space
		vim.api.nvim_win_set_cursor(0, { row, 6 })
		return
	end
	-- 2) Check if line already has a bullet with possible indentation: e.g. "  - Something"
	--    We'll capture "  -" (including trailing spaces) as `bullet` plus the rest as `text`.
	local bullet, text = line:match("^([%s]*[-*]%s+)(.*)$")
	if bullet then
		-- Convert bullet => bullet .. "[ ] " .. text
		local final_line = bullet .. "[ ] " .. text
		vim.api.nvim_set_current_line(final_line)
		-- Place the cursor right after "[ ] "
		-- bullet length + "[ ] " is bullet_len + 4 characters,
		-- but bullet has trailing spaces, so #bullet includes those.
		local bullet_len = #bullet
		-- We want to land after the brackets (four characters: `[ ] `),
		-- so col = bullet_len + 4 (0-based).
		vim.api.nvim_win_set_cursor(0, { row, bullet_len + 4 })
		return
	end
	-- 3) If there's text, but no bullet => prepend "- [ ] "
	--    and place cursor after the brackets
	local final_line = "- [ ] " .. line
	vim.api.nvim_set_current_line(final_line)
	-- "- [ ] " is 6 characters
	vim.api.nvim_win_set_cursor(0, { row, 6 })
end, { desc = "Convert bullet to a task or insert new task bullet" })


vim.keymap.set("n", "µ", function()
  local label_done = "done:"
  local timestamp = os.date("%d-%m-%y %H:%M")

  local api = vim.api
  local buf = api.nvim_get_current_buf()
  local cursor_pos = api.nvim_win_get_cursor(0)
  local start_line = cursor_pos[1] - 1
  local lines = api.nvim_buf_get_lines(buf, 0, -1, false)
  local total_lines = #lines

  if start_line >= total_lines then return end

  while start_line > 0 do
    if lines[start_line + 1]:match("^%s*%- ") then
      break
    end
    start_line = start_line - 1
  end

  local line = lines[start_line + 1]
  if not line:match("^%s*%- %[[x ]%]") then
    print("Not a task bullet: no action taken.")
    return
  end

  local function insertLabel(line, label)
    local prefix = line:match("^(%s*%- %[[x ]%])")
    if not prefix then return line end
    local rest = line:sub(#prefix + 1):gsub("`.-`", ""):gsub("^%s+", "")
    return prefix .. " `" .. label .. "` " .. rest
  end

  local function removeLabel(line)
    return line:gsub("`.-`", ""):gsub("%s+", " ")
  end

  local function bulletToX(line)
    return line:gsub("^(%s*%- )%[%s*%]", "%1[x]")
  end

  local function bulletToBlank(line)
    return line:gsub("^(%s*%- )%[x%]", "%1[ ]")
  end

  local function isDone(line)
    return line:match("%[x%]") and line:match("`" .. label_done)
  end

  local current_section_start = nil
  local current_section_end = nil
  for i = start_line, 0, -1 do
    if lines[i + 1]:match("^#") then
      current_section_start = i
      break
    end
  end
  for i = start_line + 1, total_lines - 1 do
    if lines[i + 1]:match("^#") then
      current_section_end = i - 1
      break
    end
  end
  current_section_end = current_section_end or (total_lines - 1)

  local bullet_lines = {}
  for i = current_section_start + 1, current_section_end do
    if lines[i + 1]:match("^%s*%- %[[x ]%]") then
      table.insert(bullet_lines, i)
    end
  end

  local is_last_in_section = (#bullet_lines > 0) and (start_line == bullet_lines[#bullet_lines])
  local current_line = lines[start_line + 1]

  if isDone(current_line) then
    current_line = bulletToBlank(current_line)
    current_line = removeLabel(current_line)
    lines[start_line + 1] = current_line
  else
    current_line = bulletToX(current_line)
    current_line = removeLabel(current_line)
    current_line = insertLabel(current_line, label_done .. " " .. timestamp)

    if not is_last_in_section then
      table.remove(lines, start_line + 1)
      local insert_pos = bullet_lines[#bullet_lines]
      table.insert(lines, insert_pos + 1, current_line)
    else
      lines[start_line + 1] = current_line
    end
  end

  api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.cmd("silent update")
end, { desc = "Toggle task done/undone and manage position" })


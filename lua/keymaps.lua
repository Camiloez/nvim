local keymaps = {
  i = {
    ["<C-h>"] = { "<Left>", "Move left" },
    ["<C-l>"] = { "<Right>", "Move right" },
    ["<C-j>"] = { "<Down>", "Move down" },
    ["<C-k>"] = { "<Up>", "Move up" },
  },
  n = {
    ["<C-UP>"] = { "<cmd>resize -2<cr>", "Increase window height"},
    -- Splits
    ["<leader>nh"] = {":nohl<CR>", "Clear search highlights"},
    ["<leader>sv"] = {"<C-w>v", "split window vertically"},
    ["<leader>sh"] = {"<C-w>s", "split horizontally"},
    ["<leader>sx"] = {"<cmd>close<CR>", "close current split"},
    -- Tabs
    ["<leader>to"] = {"<cmd>tabnew<CR>", "open new tab"},
    ["<leader>tx"] = {"<cmd>tabclose<CR>", "close current tab"},
  }
}


for mode, mappings in pairs(keymaps) do
  for key, mapping in pairs(mappings) do
    local action = mapping[1]
    local desc = mapping[2]
    vim.keymap.set(mode, key, action, { desc = desc })
  end
end

local keymaps = {
  i = {
    ["<C-h>"] = { "<Left>", "Move left" },
    ["<C-l>"] = { "<Right>", "Move right" },
    ["<C-j>"] = { "<Down>", "Move down" },
    ["<C-k>"] = { "<Up>", "Move up" },
  },
  n = {
    ["<C-UP>"] = { "<cmd>resize -2<cr>", "Increase window height" },
    ["<C-DOWN>"] = { "<cmd>resize +2<cr>", "Increase window height" },
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
  }
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

vim.keymap.set('i', '<fn><bs>', '<C-w>')


-- Indent text to the right using <Tab>
vim.keymap.set("v", "<Tab>", ">gv", { silent = true })

-- Indent text to the left using <S-Tab>
vim.keymap.set("v", "<S-Tab>", "<gv", { silent = true })


-- Normal mode
vim.keymap.set("n", "↑", ":m .-2<CR>==", { desc = "Option+Up", silent = true })
vim.keymap.set("n", "↓", ":m .+1<CR>==", { desc = "Option+Down", silent = true })


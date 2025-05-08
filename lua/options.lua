local o = vim.o
local opt = vim.opt
local g = vim.g


-- space as leader
g.mapleader = " "

-- indenting
o.tabstop = 2
o.expandtab = true
o.softtabstop = 2
o.shiftwidth = 2
o.autoindent = true
o.clipboard = "unnamedplus"


-- disable nvim intro
opt.shortmess:append "sI"

-- numbers
o.relativenumber = true
o.number = true
o.numberwidth = 2
o.ruler = false

o.wrap = false

-- search settings
opt.ignorecase = true --ignore case when searching
opt.smartcase = true -- assume sensitive when using mixed

opt.cursorline = false

-- colors
opt.termguicolors = true
opt.background = 'dark'
opt.signcolumn = 'yes' -- shown sign column so text doesn't shift

-- backspace
opt.backspace = "indent,eol,start"


-- split windows
opt.splitright = true
opt.splitbelow = true

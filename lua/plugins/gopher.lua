return {
  "olexsmir/gopher.nvim",
  ft = "go",
  build = function()
    vim.cmd.GoInstallDeps()
  end,
  opts = {},
  config = function()
    vim.cmd([[
      xnoremap <silent> <leader>gj :<C-u>GoTagAdd json<CR>
    ]])
  end,
}

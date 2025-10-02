return {
  "nvimtools/none-ls.nvim",
  ft = { "lua", "python" },
  config = function()
    local null_ls = require "null-ls"
    local sources = {}
    if vim.g.pylsp then
      sources = {
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.diagnostics.mypy,
      }
    end
    table.insert(sources, null_ls.builtins.formatting.stylua)
    null_ls.setup { sources = sources }
  end,
}

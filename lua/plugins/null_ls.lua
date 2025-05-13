return {
  "nvimtools/none-ls.nvim",
  ft = { "lua", "python", "go" },
  config = function()
    local null_ls = require "null-ls"
    local sources = {}
    sources = {
      null_ls.builtins.formatting.black,
      null_ls.builtins.formatting.isort,
      null_ls.builtins.diagnostics.mypy,
      null_ls.builtins.formatting.gofumpt,
      null_ls.builtins.formatting.goimports,
    }

    table.insert(
      sources,
      null_ls.builtins.formatting.stylua
    )
    null_ls.setup { sources = sources }
  end,
}

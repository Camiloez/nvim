return {
  "nvim-treesitter/nvim-treesitter",
  cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "bash",
      "c",
      "css",
      "dockerfile",
      "go",
      "html",
      "javascript",
      "json",
      "latex",
      "lua",
      "python",
      "r",
      "rust",
      "scala",
      "sql",
      "terraform",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    },
    highlight = {
      enable = true,
      use_languagetree = true,
    },
    indent = { enable = true },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}

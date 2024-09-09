return {
  "akinsho/bufferline.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  init = function()
    local goto_buf = function(n)
      require("bufferline").go_to(n, true)
    end

    require("bufferline").setup({})

    vim.keymap.set("n", "<leader>1", function()
      goto_buf(1)
    end)

    vim.keymap.set("n", "<leader>2", function()
      goto_buf(2)
    end)

    vim.keymap.set("n", "<leader>3", function()
      goto_buf(3)
    end)

    vim.keymap.set("n", "<leader>4", function()
      goto_buf(4)
    end)

    vim.keymap.set("n", "<leader>5", function()
      goto_buf(5)
    end)

    vim.keymap.set("n", "<leader>6", function()
      goto_buf(6)
    end)

    vim.keymap.set("n", "<leader>7", function()
      goto_buf(7)
    end)

    vim.keymap.set("n", "<leader>8", function()
      goto_buf(8)
    end)

    vim.keymap.set("n", "<leader>9", function()
      goto_buf(-1)
    end)


    vim.keymap.set("n", "<Tab>", function ()
      vim.cmd "BufferLineCycleNext"
    end)

    vim.keymap.set("n", "<S-Tab>", function ()
      vim.cmd "BufferLineCyclePrev"
    end)

    vim.keymap.set("n", "<leader>x", ":bp<bar>sp<bar>bn<bar>bd<CR>")



  end,
}

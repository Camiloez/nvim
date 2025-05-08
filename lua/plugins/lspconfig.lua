return {
  "neovim/nvim-lspconfig",
  keys = {
    {
      "gD",
      function()
        vim.lsp.buf.declaration()
      end,
      { desc = "LSP declaration" },
    },
    {
      "gd",
      function()
        vim.lsp.buf.definition()
      end,
      { desc = "LSP definition" },
    },
    {
      "K",
      function()
        vim.lsp.buf.hover()
      end,
      { desc = "LSP hover" },
    },
    {
      "gi",
      function()
        vim.lsp.buf.implementation()
      end,
      { desc = "LSP implementation" },
    },
    {
      "<leader>ls",
      function()
        vim.lsp.buf.signature_help()
      end,
      { desc = "LSP signature help" },
    },
    {
      "<leader>D",
      function()
        vim.lsp.buf.type_definition()
      end,
      { desc = "LSP definition type" },
    },
    {
      "<leader>rn",
      function()
        vim.lsp.buf.rename()
      end,
      { desc = "LSP rename" },
    },
    {
      "<leader>ca",
      function()
        vim.lsp.buf.code_action()
      end,
      { "n", "v" },
      { desc = "LSP code action" },
    },
    {
      "gr",
      function()
        vim.lsp.buf.references()
      end,
      { desc = "LSP references" },
    },
    {
      "<leader>lf",
      function()
        vim.diagnostic.open_float { border = "rounded" }
      end,
      { desc = "Floating diagnostic" },
    },
    {
      "[d",
      function()
        vim.diagnostic.goto_prev { float = { border = "rounded" } }
      end,
      { desc = "Goto prev" },
    },
    {
      "]d",
      function()
        vim.diagnostic.goto_next { float = { border = "rounded" } }
      end,
      { desc = "Goto next" },
    },
    {
      "<leader>wa",
      function()
        vim.lsp.buf.add_workspace_folder()
      end,
      { desc = "Add workspace folder" },
    },
    {
      "<leader>wr",
      function()
        vim.lsp.buf.remove_workspace_folder()
      end,
      { desc = "Remove workspace folder" },
    },
    {
      "<leader>wl",
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      { desc = "List workspace folders" },
    },
    {
      "<leader>fm",
      function()
        vim.lsp.buf.format { async = true }
      end,
      { desc = "LSP formatting" },
    },
  },
  config = function()
    local lspconfig = require "lspconfig"

    local on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false

      if client.supports_method "textDocument/semanticTokens" then
        client.server_capabilities.semanticTokensProvider = nil
      end
    end

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    capabilities.textDocument.completion.completionItem = {
      documentationFormat = { "markdown", "plaintext" },
      snippetSupport = true,
      preselectSupport = true,
      insertReplaceSupport = true,
      labelDetailsSupport = true,
      deprecatedSupport = true,
      commitCharactersSupport = true,
      tagSupport = { valueSet = { 1 } },
      resolveSupport = {
        properties = {
          "documentation",
          "detail",
          "additionalTextEdits",
        },
      },
    }

    lspconfig.lua_ls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = { "lua" },
      on_init = function(client)
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          ---@diagnostic disable-next-line: undefined-global
          if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
            return
          end
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
              -- Depending on the usage, you might want to add additional paths here.
              -- "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            },
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
            -- library = vim.api.nvim_get_runtime_file("", true)
          },
        })
      end,
      settings = {
        Lua = {},
      },
    }

    local get_path = function(package)
      local path = lspconfig.util.path

      -- Use activated virtualenv
      if vim.env.VIRTUAL_ENV then
        return path.join(vim.env.VIRTUAL_ENV, "bin", package)
      end

      local status, workspace = pcall(vim.lsp.buf.list_workspace_folders()[1])
      if status then
        -- Find and use local virtualenv
        local match = vim.fn.glob(path.join(workspace, ".venv"))
        if match ~= "" then
          return path.join(match, "bin", package)
        end

        -- Find and use virtualenv via poetry in workspace directory
        match = vim.fn.glob(path.join(workspace, "poetry.lock"))
        if match ~= "" then
          local venv = vim.fn.trim(vim.fn.system "poetry env info -p")
          return path.join(venv, "bin", package)
        end
      end

      -- Fallback to system package
      local system_path = vim.fn.exepath(package)
      return system_path
    end

    local cmd_from_path = function(package)
      local path = get_path(package)
      if path ~= "" then
        return path
      end
      return package
    end

    ---@param package string
    ---@return boolean
    local is_package_in_pyproject = function(package)
      local path = lspconfig.util.path
      local match = vim.fn.glob(path.join(vim.fn.getcwd(), "pyproject.toml"))
      if match ~= "" then
        local f = assert(io.open(match, "r"))
        local content = f:read "*all"
        f:close()
        if string.find(content, package) then
          return true
        end
      end
      return false
    end

    local is_pyright = is_package_in_pyproject "pyright"
    local is_ruff = is_package_in_pyproject "ruff"

    if is_pyright then
      lspconfig.pyright.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { cmd_from_path "pyright-langserver", "--stdio" },
        filetypes = { "python" },
      }
    end
    if is_ruff then
      lspconfig.ruff.setup {
        cmd = { cmd_from_path "ruff", "server" },
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          client.server_capabilities.hoverProvider = false
          local bufopts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set("n", "<leader>fm", function()
            local buf_path = vim.api.nvim_buf_get_name(bufnr)
            vim.api.nvim_command("!" .. get_path "ruff" .. " format " .. buf_path)
            vim.api.nvim_command("!" .. get_path "ruff" .. " check " .. buf_path .. " --fix")
          end, bufopts)
        end,
        filetypes = { "python" },
      }
    end
    if not is_pyright and not is_ruff then
      lspconfig.pylsp.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "python" },
        cmd = { "pylsp" },
        settings = {
          pylsp = {
            configurationSources = { "flake8", "black", "isort", "mypy" },
            plugins = {
              pycodestyle = { enabled = false },
              flake8 = {
                enabled = true,
                ignore = { "E203", "W503" },
                max_line_length = 79,
              },
              isort = { enabled = true, profile = "black", multi_line_output = 3, line_length = 79 },
              black = { enabled = true, line_length = 79 },
            },
          },
        },
      }
      vim.g.pylsp = true
    end

    lspconfig.terraformls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = { "terraform" },
    }

    lspconfig.gopls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = { "go" },
    }

    lspconfig.sqls.setup {
      on_attach = function(client, bufnr)
        require("sqls").on_attach(client, bufnr)
      end,
    }
  end,
}
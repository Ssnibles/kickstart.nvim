return {
  -- Mason for managing language servers, formatters, and linters
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>pm", "<cmd>Mason<cr>", desc = "Mason (Package Manager)" } },
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
        border = "rounded",
      },
      -- This table lists all the tools to automatically install
      ensure_installed = {
        -- Language servers
        "lua-language-server",
        "gopls",
        "typescript-language-server",
        "clangd",
        "bash-language-server",
        "taplo",
        "marksman",
        "texlab",
        "eslint-lsp",
        "pyright",
        "rust-analyzer",
        "html-lsp",
        "css-lsp",
        "json-lsp",
        -- Formatters
        "stylua",
        "prettier",
        "gofumpt",
        "black",
        "isort",
        -- Linters
        "eslint_d",
        "shellcheck",
        "shfmt",
        "ruff",
      },
    },
    build = ":MasonUpdate",
    -- This sets up both Mason and Mason-Tool-Installer
    config = function(_, opts)
      require("mason").setup(opts)
      require("mason-tool-installer").setup(opts)
    end,
    -- Mason-Tool-Installer is a dependency to handle the auto-installation
    dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim" },
  },
  
  -- The core LSP configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "williamboman/mason.nvim",
      {
        "simrat39/symbols-outline.nvim",
        lazy = true,
        cmd = "SymbolsOutline",
        keys = { { "<leader>so", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
      },
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      -- LSP capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      
      -- Basic keymaps for all LSP servers
      local on_attach = function(client, bufnr)
        -- Disable semantic tokens for servers that Treesitter can handle better
        if client.name == "rust_analyzer" or client.name == "clangd" then
          client.server_capabilities.semanticTokensProvider = nil
        end
        
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, {
            buffer = bufnr,
            desc = "LSP: " .. desc,
            silent = true,
            noremap = true,
          })
        end
        
        -- Navigation
        map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
        map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
        map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
        map("n", "gr", vim.lsp.buf.references, "Goto References")
        map("n", "gi", vim.lsp.buf.implementation, "Goto Implementation")
        map("n", "gt", vim.lsp.buf.type_definition, "Goto Type Definition")
        map("n", "<leader>so", "<cmd>SymbolsOutline<cr>", "Symbols Outline")
        
        -- Code actions
        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
        map("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format Document")
        
        -- Diagnostics
        map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
        map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
        map("n", "<leader>cd", vim.diagnostic.open_float, "Show Diagnostic")
        map("n", "<leader>cq", vim.diagnostic.setloclist, "Diagnostics Quickfix")
        map("n", "<leader>x", vim.diagnostic.setqflist, "Diagnostics to Quickfix List")
        
        -- Inlay Hints
        if client.server_capabilities.inlayHintProvider then
          vim.keymap.set("n", "<leader>uh", function()
            vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0))
          end, { desc = "Toggle Inlay Hints", buffer = bufnr })
          -- Enable hints by default for supported servers
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
        
      end
      
      -- The main Mason-LSPconfig setup with handlers for specific servers
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls", "gopls", "ts_ls", "clangd", "bashls", "taplo", "marksman", "texlab",
          "eslint", "pyright", "rust_analyzer", "html", "cssls", "jsonls",
        },
        automatic_installation = false,
        handlers = {
          -- Default handler
          function(server_name)
            require("lspconfig")[server_name].setup({
              on_attach = on_attach,
              capabilities = capabilities,
            })
          end,
          
          -- Specific server configurations
          ["lua_ls"] = function()
            require("lspconfig").lua_ls.setup({
              on_attach = on_attach,
              capabilities = capabilities,
              settings = {
                Lua = {
                  runtime = { version = "LuaJIT" },
                  diagnostics = { globals = { "vim" } },
                  workspace = { library = { vim.env.VIMRUNTIME } },
                },
              },
            })
          end,
          
          ["gopls"] = function()
            require("lspconfig").gopls.setup({
              on_attach = on_attach,
              capabilities = capabilities,
              settings = {
                gopls = {
                  hints = {
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                  },
                },
              },
            })
          end,
          
          ["ts_ls"] = function()
            require("lspconfig").ts_ls.setup({
              on_attach = on_attach,
              capabilities = capabilities,
              settings = {
                javascript = { inlayHints = { includeInlayVariableTypeHints = true } },
                typescript = { inlayHints = { includeInlayVariableTypeHints = true } },
              },
            })
          end,
          
          ["rust_analyzer"] = function()
            require("lspconfig").rust_analyzer.setup({
              on_attach = on_attach,
              capabilities = capabilities,
              settings = {
                ["rust-analyzer"] = {
                  checkOnSave = { command = "clippy" },
                  inlayHints = {
                    bindingModeHints = { enable = false },
                    lifetimeElisionHints = { enable = "always", useParameterNames = false },
                    parameterHints = { enable = true },
                    typeHints = { enable = true },
                  },
                },
              },
            })
          end,
          
          ["clangd"] = function()
            require("lspconfig").clangd.setup({
              on_attach = on_attach,
              capabilities = capabilities,
              cmd = {
                "clangd", "--background-index", "--clang-tidy",
                "--header-insertion=iwyu", "--completion-style=detailed",
                "--function-arg-placeholders",
              },
              init_options = {
                inlayHints = {
                  parameterNames = true,
                  deducedTypes = true,
                },
              },
            })
          end,
          
        },
      })
    end,
  },
}

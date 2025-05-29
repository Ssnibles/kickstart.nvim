return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>pm", "<cmd>Mason<cr>", desc = "Mason (Package Manager)" } },
    build = ":MasonUpdate",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
        border = "rounded",
      },
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    cmd = { "MasonToolsInstall", "MasonToolsInstallSync" },
    dependencies = "williamboman/mason.nvim",
    opts = {
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
      auto_update = true,
      run_on_start = true,
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      -- Enhanced capabilities for blink.cmp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
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
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      -- Enhanced on_attach function
      local on_attach = function(client, bufnr)
        -- Disable semantic tokens if you prefer treesitter highlighting
        client.server_capabilities.semanticTokensProvider = nil

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

        -- Code actions
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
        map("n", "<leader>cf", function()
          vim.lsp.buf.format({ async = true })
        end, "Format Document")

        -- Diagnostics
        map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
        map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
        map("n", "<leader>cd", vim.diagnostic.open_float, "Show Diagnostic")
        map("n", "<leader>cq", vim.diagnostic.setloclist, "Diagnostics Quickfix")

        -- Workspace
        map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add Workspace Folder")
        map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove Workspace Folder")
        map("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "List Workspace Folders")

        -- Signature help
        map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")

        -- Document highlight
        if client.server_capabilities.documentHighlightProvider then
          local group = vim.api.nvim_create_augroup("LSPDocumentHighlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr,
            group = group,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd("CursorMoved", {
            buffer = bufnr,
            group = group,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end

      -- Common setup configuration
      local common_setup = {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150,
        },
      }

      -- Mason LSP configuration with enhanced server configs
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "gopls",
          "ts_ls",
          "clangd",
          "bashls",
          "taplo",
          "marksman",
          "texlab",
          "eslint",
          "pyright",
          "rust_analyzer",
          "html",
          "cssls",
          "jsonls",
        },
        automatic_installation = false,
        handlers = {
          -- Default handler for all servers
          function(server_name)
            require("lspconfig")[server_name].setup(common_setup)
          end,

          -- Lua configuration
          ["lua_ls"] = function()
            require("lspconfig").lua_ls.setup(vim.tbl_deep_extend("force", common_setup, {
              settings = {
                Lua = {
                  runtime = { version = "LuaJIT" },
                  diagnostics = {
                    globals = { "vim" },
                    disable = { "missing-fields" },
                  },
                  workspace = {
                    checkThirdParty = false,
                    library = {
                      vim.env.VIMRUNTIME,
                      "${3rd}/luv/library",
                    },
                  },
                  telemetry = { enable = false },
                  hint = { enable = true },
                  completion = { callSnippet = "Replace" },
                },
              },
            }))
          end,

          -- Go configuration
          ["gopls"] = function()
            require("lspconfig").gopls.setup(vim.tbl_deep_extend("force", common_setup, {
              settings = {
                gopls = {
                  analyses = {
                    unusedparams = true,
                    shadow = true,
                  },
                  staticcheck = true,
                  gofumpt = true,
                  hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                  },
                },
              },
            }))
          end,

          -- TypeScript configuration
          ["ts_ls"] = function()
            require("lspconfig").ts_ls.setup(vim.tbl_deep_extend("force", common_setup, {
              root_dir = require("lspconfig.util").root_pattern("package.json", "tsconfig.json", ".git"),
              settings = {
                completions = { completeFunctionCalls = true },
                typescript = {
                  inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                  },
                },
                javascript = {
                  inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                  },
                },
              },
            }))
          end,

          -- Python configuration
          ["pyright"] = function()
            require("lspconfig").pyright.setup(vim.tbl_deep_extend("force", common_setup, {
              settings = {
                python = {
                  analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    -- diagnosticMode = "workspace",
                  },
                },
              },
            }))
          end,

          -- Rust configuration
          ["rust_analyzer"] = function()
            require("lspconfig").rust_analyzer.setup(vim.tbl_deep_extend("force", common_setup, {
              settings = {
                ["rust-analyzer"] = {
                  cargo = { allFeatures = true },
                  checkOnSave = {
                    command = "clippy",
                    extraArgs = { "--no-deps" },
                  },
                  procMacro = { enable = true },
                  inlayHints = {
                    bindingModeHints = { enable = false },
                    chainingHints = { enable = true },
                    closingBraceHints = { enable = true, minLines = 25 },
                    closureReturnTypeHints = { enable = "never" },
                    lifetimeElisionHints = { enable = "never", useParameterNames = false },
                    maxLength = 25,
                    parameterHints = { enable = true },
                    reborrowHints = { enable = "never" },
                    renderColons = true,
                    typeHints = { enable = true, hideClosureInitialization = false, hideNamedConstructor = false },
                  },
                },
              },
            }))
          end,

          -- C/C++ configuration
          ["clangd"] = function()
            require("lspconfig").clangd.setup(vim.tbl_deep_extend("force", common_setup, {
              cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--header-insertion=iwyu",
                "--completion-style=detailed",
                "--function-arg-placeholders",
                "--fallback-style=llvm",
              },
              init_options = {
                usePlaceholders = true,
                completeUnimported = true,
                clangdFileStatus = true,
              },
            }))
          end,

          -- JSON configuration
          ["jsonls"] = function()
            require("lspconfig").jsonls.setup(vim.tbl_deep_extend("force", common_setup, {
              settings = {
                json = {
                  schemas = require("schemastore").json.schemas(),
                  validate = { enable = true },
                },
              },
            }))
          end,

          -- ESLint configuration
          ["eslint"] = function()
            require("lspconfig").eslint.setup(vim.tbl_deep_extend("force", common_setup, {
              settings = {
                codeAction = {
                  disableRuleComment = {
                    enable = true,
                    location = "separateLine",
                  },
                  showDocumentation = {
                    enable = true,
                  },
                },
                codeActionOnSave = {
                  enable = false,
                  mode = "all",
                },
                experimental = {
                  useFlatConfig = false,
                },
                format = true,
                nodePath = "",
                onIgnoredFiles = "off",
                packageManager = "npm",
                problems = {
                  shortenToSingleLine = false,
                },
                quiet = false,
                rulesCustomizations = {},
                run = "onType",
                useESLintClass = false,
                validate = "on",
                workingDirectory = {
                  mode = "location",
                },
              },
            }))
          end,
        },
      })
    end,
  },
}

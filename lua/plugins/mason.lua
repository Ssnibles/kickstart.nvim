return {
  -- Mason package manager
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>pm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- Mason LSP bridge
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "bashls",
        "clangd",
        "cssls",
        "dockerls",
        "eslint",
        "gopls",
        "html",
        "jsonls",
        "lua_ls",
        "marksman",
        "pyright",
        "rust_analyzer",
        "taplo",
        "texlab",
        "ts_ls",
        "yamlls",
        "vimls",
        "jdtls",
        "lemminx",
        "sqlls",
        "cmake",
        "powershell_es",
        "pylsp",
      },
      automatic_installation = true,
    },
  },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "b0o/schemastore.nvim",
    },
    config = function()
      -- Custom diagnostic signs
      local signs = { Error = "", Warn = "", Hint = "󰌵", Info = "" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- Completely disable semantic tokens to prevent errors
      vim.lsp.handlers["textDocument/semanticTokens/full"] = function() end
      vim.lsp.handlers["textDocument/semanticTokens/full/delta"] = function() end

      -- LSP keymaps and helpers
      local function on_attach(client, bufnr)
        -- Prefer treesitter for highlighting - disable semantic tokens
        client.server_capabilities.semanticTokensProvider = nil

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "gd", vim.lsp.buf.definition, "Go to definition")
        map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        map("n", "gr", vim.lsp.buf.references, "Go to references")
        map("n", "gI", vim.lsp.buf.implementation, "Go to implementation")
        map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
        map("n", "K", vim.lsp.buf.hover, "Hover documentation")
        map("n", "gK", vim.lsp.buf.signature_help, "Signature help")
        map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
        map({ "n", "v" }, "<leader>cf", vim.lsp.buf.format, "Format")
        map("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
        map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
        map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")

        if client.server_capabilities.documentHighlightProvider then
          local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr,
            group = group,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "BufLeave" }, {
            buffer = bufnr,
            group = group,
            callback = vim.lsp.buf.clear_references,
          })
        end

        if client.server_capabilities.inlayHintProvider then
          -- Auto-enable inlay hints when a buffer with an LSP is attached
          vim.lsp.inlay_hint.enable(true)

          map("n", "<leader>ch", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, "Toggle inlay hints")
        end
      end

      -- Additional semantic token cleanup autocmd
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client then
            client.server_capabilities.semanticTokensProvider = nil
          end
        end,
      })

      -- Per-server config made easy to extend
      local lsp_servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                library = { "${3rd}/luv/library", unpack(vim.api.nvim_get_runtime_file("", true)) },
              },
              completion = { callSnippet = "Replace" },
              telemetry = { enable = false },
              hint = { enable = true },
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                generate = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-node_modules" },
              semanticTokens = false, -- Explicitly disable for gopls
            },
          },
        },
        ts_ls = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
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
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "basic",
              },
            },
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true, loadOutDirsFromCheck = true, runBuildScripts = true },
              checkOnSave = { allFeatures = true, command = "clippy", extraArgs = { "--no-deps" } },
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
              format = { enable = true },
              validate = true,
              schemaStore = { enable = true },
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        },
        cmake = {},
        bashls = {},
        cssls = {},
        dockerls = {},
        html = {},
        marksman = {},
        taplo = {},
        texlab = {},
        jdtls = {},
        lemminx = {},
        sqlls = {},
        powershell_es = {},
        vimls = {},
        pylsp = {},
        eslint = {
          settings = {
            codeActionOnSave = { enable = true, mode = "all" },
            format = true,
            nodePath = "",
            quiet = false,
            rulesCustomizations = {},
            run = "onType",
            validate = "on",
            experimental = { useFlatConfig = false },
          },
        },
        clangd = {
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
        },
      }

      -- Setup all servers in Mason's ensure_installed list
      local ensure_installed = require("mason-lspconfig.settings").current.ensure_installed or {}
      for _, name in ipairs(ensure_installed) do
        local config = lsp_servers[name] or {}
        require("lspconfig")[name].setup(vim.tbl_deep_extend("force", config, { on_attach = on_attach }))
      end
    end,
  },
}

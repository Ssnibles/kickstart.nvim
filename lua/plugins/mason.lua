return {
  -- Mason (on-demand UI)
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

  -- Bridge Mason ↔ LSP (ensure-install only)
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

  -- LSP config (single place for on_attach/caps/servers)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "b0o/schemastore.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")

      -- Prefer Blink’s LSP capabilities if available; fall back to defaults
      local ok_blink, blink = pcall(require, "blink.cmp")
      local capabilities = ok_blink and blink.get_lsp_capabilities() or vim.lsp.protocol.make_client_capabilities()

      -- Disable semantic tokens once for all servers (cleaner than per-server edits)
      require("lspconfig").util.default_config.on_init = function(client, _)
        client.server_capabilities.semanticTokensProvider = nil
      end

      -- Diagnostics are already styled globally via vim.diagnostic.config; no sign_define here
      -- Keymaps and helpers on attach
      local function on_attach(client, bufnr)
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "gd", vim.lsp.buf.definition, "Go to definition")
        map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        map("n", "gr", vim.lsp.buf.references, "Go to references")
        map("n", "gI", vim.lsp.buf.implementation, "Go to implementation")
        map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
        map("n", "K", vim.lsp.buf.hover, "Hover docs")
        map("n", "gK", vim.lsp.buf.signature_help, "Signature help")
        map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
        map("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
        map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
        map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")

        -- Inlay hints (Neovim 0.10+)
        if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          vim.lsp.inlay_hint.enable(true)
          map("n", "<leader>ch", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, "Toggle inlay hints")
        end

        -- Lightweight document highlight if the server supports it
        if client.server_capabilities.documentHighlightProvider then
          local grp = vim.api.nvim_create_augroup("LspDocHL" .. bufnr, { clear = true })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr,
            group = grp,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "BufLeave" }, {
            buffer = bufnr,
            group = grp,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end

      -- Per-server settings (small, focused)
      local servers = {
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
              codelenses = { generate = true, test = true, tidy = true, upgrade_dependency = true },
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
              semanticTokens = false,
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

        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
              format = { enable = true },
              validate = true,
              schemaStore = {
                enable = false, -- use SchemaStore.nvim instead
                url = "", -- avoid upstream fetch when disabled
              },
              schemas = require("schemastore").yaml.schemas(),
            },
          },
          -- optional folding capability for yamlls if desired:
          -- capabilities = {
          --   textDocument = { foldingRange = { dynamicRegistration = false, lineFoldingOnly = true } },
          -- },
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

        eslint = {
          settings = {
            codeActionOnSave = { enable = true, mode = "all" },
            format = true, -- Conform will still take precedence for JS/TS via external formatters
            run = "onType",
            validate = "on",
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

        -- Lightweight servers without extra settings
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
      }

      -- Setup listed servers with shared on_attach/capabilities
      for name, cfg in pairs(servers) do
        cfg.on_attach = on_attach
        cfg.capabilities = vim.tbl_deep_extend("force", capabilities, cfg.capabilities or {})
        lspconfig[name].setup(cfg)
      end
    end,
  },
}

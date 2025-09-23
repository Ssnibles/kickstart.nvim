return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = "ConformInfo",
  dependencies = {
    "williamboman/mason.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },

  -- Format file or selection (same opts as on save)
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true })
      end,
      mode = { "n", "v" },
      desc = "Format file/range",
    },
  },

  opts = {
    -- Prefer "prettierd" when available (then stop), fall back to "prettier"
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      json = { "prettierd", "prettier", stop_after_first = true },
      markdown = { "prettierd", "prettier", stop_after_first = true },
      html = { "prettierd", "prettier", stop_after_first = true },
      css = { "prettierd", "prettier", stop_after_first = true },
    },

    -- Use LSP formatting when no external formatter is configured/installed
    default_format_opts = { lsp_format = "fallback" },

    -- Built-in on-save helper (values are passed to conform.format)
    format_on_save = { timeout_ms = 500 },

    -- Per-formatter extra flags
    formatters = {
      stylua = { prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" } },
      black = { prepend_args = { "--line-length", "100" } },
      prettier = { prepend_args = { "--prose-wrap", "always" } },
      prettierd = { prepend_args = { "--prose-wrap", "always" } },
    },

    notify_on_error = true,
  },

  config = function(_, opts)
    require("conform").setup(opts)
    require("mason-tool-installer").setup({
      ensure_installed = {
        "stylua",
        "isort",
        "black",
        "prettier",
        "prettierd",
      },
      auto_update = true,
    })
  end,
}

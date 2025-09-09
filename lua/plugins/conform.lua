return {
  "stevearc/conform.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true })
      end,
      desc = "Format buffer",
    },
  },
  opts = {
    -- Filetype to formatter mapping
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      json = { "prettier" },
      markdown = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      -- Add more filetype mappings here as needed
    },
    -- Format on save with timeout and LSP fallback
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
    -- Fine-tuning formatter arguments
    formatters = {
      stylua = {
        prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
      },
      black = {
        prepend_args = { "--line-length", "100" },
      },
      prettier = {
        prepend_args = { "--prose-wrap", "always" },
      },
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
        -- Add more formatter names here as needed
      },
      auto_update = true,
    })
  end,
}

return {
  "stevearc/conform.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "ConformInfo" },
  -- Keybindings for manual formatting.
  keys = {
    {
      "<leader>cf",
      function()
        -- Format the current buffer asynchronously.
        require("conform").format({ async = true })
      end,
      desc = "Format buffer",
    },
  },
  -- Main configuration for conform.nvim.
  opts = {
    -- Define formatters to use for specific filetypes.
    -- This table is a basic starting point. Add more formatters as needed.
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      json = { "prettier" }, -- Using prettier for JSON is often simpler than jq
      markdown = { "prettier" }, -- Using prettier is a common choice for Markdown
      html = { "prettier" },
      css = { "prettier" },
    },
    -- Configuration for automatic formatting on save.
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
    -- Custom formatter configurations.
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
    -- Show a notification if formatting fails.
    notify_on_error = true,
  },
  -- This function is called after the plugin is loaded.
  config = function(_, opts)
    require("conform").setup(opts)

    -- A simplified way to ensure your formatters are installed.
    -- Simply add the name of any formatter you want to use to this list.
    require("mason-tool-installer").setup({
      ensure_installed = {
        "stylua",
        "isort",
        "black",
        "prettier",
        -- Add other formatters here as you expand your configuration, e.g.:
        -- "shfmt",
        -- "gofumpt",
      },
      auto_update = true,
    })
  end,
}

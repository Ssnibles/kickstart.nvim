return {
  "stevearc/conform.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  event = { "BufReadPre", "BufNewFile" },
  cmd = "ConformInfo",
  -- Keybindings for manual formatting.
  keys = {
    {
      "<leader>cf",
      function()
        -- Format the current buffer asynchronously.
        -- 'async = true' prevents Neovim from freezing during formatting, improving responsiveness.
        require("conform").format({ async = true })
      end,
      desc = "Format buffer", -- Description shown in which-key or similar plugins
    },
  },
  -- Configuration options for conform.nvim.
  opts = {
    -- Define formatters to use for specific filetypes.
    -- The order matters: formatters are applied sequentially.
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" }, -- isort for imports, black for code style
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      json = { "jq" },
      yaml = { "yamlfmt" },
      markdown = { "markdownlint" },
      html = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      sh = { "shfmt" },
      go = { "gofumpt", "goimports" }, -- gofumpt for formatting, goimports for import organization
      rust = { "rustfmt" },
      ruby = { "rubyfmt" },
      php = { "php-cs-fixer" },
      java = { "google-java-format" },
      kotlin = { "ktlint" },
      c = { "clang-format" },
      cpp = { "clang-format" },
      -- zig = { "zigfmt" }, -- Uncomment if you use Zig and have zigfmt installed via Mason
      sql = { "sqlfmt" },
      toml = { "taplo" },
      svelte = { "prettier" },
    },
    -- Configuration for automatic formatting on save.
    format_on_save = {
      timeout_ms = 500, -- Maximum time (in ms) to wait for formatters to complete.
      lsp_fallback = true, -- Fallback to LSP formatting if no Conform formatter is found.
    },
    -- Custom formatter configurations, allowing specific arguments to be passed.
    formatters = {
      stylua = {
        prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" }, -- Enforce 2-space indentation
      },
      black = {
        prepend_args = { "--line-length", "100", "--fast" }, -- Set line length to 100 and use fast mode
      },
      shfmt = {
        prepend_args = { "-i", "2" }, -- Set shell script indentation to 2 spaces
      },
      prettier = {
        prepend_args = { "--prose-wrap", "always" }, -- Wrap prose in markdown files
      },
      ast_grep = {
        command = "sg", -- Command to execute ast-grep
        -- Arguments for ast-grep, pointing to a rules file and updating in place.
        -- This assumes 'ast-grep-rules.yml' is in your Neovim config directory.
        args = { "scan", "-r", "~/.config/ast-grep-rules.yml", "--update-all", "$FILENAME" },
        stdin = false, -- ast-grep typically reads from a file, not stdin for this use case
      },
    },
    notify_on_error = true, -- Show a notification if formatting fails
  },
  -- Main configuration function, executed when the plugin is loaded.
  config = function(_, opts)
    -- Apply the defined options to conform.nvim.
    require("conform").setup(opts)

    -- Collect all unique formatters specified in 'formatters_by_ft' to ensure they are installed.
    local formatters = {}
    for _, ft_formatters in pairs(opts.formatters_by_ft) do
      for _, formatter in ipairs(ft_formatters) do
        formatters[formatter] = true
      end
    end

    -- Convert the table of unique formatters into a list.
    local ensure_installed = vim.tbl_keys(formatters)
    -- Manually add "ast-grep" to the list of tools to be installed,
    -- as it might not be directly linked to a filetype in 'formatters_by_ft'.
    table.insert(ensure_installed, "ast-grep")

    -- Set up mason-tool-installer to manage the required formatters.
    require("mason-tool-installer").setup({
      ensure_installed = ensure_installed, -- List of tools to guarantee installation
      auto_update = true, -- Automatically update installed tools
      run_on_start = true, -- Run tool installation/update when Neovim starts
    })
  end,
}

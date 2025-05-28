return {
  "ray-x/go.nvim",
  dependencies = {
    "neovim/nvim-lspconfig", -- Only keeping essential dependencies
    "nvim-treesitter/nvim-treesitter",
  },
  ft = { "go", "gomod" },
  opts = {
    lsp_keymaps = false, -- Disable default keymaps
    lsp_cfg = false, -- We'll configure manually
    lsp_format_on_save = true,
    formatter = "gofumpt",
    diagnostic = false, -- Disable the diagnostics from go.nvim
  },
  config = function(_, opts)
    require("go").setup(opts)

    -- Minimal LSP setup focused on inlay hints
    require("lspconfig").gopls.setup({
      settings = {
        gopls = {
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
          analyses = {
            unusedparams = true,
          },
          staticcheck = true,
          gofumpt = true,
        },
      },
    })
  end,
}

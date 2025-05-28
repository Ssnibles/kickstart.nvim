return {
  {
    "sphamba/smear-cursor.nvim",
    enabled = not vim.g.neovide,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      scroll_buffer_space = true,
      legacy_computing_symbols_support = false,
      smear_insert_mode = true,
    },
  },
  {
    "karb94/neoscroll.nvim",
    enabled = not vim.g.neovide,
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "luukvbaal/statuscol.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      relculright = true,
    },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy", -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    opts = {
      options = {
        use_icons_from_diagnostic = true,
        multilines = { enabled = true }, -- Show on all lines
      },
    },
  },
  {
    "chrisgrieser/nvim-lsp-endhints",
    event = "LspAttach",
    opts = {}, -- required, even if empty
    config = function()
      -- default settings
      require("lsp-endhints").setup({
        icons = {
          type = "󰜁 ",
          parameter = "󰏪 ",
          offspec = " ", -- hint kind not defined in official LSP spec
          unknown = " ", -- hint kind is nil
        },
        label = {
          truncateAtChars = 20,
          padding = 1,
          marginLeft = 0,
          sameKindSeparator = ", ",
        },
        extmark = {
          priority = 50,
        },
        autoEnableHints = true,
      })
    end,
  },
}

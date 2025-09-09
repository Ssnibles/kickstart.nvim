return {
  {
    "luukvbaal/statuscol.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      relculright = true, -- Relative numbers on the right (modern look)
    },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    opts = {
      options = {
        use_icons_from_diagnostic = true, -- Use LSP diagnostic icons
        multilines = { enabled = true }, -- Show on all lines with diagnostics
      },
    },
  },
  {
    "j-hui/fidget.nvim",
    lazy = false, -- Load on startup for instant LSP feedback
    opts = {
      notification = {
        override_vim_notify = true,
        window = {
          normal_hl = "Comment",
          winblend = 100,
          border = "none",
          zindex = 45,
          max_width = 0,
          max_height = 0,
          x_padding = 1,
          y_padding = 0,
          align = "bottom",
          relative = "editor",
        },
      },
      progress = {
        suppress_on_insert = true,
        ignore_done_already = true,
      },
    },
    integration = {
      ["nvim-tree"] = { enable = true },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = {},
  },
}

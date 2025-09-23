return {
  -- Status column with right-aligned relative numbers
  {
    "luukvbaal/statuscol.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      relculright = true, -- right-align current line number with relativenumber
    },
  },

  -- Compact inline diagnostics; disable default virtual_text
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    opts = {
      preset = "modern",
      hi = {
        background = "CursorLine", -- subtle row background
        mixing_color = "Normal", -- blend with theme background
      },
      options = {
        use_icons_from_diagnostic = true,
        multilines = { enabled = true, always_show = false },
        enable_on_insert = false,
        throttle = 20,
      },
    },
    config = function(_, opts)
      require("tiny-inline-diagnostic").setup(opts)
      vim.diagnostic.config({ virtual_text = false }) -- avoid duplicate inline text
    end,
  },

  -- LSP progress + notifications; unobtrusive, no dark backdrop
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      notification = {
        override_vim_notify = true,
        window = {
          border = "none",
          winblend = 0, -- solid; no dim/alpha
          zindex = 45,
          align = "bottom",
          relative = "editor",
        },
      },
      progress = {
        suppress_on_insert = true,
        ignore_done_already = true,
      },
    },
  },

  -- Sticky Treesitter context with a clean separator
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = {
      max_lines = 3,
      multiline_threshold = 1,
      trim_scope = "inner",
      mode = "cursor",
      separator = "─",
      zindex = 20,
    },
    config = function(_, opts)
      require("treesitter-context").setup(opts)
      -- Link to float styling so it matches the theme
      vim.api.nvim_set_hl(0, "TreesitterContext", { link = "NormalFloat" })
      vim.api.nvim_set_hl(0, "TreesitterContextSeparator", { link = "FloatBorder" })
    end,
  },
}

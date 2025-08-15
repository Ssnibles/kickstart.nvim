return {
  {
    "luukvbaal/statuscol.nvim",
    event = { "BufReadPre", "BufNewFile" }, -- Load before reading/creating a buffer
    lazy = true,
    opts = {
      relculright = true, -- Show relative line numbers on the right
    },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = { "LspAttach" }, -- Load when Neovim is mostly idle and ready for user interaction
    priority = 1000, -- Needs to load early to capture diagnostics
    opts = {
      options = {
        use_icons_from_diagnostic = true,
        multilines = { enabled = true }, -- Show on all lines
      },
    },
  },
    {
    "j-hui/fidget.nvim",
    lazy = false, -- Load on startup for immediate LSP feedback
    opts = {
      -- Notification configuration
      notification = {
        override_vim_notify = true,
        window = {
          normal_hl = "Comment", -- Base highlight group in the notification window
          winblend = 100, -- Background color opacity (0-100)
          border = "none", -- Border around the notification window
          zindex = 45, -- Stacking priority
          max_width = 0, -- Auto width
          max_height = 0, -- Auto height
          x_padding = 1, -- Padding from right edge
          y_padding = 0, -- Padding from bottom edge
          align = "bottom", -- Align to bottom right
          relative = "editor", -- Position relative to the editor window
        },
      },
      -- Progress configuration
      progress = {
        suppress_on_insert = true, -- Hide progress while in insert mode
        ignore_done_already = true, -- Don't show progress that's already completed
      },
    },
    integration = {
      ["nvim-tree"] = {
        enable = true, -- Enable integration with nvim-tree if you use it
      },
    },
  },
 {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost", -- Load after a buffer is read
    lazy = true, -- Explicitly mark as lazy-loaded
    opts = {}, -- Keep options empty for default behavior
  }
}

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

  -- TODO: Make this shit better

  -- LSP progress and notifications
  {
    "j-hui/fidget.nvim",
    lazy = false,
    opts = {
      -- Notification configuration
      notification = {
        override_vim_notify = true,
        window = {
          normal_hl = "Comment", -- Base highlight group in the notification window
          winblend = 100, -- Background color opacity in the notification window
          border = "none", -- Border around the notification window
          zindex = 45, -- Stacking priority of the notification window
          max_width = 0, -- Maximum width of the notification window
          max_height = 0, -- Maximum height of the notification window
          x_padding = 1, -- Padding from right edge of window boundary
          y_padding = 0, -- Padding from bottom edge of window boundary
          align = "bottom", -- How to align the notification window
          relative = "editor", -- What the notification window position is relative to
        },
      },
      -- Progress configuration
      progress = {
        suppress_on_insert = true, -- hide progress while in insert mode
        ignore_done_already = true, -- ignore progress already done
      },
    },
    integration = {
      ["nvim-tree"] = {
        enable = true,
      },
    },
  },

  -- File path in winbar (disabled by default)
  {
    "b0o/incline.nvim",
    -- enabled = false,
    event = "BufReadPost",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      window = {
        margin = { horizontal = 0, vertical = 0 },
        placement = { horizontal = "right", vertical = "top" },
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        if filename == "" then
          filename = "[No Name]"
        end

        local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
        local modified = vim.bo[props.buf].modified

        return {
          ft_icon and { " ", ft_icon, " ", guifg = ft_color } or "",
          { filename, gui = modified and "bold,italic" or "bold" },
          modified and { " " } or "",
        }
      end,
    },
  },
}

return {
  "nvim-lualine/lualine.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      icons_enabled = true,
      theme = "auto", -- Use auto theme for colors
      component_separators = "", -- No component separators for a smoother "bubble" look
      -- Rounded section dividers for the "bubbles" effect
      section_separators = { left = "", right = "" },
      disabled_filetypes = {
        statusline = {
          "alpha",
          "dashboard",
          "NvimTree",
          "neo-tree",
          "snacks_dashboard",
          "snacks_picker_input",
          "fzf",
          "toggleterm",
        },
        winbar = {},
      },
      globalstatus = true,
      refresh = { statusline = 100 },
    },
    sections = {
      lualine_a = {
        {
          "mode",
          -- Add a right separator for the bubble effect on the mode
          right_padding = 2,
          separator = { left = "" },
        },
        -- Display recording status if active
        {
          function()
            local recording_reg = vim.fn.reg_recording()
            if recording_reg ~= "" then
              return " REC " .. recording_reg
            end
            return ""
          end,
          -- Remove explicit color, let theme handle it.
          -- You could add a 'gui = "bold"' here if you want it bold regardless of theme.
        },
      },
      lualine_b = {
        "branch",
        -- Git diff status with custom symbols and colors (colors will be theme-dependent)
        {
          "diff",
          symbols = { added = " ", modified = " ", removed = " " },
          colored = true,
        },
      },
      lualine_c = {
        -- Filename with relative path and clean symbols
        {
          "filename",
          -- path = 1, -- Show relative path
          symbols = {
            modified = "",
            readonly = " ",
            unnamed = "[No Name]",
          },
        },
        -- Diagnostics with custom symbols and colors (colors will be theme-dependent)
        {
          "diagnostics",
          sources = { "nvim_diagnostic" },
          symbols = { error = " ", warn = " ", info = " ", hint = " " },
          colored = true,
          update_in_insert = false,
        },
      },
      lualine_x = {
        -- LSP client count with an icon
        "lsp_status",
        "filetype",
      },
      lualine_y = { "progress" },
      lualine_z = {
        {
          "location",
          -- Add a left separator for the bubble effect on the location
          left_padding = 2,
          separator = { right = "" },
        },
      },
    },
    inactive_sections = {
      lualine_a = {}, -- Inactive mode section can be empty
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    extensions = { "nvim-tree" },
  },
}

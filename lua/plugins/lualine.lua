return {
  "nvim-lualine/lualine.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = { left = "│", right = "│" }, -- Thin vertical separators
      section_separators = { left = "", right = "" }, -- Rounded section dividers
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
          -- fmt = function(str)
          --   return " " .. str
          -- end, -- Add icon to mode
          -- padding = { left = 1, right = 1 },
        },
        {
          function()
            if vim.fn.reg_recording() ~= "" then
              return " REC " .. vim.fn.reg_recording()
            end
            return ""
          end,
          -- color = { fg = "#ff5189", gui = "bold" }, -- Highlight recording
        },
      },
      lualine_b = {
        "branch",
        {
          "diff",
          symbols = { added = " ", modified = " ", removed = " " },
          colored = true, -- Show colors for changes
          -- padding = { left = 1, right = 0 },
        },
      },
      lualine_c = {
        {
          "filename",
          path = 1, -- Relative path
          symbols = {
            -- modified = " ●",
            modified = "",
            readonly = " ",
            unnamed = "[No Name]",
          },
        },
        {
          "diagnostics",
          sources = { "nvim_diagnostic" },
          symbols = { error = " ", warn = " ", info = " ", hint = " " },
          colored = true,
          update_in_insert = false,
          -- padding = { left = 1 },
        },
      },
      lualine_x = {
        {
          function()
            local clients = vim.lsp.get_clients()
            if #clients > 0 then
              return clients .. " LSP"
            end
            return ""
          end,
          icon = "",
          -- padding = { left = 1 },
        },
        "filetype",
        -- "encoding",
        -- "fileformat",
      },
      lualine_y = { "progress" },
      lualine_z = {
        {
          "location",
        },
        -- {
        --   "datetime",
        --   style = "%H:%M",
        --   padding = { left = 1, right = 1 },
        --   -- color = { fg = "#5de4c7" },
        -- },
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    extensions = { "nvim-tree" },
  },
}

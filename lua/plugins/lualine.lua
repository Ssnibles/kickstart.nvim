return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = "",
      section_separators = { left = "", right = "" },
      disabled_filetypes = {
        statusline = {
          "alpha",
          "dashboard",
          "NvimTree",
          "neo-tree",
          "snacks_dashboard",
          "snacks_picker_input",
          "toggleterm",
          "lazy",
          "mason",
          "help",
          "checkhealth",
        },
      },
      globalstatus = true,
      refresh = { statusline = 100 },
    },
    sections = {
      lualine_a = {
        { "mode", right_padding = 2 },
        {
          function()
            local reg = vim.fn.reg_recording()
            return reg ~= "" and ("󰑋 " .. reg) or ""
          end,
          color = { gui = "bold" },
        },
      },
      lualine_b = {
        { "branch", icon = "" },
        { "diff", symbols = { added = "+", modified = "~", removed = "-" }, colored = true },
      },
      lualine_c = {
        {
          "filename",
          path = 1,
          symbols = { modified = "●", readonly = "", unnamed = "[No Name]" },
        },
        {
          "diagnostics",
          sources = { "nvim_diagnostic" },
          symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
          colored = true,
          update_in_insert = false,
        },
      },
      lualine_x = {
        {
          function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then
              return ""
            end
            local names = {}
            for _, c in ipairs(clients) do
              names[#names + 1] = c.name
            end
            return " " .. table.concat(names, ", ")
          end,
          color = { gui = "italic" },
        },
        { "filetype", colored = true, icon_only = false },
      },
      lualine_y = {
        { "progress", separator = " ", padding = { left = 1, right = 0 } },
        { "location", padding = { left = 0, right = 1 } },
      },
      lualine_z = {
        { "datetime", style = "%H:%M" },
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { { "filename", path = 1 } },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    extensions = { "nvim-tree", "lazy" },
  },
}

return {
  {
    "OXY2DEV/markview.nvim",
    ft = "markdown",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "Kicamon/markdown-table-mode.nvim",
    },
    config = function()
      local presets = require("markview.presets")
      require("markview.extras.editor")

      require("markview").setup({
        markdown = {
          horizontal_rules = presets.horizontal_rules.dashed,
          headings = {
            enable = true,
            shift_width = 1,
            org_indent = false,
            org_indent_wrap = true,
            heading_1 = { style = "icon", icon = "󰼏 ", hl = "MarkviewHeading1" },
            heading_2 = { style = "icon", icon = "󰎨 ", hl = "MarkviewHeading2" },
            heading_3 = { style = "icon", icon = "󰼑 ", hl = "MarkviewHeading3" },
            heading_4 = { style = "icon", icon = "󰎲 ", hl = "MarkviewHeading4" },
            heading_5 = { style = "icon", icon = "󰼓 ", hl = "MarkviewHeading5" },
            heading_6 = { style = "icon", icon = "󰎴 ", hl = "MarkviewHeading6" },
            setext_1 = { style = "decorated", icon = "  ", hl = "MarkviewHeading1", border = "▂" },
            setext_2 = { style = "decorated", icon = "  ", hl = "MarkviewHeading2", border = " " },
          },
          tables = {
            enable = true,
            border = "rounded",
            style = "fancy",
            parts = {
              top = { "╭", "─", "╮", "┬" },
              header = { "│", "│", "│" },
              separator = { "├", "─", "┤", "┼" },
              row = { "│", "│", "│" },
              bottom = { "╰", "─", "╯", "┴" },
              overlap = { "┝", "━", "┥", "┿" },
              align_left = "╼",
              align_right = "╾",
              align_center = { "╴", "╶" },
            },
            col_min_width = 1,
            block_decorator = true,
            use_virt_lines = true,
          },
          checkboxes = {
            default = "X",
            states = {
              { " ", "x" },
              { " ", "X", "-" },
              { " ", "/", "o" },
            },
          },
          code_blocks = {
            enable = true,
            style = "fancy",
            label_direction = "right",
            border = "rounded",
          },
        },
        latex = { enable = false },
        preview = {
          icon_provider = "devicons",
          border = "rounded",
          theme = "auto",
        },
      })
    end,
  },
  {
    "Kicamon/markdown-table-mode.nvim",
    ft = { "markdown" },
    opts = {
      options = {
        insert = true,
        insert_leave = true,
        pad_separator_line = true,
        alig_style = "center",
      },
    },
  },
}

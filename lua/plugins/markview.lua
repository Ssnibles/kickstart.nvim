return {
  "OXY2DEV/markview.nvim",
  ft = "markdown",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },

  -- Keymaps for common Markdown actions
  keys = {
    { "<leader>mtc", "<Cmd>Checkbox<CR>", desc = "Toggle Checkboxes" },
    { "<leader>mhi", "<Cmd>Heading increase<CR>", desc = "Increase Heading" },
    { "<leader>mhd", "<Cmd>Heading decrease<CR>", desc = "Decrease Heading" },
  },

  config = function()
    local presets = require("markview.presets")
    -- require("markview.extras.editor")
    require("markview").setup({
      -- Markdown rendering options
      markdown = {

        horizontal_rules = presets.horizontal_rules.dashed, -- Dashed lines for rules

        -- Heading customisation
        headings = {
          enable = true,

          shift_width = 1,
          org_indent = false,
          org_indent_wrap = true,

          heading_1 = {
            style = "icon",
            sign = "󰌕 ",
            sign_hl = "MarkviewHeading1Sign",

            icon = "󰼏  ",
            hl = "MarkviewHeading1",
          },
          heading_2 = {
            style = "icon",
            sign = "󰌖 ",
            sign_hl = "MarkviewHeading2Sign",

            icon = "󰎨  ",
            hl = "MarkviewHeading2",
          },
          heading_3 = {
            style = "icon",
            icon = "󰼑  ",
            hl = "MarkviewHeading3",
          },
          heading_4 = {
            style = "icon",
            icon = "󰎲  ",
            hl = "MarkviewHeading4",
          },
          heading_5 = {
            style = "icon",
            icon = "󰼓  ",
            hl = "MarkviewHeading5",
          },
          heading_6 = {
            style = "icon",
            icon = "󰎴  ",
            hl = "MarkviewHeading6",
          },

          setext_1 = {
            style = "decorated",

            sign = "󰌕 ",
            sign_hl = "MarkviewHeading1Sign",
            icon = "  ",
            hl = "MarkviewHeading1",
            border = "▂",
          },
          setext_2 = {
            style = "decorated",

            sign = "󰌖 ",
            sign_hl = "MarkviewHeading2Sign",
            icon = "  ",
            hl = "MarkviewHeading2",
            border = "▁",
          },
        },

        -- TODO: Make the tables not look like shit

        -- Tables customisation
        tables = {
          enable = true,

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

        -- Checkbox customisation
        checkboxes = {
          default = "X",
          states = {
            { " ", "/", "X" },
            { "<", ">" },
            { "?", "!", "*" },
            { '"' },
            { "l", "b", "i" },
            { "S", "I" },
            { "p", "c" },
            { "f", "k", "w" },
            { "u", "d" },
          },
        },
        code_blocks = {
          enable = true,
          style = "fancy", -- Try "fancy" for a nicer look
          label_direction = "right",
          border = "rounded", -- Rounded border for code blocks
        },
      },

      -- Disable LaTeX rendering by default
      latex = {
        enable = false,
      },

      -- Preview options
      preview = {
        icon_provider = "devicons",
        border = "rounded", -- Rounded border for preview window
        theme = "auto", -- Match Neovim colorscheme
      },
    })
  end,
}

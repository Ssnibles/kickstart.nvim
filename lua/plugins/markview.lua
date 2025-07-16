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
      -- Enable editor extras for cursor syncing and other editor-related features
      require("markview.extras.editor")

      require("markview").setup({
        -- Markdown rendering options
        markdown = {
          horizontal_rules = presets.horizontal_rules.dashed, -- Dashed lines for rules

          -- Heading customization
          headings = {
            enable = true,
            shift_width = 1,
            org_indent = false,
            org_indent_wrap = true,

            -- Using 'icon' style for all headings for consistency
            heading_1 = {
              style = "icon",
              icon = "󰼏 ", -- Larger, prominent icon
              hl = "MarkviewHeading1",
            },
            heading_2 = {
              style = "icon",
              icon = "󰎨 ",
              hl = "MarkviewHeading2",
            },
            heading_3 = {
              style = "icon",
              icon = "󰼑 ",
              hl = "MarkviewHeading3",
            },
            heading_4 = {
              style = "icon",
              icon = "󰎲 ",
              hl = "MarkviewHeading4",
            },
            heading_5 = {
              style = "icon",
              icon = "󰼓 ",
              hl = "MarkviewHeading5",
            },
            heading_6 = {
              style = "icon",
              icon = "󰎴 ",
              hl = "MarkviewHeading6",
            },

            -- Setext headings can be configured differently if desired
            setext_1 = {
              style = "decorated",
              icon = "  ",
              hl = "MarkviewHeading1",
              border = "▂", -- Emphasize with a border
            },
            setext_2 = {
              style = "decorated",
              icon = "  ",
              hl = "MarkviewHeading2",
              border = " ", -- No border for secondary setext
            },
          },

          -- Tables customization
          tables = {
            enable = true,
            -- Using a common border style for a more unified look
            border = "rounded", -- Rounded border for the entire table
            style = "fancy", -- Experiment with "plain", "fancy", "compact"

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

          -- Checkbox customization
          checkboxes = {
            default = "X",
            -- Simplified states for common use cases
            states = {
              { " ", "x" }, -- Pending, Done
              { " ", "X", "-" }, -- To-do, Done, In-progress
              { " ", "/", "o" }, -- Pending, Doing, On Hold
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
  },
  {
    "Kicamon/markdown-table-mode.nvim",
    opts = {
      options = {
        insert = true, -- when typing "|"
        insert_leave = true, -- when leaving insert
        pad_separator_line = true, -- add space in separator line
        alig_style = "center", -- default, left, center, right
      },
    },
    -- TODO:
  },
}

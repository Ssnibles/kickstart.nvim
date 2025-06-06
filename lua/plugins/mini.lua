return {
  "echasnovski/mini.nvim",
  version = false,
  config = function()
    -- Text objects with extended navigation
    require("mini.ai").setup({
      mappings = {
        around = "a",
        inside = "i",
        around_next = "an",
        inside_next = "in",
        around_last = "al",
        inside_last = "il",
        goto_left = "g[",
        goto_right = "g]",
      },
    })

    -- Advanced text alignment
    require("mini.align").setup({
      mappings = {
        start = "ga",
        start_with_preview = "gA",
      },
      options = {
        split_pattern = "",
        justify_side = "left",
        merge_delimiter = "",
      },
    })

    -- Surround operations
    require("mini.surround").setup({
      mappings = {
        add = "sa",
        delete = "sd",
        find = "sf",
        find_left = "sF",
        highlight = "sh",
        replace = "sr",
        update_n_lines = "sn",
        suffix_last = "l",
        suffix_next = "n",
      },
    })

    -- Intuitive text movement
    require("mini.move").setup({
      mappings = {
        left = "<M-h>",
        right = "<M-l>",
        down = "<M-j>",
        up = "<M-k>",
        line_left = "<M-h>",
        line_right = "<M-l>",
        line_down = "<M-j>",
        line_up = "<M-k>",
      },
      options = {
        reindent_linewise = true,
      },
    })

    -- Essential quality-of-life modules
    require("mini.comment").setup({
      modes = {
        insert = true,
        command = true,
        terminal = true,
      },
    })
    require("mini.cursorword").setup()
    require("mini.pairs").setup()
    require("mini.operators").setup()
    -- require("mini.indentscope").setup()

    -- NEW: mini.clue for key binding hints
    require("mini.clue").setup({
      clues = {
        -- Built-in completion
        { mode = "n", keys = "<Leader>", desc = "+leader" },
        { mode = "n", keys = "g", desc = "+goto" },
        { mode = "n", keys = "z", desc = "+fold" },
        -- Window management
        { mode = "n", keys = "<C-w>", desc = "+windows" },
        -- Buffer management
        { mode = "n", keys = "]", desc = "+next" },
        { mode = "n", keys = "[", desc = "+prev" },
        -- Mini modules
        { mode = "n", keys = "ga", desc = "Align" },
        { mode = "n", keys = "gA", desc = "Align with preview" },
        { mode = "n", keys = "sa", desc = "Surround add" },
        { mode = "n", keys = "sd", desc = "Surround delete" },
        { mode = "n", keys = "sf", desc = "Surround find" },
        { mode = "n", keys = "sh", desc = "Surround highlight" },
        { mode = "n", keys = "sr", desc = "Surround replace" },
        -- Add more clues as desired!
      },
      triggers = {
        -- Show clues for these keys
        { mode = "n", keys = "<Leader>" },
        { mode = "n", keys = "g" },
        { mode = "n", keys = "z" },
        { mode = "n", keys = "<C-w>" },
        { mode = "n", keys = "]" },
        { mode = "n", keys = "[" },
        { mode = "n", keys = "s" },
      },
      window = {
        delay = 300, -- ms before showing clue window
        config = { border = "rounded" },
      },
    })
  end,
}

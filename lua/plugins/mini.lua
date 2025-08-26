return {
  "echasnovski/mini.nvim",
  version = false, -- Use latest git development branch
  event = "VeryLazy",
  config = function()
    -- Your core modules for text editing
    require("mini.ai").setup({
      mappings = {
        around = "a",
        inside = "i",
      },
    })

    require("mini.align").setup({
      -- Mappings are a good idea to keep explicit.
      mappings = {
        start = "ga",
        start_with_preview = "gA",
      },
    })

    require("mini.surround").setup({
      mappings = {
        add = "sa",
        delete = "sd",
      },
    })

    -- This setup is clean and uses a simple, direct mapping.
    require("mini.move").setup({
      mappings = {
        left = "<M-h>",
        right = "<M-l>",
        down = "<M-j>",
        up = "<M-k>",
      },
    })

    ---
    --- Essential Quality-of-Life Modules
    ---

    -- These modules work great out of the box with their defaults,
    -- so a simple `setup()` call is all that's needed to keep the config minimal.
    require("mini.comment").setup()
    require("mini.pairs").setup()
    require("mini.cursorword").setup()
    require("mini.indentscope").setup()
    require("mini.starter").setup()
    require("mini.icons").setup()

    -- This setup uses automatic clue generation, which is much more
    -- minimal than manually defining clues.
    require("mini.clue").setup({
      clues = {
        -- Built-in completion
        { mode = "n", keys = "<Leader>", desc = "+leader" },
        { mode = "n", keys = "g", desc = "+goto" },
        { mode = "n", keys = "z", desc = "+fold" },

        -- Window management
        { mode = "n", keys = "<C-w>", desc = "+windows" },

        -- Buffer management
        -- These are often from `mini.bufremove`, `mini.files`, or similar.
        { mode = "n", keys = "]", desc = "+next" },
        { mode = "n", keys = "[", desc = "+prev" },

        -- Mini modules
        -- Note: these descriptions are helpful, but Mini.clue can usually
        -- infer them from the keymap description.
        { mode = "n", keys = "ga", desc = "Align" },
        { mode = "n", keys = "gA", desc = "Align (preview)" },
        { mode = "n", keys = "sa", desc = "Surround add" },
        { mode = "n", keys = "sd", desc = "Surround delete" },
        { mode = "n", keys = "sr", desc = "Surround replace" },
      },

      -- The `triggers` table is what actually makes the clue pop up.
      -- It's a good idea to be explicit and make sure all starting keys are here.
      triggers = {
        { mode = "n", keys = "<Leader>" },
        { mode = "n", keys = "g" },
        { mode = "n", keys = "z" },
        { mode = "n", keys = "<C-w>" },
        { mode = "n", keys = "]" },
        { mode = "n", keys = "[" },
        { mode = "n", keys = "s" },
        -- You can add more as needed, e.g.,
        -- { mode = "n", keys = "d" },
        -- { mode = "n", keys = "v" },
        -- { mode = "n", keys = "y" },
        -- { mode = "x", keys = "i" },
      },

      -- The window and delay settings are fine as they are.
      window = {
        delay = 300,
        config = {
          border = "rounded",
        },
      },
    })

    -- `mini.hipatterns` setup is already good and minimal.
    require("mini.hipatterns").setup({
      highlighters = {
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
        hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
      },
    })

  end,
}

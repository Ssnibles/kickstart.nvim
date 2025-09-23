return {
  "echasnovski/mini.nvim",
  version = false, -- track main
  event = "VeryLazy",
  config = function()
    -- Text objects, align, surround, move
    require("mini.ai").setup({ mappings = { around = "a", inside = "i" } })
    require("mini.align").setup({ mappings = { start = "ga", start_with_preview = "gA" } })
    require("mini.surround").setup({ mappings = { add = "sa", delete = "sd", replace = "sr" } })
    require("mini.move").setup({ mappings = { left = "<M-h>", right = "<M-l>", down = "<M-j>", up = "<M-k>" } })

    -- Lightweight QoL
    require("mini.comment").setup()
    require("mini.cursorword").setup()

    -- Starter: keep installed but don’t auto-open (Alpha handles the dashboard)
    require("mini.starter").setup({ autoopen = false })

    -- Icons provider (lets other plugins prefer mini.icons over devicons)
    require("mini.icons").setup({ style = "glyph" })

    -- Keybinding hints (concise groups + rounded border)
    require("mini.clue").setup({
      clues = {
        { mode = "n", keys = "<Leader>", desc = "+leader" },
        { mode = "n", keys = "g", desc = "+goto" },
        { mode = "n", keys = "z", desc = "+fold" },
        { mode = "n", keys = "<C-w>", desc = "+windows" },
        { mode = "n", keys = "]", desc = "+next" },
        { mode = "n", keys = "[", desc = "+prev" },
        { mode = "n", keys = "ga", desc = "Align" },
        { mode = "n", keys = "gA", desc = "Align (preview)" },
        { mode = "n", keys = "sa", desc = "Surround add" },
        { mode = "n", keys = "sd", desc = "Surround delete" },
        { mode = "n", keys = "sr", desc = "Surround replace" },
      },
      triggers = {
        { mode = "n", keys = "<Leader>" },
        { mode = "n", keys = "g" },
        { mode = "n", keys = "z" },
        { mode = "n", keys = "<C-w>" },
        { mode = "n", keys = "]" },
        { mode = "n", keys = "[" },
        { mode = "n", keys = "s" },
      },
      window = { delay = 300, config = { border = "rounded" } },
    })

    -- Highlight keywords + hex colors
    local hip = require("mini.hipatterns")
    require("mini.hipatterns").setup({
      highlighters = {
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        fixit = { pattern = "%f[%w]()FIXIT()%f[%W]", group = "MiniHipatternsFixme" },
        error = { pattern = "%f[%w]()ERROR()%f[%W]", group = "MiniHipatternsFixme" },
        warn = { pattern = "%f[%w]()WARN()%f[%W]", group = "MiniHipatternsFixme" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        bug = { pattern = "%f[%w]()BUG()%f[%W]", group = "MiniHipatternsHack" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
        info = { pattern = "%f[%w]()INFO()%f[%W]", group = "MiniHipatternsNote" },
        hint = { pattern = "%f[%w]()HINT()%f[%W]", group = "MiniHipatternsNote" },
        hex_color = hip.gen_highlighter.hex_color(),
      },
    })
  end,
}

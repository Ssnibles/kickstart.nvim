return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- keep only what is needed
    bigfile = { enabled = false },
    dashboard = { enabled = false },
    explorer = { enabled = false },
    indent = { enabled = false },
    input = { enabled = false },
    picker = { enabled = false },
    notifier = { enabled = false },
    quickfile = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },

    -- image + math rendering
    image = {
      enabled = true,
      -- formats are auto-detected; no need to list them explicitly
      doc = {
        enabled = true,
        inline = true, -- render inline where possible
        float = false, -- use inline by default
        max_width = 80,
        max_height = 40,
        -- keep code visible except for math; adjust if desired
        conceal = function(_, type)
          return type == "math"
        end,
      },
      math = {
        enabled = true,
        latex = {
          font_size = "Large", -- readable math size
        },
      },
    },
  },
}

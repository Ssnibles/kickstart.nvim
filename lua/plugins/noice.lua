return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    -- Cmdline popup: centered, rounded, minimal chrome
    views = {
      cmdline_popup = {
        size = { width = 60, height = "auto" },
        border = { style = "rounded", padding = { 0, 1 } },
        position = { row = 0.3, col = "50%" },
        win_options = {
          winhighlight = {
            Normal = "NormalFloat",
            FloatBorder = "FloatBorder",
          },
        },
      },
    },

    -- Cmdline formats
    cmdline = {
      enabled = true,
      format = {
        cmdline = { pattern = "^:", icon = "", lang = "vim" },
        search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
        search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
        filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
        lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
        help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
        input = { view = "cmdline_input", icon = "󰥻 " },
      },
    },

    messages = { enabled = true },
    command = { history = { view = "split" } },

    -- Avoid handler conflicts; fidget/others can handle these
    lsp = {
      hover = { enabled = false },
      signature = { enabled = false },
      progress = { enabled = false },
    },

    -- Leave notifications to fidget or nvim-notify
    notify = { enabled = false },
  },
}

-- Indent guides with ibl (indent-blankline v3)
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = "BufReadPost",
  opts = {
    indent = {
      char = "│",
      tab_char = "│",
    },
    scope = { enabled = false }, -- keep simple; enable later if desired
    exclude = {
      filetypes = {
        "alpha",
        "dashboard",
        "help",
        "lazy",
        "mason",
        "neo-tree",
        "notify",
        "snacks_dashboard",
        "snacks_terminal",
        "toggleterm",
        "Trouble",
      },
    },
  },
}

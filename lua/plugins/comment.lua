-- Don't take this out LSP wont work without it for some reason... gotta fix that
return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    padding = true,
    sticky = true,
    ignore = nil,
    toggler = {
      line = "gcc",
      block = "gbc",
    },
    opleader = {
      line = "gc",
      block = "gb",
    },
    extra = {
      above = "gcO",
      below = "gco",
      eol = "gcA",
    },
    mappings = {
      basic = true,
      extra = true,
    },
    pre_hook = nil,
    post_hook = nil,
  },
}

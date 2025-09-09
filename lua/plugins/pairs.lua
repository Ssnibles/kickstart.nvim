return {
  "altermo/ultimate-autopair.nvim",
  event = { "InsertEnter", "CmdlineEnter" },
  branch = "v0.6", -- Recommended as each new version may have breaking changes
  opts = {
    -- Enable fast wrapping with Alt-e (for example)
    fastwarp = { map = "<A-e>" },
    -- Enable autopairing in command line and for all filetypes
    cmdtype = { enable = true },
    -- Enable for treesitter-aware pairing (better context)
    treesitter = { enable = true },
    -- You can add more options here for fine-tuning
    -- For example, ignore string/ts types, disable certain pairs, etc.
  },
}

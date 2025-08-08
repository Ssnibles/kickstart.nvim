return {
  dir = "~/projects/matugen.nvim/",
  dev = true,
  opts = {
    file = "~/.cache/matugen/colors.jsonc",
    plugins = {
      base = true,
      treesitter = true,
      cmp = true,
      miscellaneous = true,
    },
    debug = false,
  },
  -- Or, if you directly tried to index something that became a boolean
  -- local some_setting = matugen_colorscheme.config.plugins.base -- If base somehow became boolean directly
}

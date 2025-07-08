return {
  dir = "~/projects/matugen.nvim/",
  dev = true,
  opts = {
    file = "~/.cache/matugen/colors.jsonc",
    background_style = "dark",
    auto_load = true,
    set_term_colors = true,
  },
}

-- return {
--   "Ssnibles/matugen.nvim",
--   opts = {
--     file = "~/.cache/matugen/colors.jsonc",
--     background_style = "dark", -- or "light"
--     auto_load = true,
--     disable_plugin_highlights = true, -- Ensure this is false (it's the default)
--     transparent_background = false,
--     set_term_colors = true,
--     -- You can also add custom highlights or ignore groups here:
--     -- ignore_groups = { "Normal" = true },
--     -- custom_highlights = {
--     --   MyCustomGroup = { fg = "colors.primary" }
--     -- },
--   },
-- }

-- In your lazy.nvim or packer.nvim config (e.g., lua/active_theme.lua)
return {
  dir = "~/projects/matugen.nvim/",
  dev = true,
  config = function()
    require("matugen_colorscheme").setup({
      file = "~/.cache/matugen/colors.jsonc",
      -- The 'plugins' table below now corresponds to the files in lua/matugen_colorscheme/highlights/
      plugins = {
        base = true, -- Always enable this, it contains core editor highlights
        cmp = true, -- Enable nvim-cmp highlights
        lualine = true, -- Enable lualine.nvim highlights
        gitsigns = true, -- Enable gitsigns.nvim highlights
        telescope = false, -- Set to true if you create telescope.lua
        treesitter = true, -- Set to true if you create treesitter.lua
      },
      ignore_groups = {
        -- You can still add groups here if you want them explicitly untouched by the theme
      },
      custom_highlights = {
        -- Example:
        -- ["CursorLine"] = { fg = "colors.primary", bg = "NONE", style = "underline" },
      },
    })
  end,
}

--  themery.mvim theme switcher
--https://github.com/zaldih/themery.nvim
return {
  "zaldih/themery.nvim",
  dependencies = {
    -- tokyonight
    {
      "folke/tokyonight.nvim",
      name = "tokyonight",
      opts = {
        style = "night",
      },
      lazy = false,
      priority = 1000,
    },
    -- catppuccin
    { "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 1000 },
    -- kanagawa
    { "rebelot/kanagawa.nvim", name = "kanagawa", lazy = false, priority = 1000 },
    -- sononaki
    { "sainnhe/sonokai", name = "sonokai", 
lazy = false, priority = 1000 },
  },
  config = function()
    require("themery").setup {
      themes = {
        {
          name = "TokyoNight",
          colorscheme = "tokyonight",
        },
        {
          name = "Catppuccin",
          colorscheme = "catppuccin",
        },
        {
          name = "Kanagawa",
          colorscheme = "kanagawa",
        },
        {
          name = "Sonokai",
          colorscheme = "sonokai",
        },
      },
      livePreview = true, -- Live Preview of theme change
    }
  end,
}

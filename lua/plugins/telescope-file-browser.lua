return {
  "nvim-telescope/telescope-file-browser.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<leader>fb",
      ":Telescope file_browser<CR>",
      desc = "Open File Browser",
    },
  },
  config = function()
    local telescope = require "telescope"

    telescope.setup {
      extensions = {
        file_browser = {
          theme = "ivy",
          hijack_netrw = true,
          mappings = {
            ["i"] = {
              -- your custom insert mode mappings
            },
            ["n"] = {
              -- your custom normal mode mappings
            },
          },
        },
      },
    }

    telescope.load_extension "file_browser"
  end,
}

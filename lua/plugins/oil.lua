return {
  "stevearc/oil.nvim",
  opts = {
    default_file_explorer = true, -- Replace netrw
    view_options = {
      show_hidden = true, -- Show dotfiles
    },
    keymaps = {
      ["q"] = "actions.close", -- Close with q
    },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional, for file icons
}


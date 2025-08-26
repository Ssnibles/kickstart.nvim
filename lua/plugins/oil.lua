return {
  "stevearc/oil.nvim",
  config = function()
    local oil = require("oil")
    oil.setup({
      -- Recommended: Replace netrw with Oil
      default_file_explorer = true,
      -- Configure view options
      view_options = {
        show_hidden = true,
      },
    })

    -- Here's the magic! We use a separate keybinding to toggle Oil.
    vim.keymap.set("n", "<leader>o", function()
      if vim.bo.filetype == "oil" then
        oil.close()
      else
        oil.open()
      end
    end, { desc = "Toggle Oil" })

  end,
  dependencies = { "nvim-tree/nvim-web-devicons" },
}

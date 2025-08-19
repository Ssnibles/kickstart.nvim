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
      -- Configure keymaps
      keymaps = {
        -- Navigate
        ["<C-h>"] = "actions.parent_directory",
        ["-"] = "actions.parent_directory",
        ["~"] = "actions.cd_home",
        ["<C-l>"] = "actions.refresh",
        -- Actions
        ["g?"] = "actions.show_help",
        ["<Cr>"] = "actions.select",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-e>"] = "actions.close",
        ["<C-d>"] = "actions.remove",
        ["<C-r>"] = "actions.rename",
        ["<C-n>"] = "actions.new_file",
        ["<C-N>"] = "actions.new_dir",
      },
    })

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

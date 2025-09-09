return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    local oil = require("oil")
    oil.setup({
      default_file_explorer = true, -- Replace netrw
      view_options = {
        show_hidden = true, -- Show dotfiles by default
        natural_order = true, -- Natural sort order
      },
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.select_split",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["<Esc>"] = "actions.close", -- Added: <Esc> to close Oil
      },
      float = {
        padding = 2,
        max_height = 40,
        max_width = 120,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
      },
      win_options = {
        signcolumn = "yes:1",
        cursorline = true,
      },
      experimental_watch_for_changes = true,
    })

    -- Toggle Oil with <leader>o, always goes to file explorer for cwd
    vim.keymap.set("n", "<leader>o", function()
      if vim.bo.filetype == "oil" then
        oil.close()
      else
        oil.open_float()
      end
    end, { desc = "Toggle Oil (floating)" })
  end,
}

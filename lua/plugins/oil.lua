return {
  "stevearc/oil.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local oil = require("oil")
    oil.setup({
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
        natural_order = true,
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
        ["<Esc>"] = "actions.close",
      },
      float = {
        padding = 2,
        max_height = 0.8, -- percentages supported in recent versions
        max_width = 0.8,
        border = "rounded",
        win_options = {
          winblend = 0,
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
        },
      },
      win_options = {
        signcolumn = "yes:1",
        cursorline = true,
      },
      watch_for_changes = true,
    })

    -- Toggle float view
    vim.keymap.set("n", "<leader>o", function()
      if vim.bo.filetype == "oil" then
        oil.close()
      else
        oil.open_float()
      end
    end, { desc = "Oil (float) toggle" })
  end,
}

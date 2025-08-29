return {
  enabled = false,
  "ggandor/leap.nvim",
  dependencies = {
    "tpope/vim-repeat",
  },
  config = function()
    local leap = require("leap")

    leap.opts = {
      highlight_unlabeled = true,
      case_sensitive = false,
      max_phase_one_targets = nil,
      safe_labels = { "s", "n", "t", "e" },
      labels = {
        "a",
        "r",
        "s",
        "t",
        "n",
        "e",
        "i",
        "o",
        "h",
        "d",
        "u",
        "l",
        "c",
        "m",
        "w",
        "f",
        "g",
        "y",
        "p",
        "b",
      },
    }

    -- Set keymaps
    vim.keymap.set({ "n", "x", "o" }, "<CR>", function()
      leap.leap({ target_windows = { vim.fn.win_getid() } })
    end, { desc = "Leap to a target in the current window" })

    vim.keymap.set({ "n", "x", "o" }, "<S-CR>", function()
      leap.leap({ target_windows = require("leap.util").get_enterable_windows() })
    end, { desc = "Leap to a target across all windows" })

    -- Optional f/t style repeating
    vim.keymap.set("n", ";", "<Plug>(leap-forward-to)")
    vim.keymap.set("n", ",", "<Plug>(leap-backward-to)")

    -- Dims the non-target text area
    vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
    -- You can also use a custom color:
    -- vim.api.nvim_set_hl(0, 'LeapBackdrop', { fg = '#4a4a4a', bg = '#282c34' })
  end,
}

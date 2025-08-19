return {
  {
      "lambdalisue/vim-suda",
    -- Loads only when one of its commands (SudaRead, SudaWrite) is invoked.
    cmd = { "SudaRead", "SudaWrite" },
  },
 -- Window Management
  {
    "mrjones2014/smart-splits.nvim",
    -- Changed from 'lazy = false' to 'keys'. This plugin will now only load
    -- when one of its window navigation/resizing keymaps is used.
    keys = {
      {
        "<C-h>",
        function()
          require("smart-splits").move_cursor_left()
        end,
        desc = "Move to left split",
      },
      {
        "<C-j>",
        function()
          require("smart-splits").move_cursor_down()
        end,
        desc = "Move to below split",
      },
      {
        "<C-k>",
        function()
          require("smart-splits").move_cursor_up()
        end,
        desc = "Move to above split",
      },
      {
        "<C-l>",
        function()
          require("smart-splits").move_cursor_right()
        end,
        desc = "Move to right split",
      },
      {
        "<C-S-h>",
        function()
          require("smart-splits").resize_left(3)
        end,
        desc = "Resize left",
      },
      {
        "<C-S-j>",
        function()
          require("smart-splits").resize_down(3)
        end,
        desc = "Resize down",
      },
      {
        "<C-S-k>",
        function()
          require("smart-splits").resize_up(3)
        end,
        desc = "Resize up",
      },
      {
        "<C-S-l>",
        function()
          require("smart-splits").resize_right(3)
        end,
        desc = "Resize right",
      },
    },
  },
}

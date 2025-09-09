return {
  -- Edit files as sudo (writes with :SudaWrite)
  {
    "lambdalisue/vim-suda",
    cmd = { "SudaRead", "SudaWrite" },
  },
  -- Smart window splits: move/resize with <C-hjkl> and <C-S-hjkl>
  {
    "mrjones2014/smart-splits.nvim",
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
  -- CSV viewer with friendly navigation
  {
    "hat0uma/csvview.nvim",
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    opts = {
      parser = { comments = { "#", "//" } },
      keymaps = {
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },
    },
  },
  -- Toggleable terminal (horizontal/vertical/float)
  {
    "akinsho/toggleterm.nvim",
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
      {
        "<leader>th",
        function()
          require("toggleterm").toggle(1, nil, nil, "horizontal")
        end,
        desc = "Horizontal Terminal",
      },
      {
        "<leader>tv",
        function()
          require("toggleterm").toggle(1, nil, nil, "vertical")
        end,
        desc = "Vertical Terminal",
      },
      {
        "<leader>tf",
        function()
          require("toggleterm").toggle(1, nil, nil, "float")
        end,
        desc = "Floating Terminal",
      },
    },
    opts = {
      size = function(term)
        return term.direction == "horizontal" and 15 or math.floor(vim.o.columns * 0.4)
      end,
      open_mapping = nil,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        width = function()
          return math.floor(vim.o.columns * 0.8)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.8)
        end,
        winblend = 0,
      },
      winbar = { enabled = false },
      shade_terminals = false,
    },
  },
  -- ZincOxide: tab/session manager
  {
    "thunder-coding/zincoxide",
    cmd = { "Z", "Zg", "Zt", "Zw" },
    opts = { behaviour = "tabs" },
  },
  -- Auto-close unused buffers
  {
    "chrisgrieser/nvim-early-retirement",
    event = "VeryLazy",
    opts = {
      retirementAgeMins = 10,
      ignoreAltFile = true,
      deleteBufferWhenFileDeleted = true,
    },
  },
  -- Centered editing with a left scratchpad buffer (norg ft)
  {
    "shortcuts/no-neck-pain.nvim",
    lazy = false,
    keys = {
      { "<leader>nn", "<cmd>NoNeckPain<cr>", desc = "Toggle NoNeckPain" },
    },
    opts = {
      width = 100,
      autocmds = {
        enableOnTabEnter = false,
        enableOnVimEnter = false,
        reloadOnColorSchemeChange = true,
        skipEnteringNoNeckPainBuffer = true,
      },
      buffers = {
        right = { enabled = false },
        left = {
          enabled = true,
          scratchPad = { enabled = true },
          bo = { filetype = "norg" },
        },
      },
    },
  },
}

return {
  -- Edit as sudo (transparent write/read)
  {
    "lambdalisue/vim-suda",
    cmd = { "SudaRead", "SudaWrite" },
    init = function()
      vim.g.suda_smart_edit = 1 -- reopen with sudo on write if needed
    end,
  },

  -- Smart split navigation & resizing
  {
    "mrjones2014/smart-splits.nvim",
    keys = {
      {
        "<C-h>",
        function()
          require("smart-splits").move_cursor_left()
        end,
        desc = "Move left",
      },
      {
        "<C-j>",
        function()
          require("smart-splits").move_cursor_down()
        end,
        desc = "Move down",
      },
      {
        "<C-k>",
        function()
          require("smart-splits").move_cursor_up()
        end,
        desc = "Move up",
      },
      {
        "<C-l>",
        function()
          require("smart-splits").move_cursor_right()
        end,
        desc = "Move right",
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
    opts = {
      default_amount = 3,
      multiplexer_integration = nil, -- enable if using wezterm/kitty/tmux later
    },
  },

  -- CSV viewer (lazy on csv)
  {
    "hat0uma/csvview.nvim",
    ft = { "csv" },
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

  -- Toggleable terminal (float by default; no dim backdrop)
  {
    "akinsho/toggleterm.nvim",
    keys = {
      { [[<C-\>]], "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
      {
        "<leader>th",
        function()
          require("toggleterm").toggle(1, nil, nil, "horizontal")
        end,
        desc = "Terminal horizontal",
      },
      {
        "<leader>tv",
        function()
          require("toggleterm").toggle(1, nil, nil, "vertical")
        end,
        desc = "Terminal vertical",
      },
      {
        "<leader>tf",
        function()
          require("toggleterm").toggle(1, nil, nil, "float")
        end,
        desc = "Terminal float",
      },
    },
    opts = {
      size = function(term)
        return term.direction == "horizontal" and 15 or math.floor(vim.o.columns * 0.4)
      end,
      open_mapping = nil,
      start_in_insert = true,
      direction = "float",
      close_on_exit = true,
      persist_size = false,
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
        highlights = { border = "FloatBorder", background = "Normal" },
      },
      hide_numbers = true,
      shade_terminals = false,
    },
  },

  -- ZincOxide tabs/sessions
  {
    "thunder-coding/zincoxide",
    cmd = { "Z", "Zg", "Zt", "Zw" },
    opts = { behaviour = "tabs" },
  },

  -- Auto-close inactive buffers
  {
    "chrisgrieser/nvim-early-retirement",
    event = "VeryLazy",
    opts = {
      retirementAgeMins = 10,
      ignoreAltFile = true,
      deleteBufferWhenFileDeleted = true,
      notificationOnAutoClose = false,
    },
  },

  -- Centered editing with left scratchpad
  {
    "shortcuts/no-neck-pain.nvim",
    keys = { { "<leader>nn", "<cmd>NoNeckPain<cr>", desc = "Toggle NoNeckPain" } },
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

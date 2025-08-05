return {
  -- Productivity Tools
  {
    "meznaric/key-analyzer.nvim",
    -- Loads only when the :KeyAnalyzer command is explicitly invoked.
    cmd = "KeyAnalyzer",
    opts = {
      layout = "qwerty",
    },
  },

  -- Terminal Management
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    -- Removed 'cmd = "ToggleTerm"' and now loads only when one of its keymaps is used.
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
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = nil, -- We handle this with keys above
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
      winbar = {
        enabled = false,
      },
      shade_terminals = false,
    },
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

  -- Directory Navigation
  {
    "thunder-coding/zincoxide",
    -- Loads only when one of its commands (Z, Zg, Zt, Zw) is invoked.
    cmd = { "Z", "Zg", "Zt", "Zw" },
    opts = { behaviour = "tabs" },
  },

  -- Quality of Life Improvements
  {
    "chrisgrieser/nvim-early-retirement",
    -- Loads very late, after most other plugins have initialized.
    event = "VeryLazy",
    opts = {
      retirementAgeMins = 10,
      ignoreAltFile = true,
      deleteBufferWhenFileDeleted = true,
    },
  },

  {
    "m4xshen/hardtime.nvim",
    -- Loads very late, after most other plugins have initialized.
    enabled = false,
    event = "VeryLazy",
    opts = {
      max_time = 1000,
      max_count = 2,
      disable_mouse = false,
      hint = true,
      notification = true,
      allow_different_key = false,
      enabled = true,
      disabled_keys = {
        ["<Up>"] = { "n", "x" },
        ["<Down>"] = { "n", "x" },
        ["<Left>"] = { "n", "x" },
        ["<Right>"] = { "n", "x" },
      },
      disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason", "oil", "fyler" },
    },
  },

  {
    "shortcuts/no-neck-pain.nvim",
    -- Removed 'cmd = "NoNeckPain"' and now loads only when its keymap is used.
    keys = {
      { "<leader>nn", "<cmd>NoNeckPain<cr>", desc = "Toggle No Neck Pain" },
    },
    opts = {
      width = 100,
      autocmds = {
        enableOnVimEnter = false,
        enableOnTabEnter = false,
      },
      buffers = {
        scratchPad = {
          enabled = false,
        },
        bo = {
          filetype = "no-neck-pain",
        },
      },
    },
  },
  {
    "lambdalisue/vim-suda",
    -- Loads only when one of its commands (SudaRead, SudaWrite) is invoked.
    cmd = { "SudaRead", "SudaWrite" },
  },
  {
    "MysticalDevil/inlay-hints.nvim",
    event = "LspAttach",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("inlay-hints").setup()
    end,
  },
}

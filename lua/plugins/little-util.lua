return {
  -- Color Related Utilities
  {
    "brenoprata10/nvim-highlight-colors",
    event = "BufReadPost",
    opts = {
      render = "virtual",
      virtual_symbol = "●",
      enable_named_colors = true,
      enable_tailwind = true,
    },
  },

  -- LSP & UI Progress
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      notification = {
        window = {
          winblend = 0,
          border = "rounded",
          zindex = 45,
        },
      },
      progress = {
        suppress_on_insert = true,
        ignore_done_already = true,
        ignore = { "null-ls", "ltex" },
      },
    },
  },

  -- File path in winbar (disabled by default)
  {
    "b0o/incline.nvim",
    enabled = false,
    event = "BufReadPost",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      window = {
        margin = { horizontal = 1, vertical = 0 },
        placement = { horizontal = "right", vertical = "top" },
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        if filename == "" then
          filename = "[No Name]"
        end

        local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
        local modified = vim.bo[props.buf].modified

        return {
          ft_icon and { " ", ft_icon, " ", guifg = ft_color } or "",
          { filename, gui = modified and "bold,italic" or "bold" },
          modified and { " ●", guifg = "#ff9e64" } or "",
        }
      end,
    },
  },

  -- Productivity Tools
  {
    "meznaric/key-analyzer.nvim",
    cmd = "KeyAnalyzer",
    opts = {
      layout = "qwerty",
    },
  },

  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>tt", "<cmd>TodoTelescope<cr>", desc = "Todo Telescope" },
      { "<leader>tT", "<cmd>TodoTrouble<cr>", desc = "Todo Trouble" },
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo",
      },
    },
    opts = {
      signs = true,
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", color = "default", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
      },
    },
  },

  -- Clipboard Management
  {
    "gbprod/yanky.nvim",
    event = "TextYankPost",
    dependencies = { "kkharji/sqlite.lua" },
    keys = {
      { "<leader>p", "<cmd>YankyRingHistory<cr>", desc = "Yank History" },
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put after" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put before" },
      { "<c-n>", "<Plug>(YankyNextEntry)", desc = "Next yank" },
      { "<c-p>", "<Plug>(YankyPreviousEntry)", desc = "Previous yank" },
    },
    opts = {
      ring = {
        history_length = 100,
        storage = "sqlite",
      },
      picker = {
        select = {
          action = nil, -- Use default
        },
        telescope = {
          use_default_mappings = true,
        },
      },
      highlight = {
        on_put = true,
        on_yank = true,
        timer = 200,
      },
    },
  },

  -- Terminal Management
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = "ToggleTerm",
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
    },
  },

  -- Window Management
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
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
    cmd = { "Z", "Zg", "Zt", "Zw" },
    opts = { behaviour = "tabs" },
  },

  -- Quality of Life Improvements
  {
    "chrisgrieser/nvim-early-retirement",
    event = "VeryLazy",
    opts = {
      retirementAgeMins = 10,
      ignoreAltFile = true,
      deleteBufferWhenFileDeleted = true,
    },
  },

  {
    "m4xshen/hardtime.nvim",
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
      disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason", "oil" },
    },
  },

  {
    "shortcuts/no-neck-pain.nvim",
    cmd = "NoNeckPain",
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
}

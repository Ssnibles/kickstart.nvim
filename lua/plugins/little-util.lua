return {
  -- Color Related Utilities
  {
    "brenoprata10/nvim-highlight-colors",
    event = "BufReadPost",
    opts = {
      render = "virtual", -- 'background' or 'foreground' or 'virtual'
      virtual_symbol = "",
      enable_named_colors = true,
    },
  },

  -- LSP & UI
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      notification = {
        window = {
          winblend = 0,
          border = "none",
          zindex = 45,
          relative = "editor",
        },
      },
      progress = {
        ignore = { "^null-ls" },
        suppress_on_insert = true,
        ignore_done_already = true,
      },
    },
  },
  {
    "b0o/incline.nvim",
    enabled = false,
    event = "VeryLazy",
    config = function()
      local devicons = require("nvim-web-devicons")
      require("incline").setup({
        window = { margin = { horizontal = 1 } },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          local ft_icon, _ = devicons.get_icon_color(filename)
          return {
            ft_icon and { " ", ft_icon, " " } or "",
            { filename, gui = vim.bo[props.buf].modified and "bold,italic" or "bold" },
            guibg = "#44406e",
            guifg = "#ffffff",
          }
        end,
      })
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Productivity
  {
    "meznaric/key-analyzer.nvim",
    cmd = "KeyAnalyzer",
    opts = {
      layout = "qwerty",
      highlights = {
        bracket_used = "KeyAnalyzerBracketUsed",
        letter_used = "KeyAnalyzerLetterUsed",
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = "BufEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = true,
      keywords = {
        TODO = { icon = " ", color = "info" },
      },
      search = { pattern = [[\b(TODO):]] },
      keys = {
        { "<leader>tt", "<cmd>TodoTelescope<cr>", desc = "Todo Telescope" },
      },
    },

    -- Clipboard Management
    {
      "gbprod/yanky.nvim",
      event = "TextYankPost",
      dependencies = { "kkharji/sqlite.lua" },
      opts = { ring = { storage = "sqlite" } },
      keys = {
        { "<leader>p", "<cmd>YankyRingHistory<cr>", desc = "Yank History" },
        { "y", "<Plug>(YankyYank)", mode = { "n", "x" } },
        { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" } },
        { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" } },
        { "<c-n>", "<Plug>(YankyNextEntry)" },
        { "<c-p>", "<Plug>(YankyPreviousEntry)" },
      },
    },

    -- Terminal
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      cmd = "ToggleTerm",
      keys = {
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
          local win = vim.api.nvim_get_current_win()
          if term.direction == "horizontal" then
            return math.floor(vim.api.nvim_win_get_height(win) * 0.6)
          elseif term.direction == "vertical" then
            return math.floor(vim.api.nvim_win_get_width(win) * 0.4)
          end
        end,
        direction = "float",
        float_opts = {
          border = "curved",
          width = function()
            local win = vim.api.nvim_get_current_win()
            return math.floor(vim.api.nvim_win_get_width(win) * 0.8)
          end,
          height = function()
            local win = vim.api.nvim_get_current_win()
            return math.floor(vim.api.nvim_win_get_height(win) * 0.8)
          end,
        },
        open_mapping = [[<c-\>]],
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        shade_terminals = true,
        shading_factor = 2,
        close_on_exit = true,
        persist_size = true,
      },
    },

    -- Navigation & Windows
    {
      "mrjones2014/smart-splits.nvim",
      keys = {
        {
          "<C-S-h>",
          function()
            require("smart-splits").resize_left(3)
          end,
        },
        {
          "<C-S-j>",
          function()
            require("smart-splits").resize_down(3)
          end,
        },
        {
          "<C-S-k>",
          function()
            require("smart-splits").resize_up(3)
          end,
        },
        {
          "<C-S-l>",
          function()
            require("smart-splits").resize_right(3)
          end,
        },
      },
    },
    {
      "thunder-coding/zincoxide",
      cmd = { "Z", "Zg", "Zt", "Zw" },
      opts = { behaviour = "tabs" },
    },

    -- Quality of Life
    {
      "chrisgrieser/nvim-early-retirement",
      event = "BufEnter",
      opts = { retirementAgeMins = 15 },
    },
    {
      "m4xshen/hardtime.nvim",
      opts = {
        disabled_keys = {
          ["<Up>"] = { "", "n" },
          ["<Down>"] = { "", "n" },
          ["<Left>"] = { "", "n" },
          ["<Right>"] = { "", "n" },
        },
      },
    },
    {
      "shortcuts/no-neck-pain.nvim",
      cmd = "NoNeckPain",
      opts = { width = 120 }, -- Added sensible default
    },
  },
}

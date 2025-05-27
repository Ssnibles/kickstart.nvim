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
      cmd = "ToggleTerm",
      keys = {
        {
          "<leader>th",
          function()
            require("toggleterm.terminal").Terminal
              :new({
                direction = "horizontal",
                size = function()
                  return math.floor(vim.api.nvim_win_get_height(0) * 0.6)
                end,
              })
              :toggle()
          end,
          desc = "Horizontal Terminal",
        },
        {
          "<leader>tv",
          function()
            require("toggleterm.terminal").Terminal
              :new({
                direction = "vertical",
                size = function()
                  return math.floor(vim.api.nvim_win_get_width(0) * 0.4)
                end,
              })
              :toggle()
          end,
          desc = "Vertical Terminal",
        },
        {
          "<leader>tf",
          function()
            require("toggleterm.terminal").Terminal
              :new({
                direction = "float",
                float_opts = {
                  width = function()
                    return math.floor(vim.api.nvim_win_get_width(0) * 0.8)
                  end,
                  height = function()
                    return math.floor(vim.api.nvim_win_get_height(0) * 0.8)
                  end,
                },
              })
              :toggle()
          end,
          desc = "Floating Terminal",
        },
        {
          "<leader>ta",
          function()
            local terms = require("toggleterm.terminal").get_all()
            for _, term in ipairs(terms) do
              term:toggle(false)
            end
          end,
          desc = "Toggle All Terminals",
        },
        {
          "<leader>ts",
          function()
            local current_win = vim.api.nvim_get_current_win()
            local current_buf = vim.api.nvim_win_get_buf(current_win)
            local terms = require("toggleterm.terminal").get_all()

            for _, term in ipairs(terms) do
              if term.bufnr == current_buf then
                term:toggle()
                return
              end
            end

            require("toggleterm").toggle_command("ToggleTerm")
          end,
          desc = "Toggle Current/Last Terminal",
        },
      },
      config = function()
        require("toggleterm").setup({
          size = function(term)
            if term.direction == "horizontal" then
              return math.floor(vim.api.nvim_win_get_height(0) * 0.6)
            elseif term.direction == "vertical" then
              return math.floor(vim.api.nvim_win_get_width(0) * 0.4)
            end
          end,
          direction = "horizontal",
          close_on_exit = true,
          auto_scroll = true,
          persist_mode = false,
        })
      end,
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

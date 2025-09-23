return {
  "folke/flash.nvim",
  -- Load on first keypress
  keys = {
    {
      "<CR>",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash: Jump",
    },
    {
      "S",
      mode = { "n", "x", "o" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash: Treesitter",
    },
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Flash: Remote",
    },
    {
      "R",
      mode = { "o", "x" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Flash: TS Search",
    },
    {
      "<C-s>",
      mode = "c",
      function()
        require("flash").toggle()
      end,
      desc = "Flash: Toggle Search",
    },
  },

  opts = {
    -- Enable all main modes with label hints
    modes = {
      search = { enabled = true, jump_labels = true },
      char = { enabled = true, jump_labels = true },
      treesitter = { enabled = true, jump_labels = true },
    },

    -- Label style: easy-to-read alphabet
    jump_labels = { style = "alphabet" },

    -- Keep visuals unobtrusive; Flash uses its own hl groups that inherit theme defaults
    -- (no extra UI wiring needed when NormalFloat/FloatBorder are themed globally)
  },
}

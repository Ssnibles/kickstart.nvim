return {
  "folke/flash.nvim",
  -- Lazy-load on first use of these keymaps, for great startup speed
  keys = {
    {
      "<CR>",
      function()
        require("flash").jump()
      end,
      mode = { "n", "x", "o" },
      desc = "Flash: Jump",
    },
    {
      "S",
      function()
        require("flash").treesitter()
      end,
      mode = { "n", "x", "o" },
      desc = "Flash: Treesitter Jump",
    },
    {
      "r",
      function()
        require("flash").remote()
      end,
      mode = "o",
      desc = "Flash: Remote Jump",
    },
    {
      "R",
      function()
        require("flash").treesitter_remote()
      end,
      mode = { "o", "x" },
      desc = "Flash: Remote Treesitter Jump",
    },
    {
      "<C-s>",
      function()
        require("flash").jump()
      end,
      mode = "c",
      desc = "Flash: Cmdline Jump",
    },
  },
  opts = {
    modes = {
      search = { enabled = true, jump_labels = true },
      char = { enabled = true, jump_labels = true },
      treesitter = { enabled = true, jump_labels = true },
    },
    jump_labels = {
      style = "alphabet", -- clear, unique, easy to see
    },
    -- Uncomment to tweak visuals:
    -- label = { before = { " " }, after = { " " } },
    -- patterns = { "\\<.\\+\\>" }, -- only jump to whole words
  },
}

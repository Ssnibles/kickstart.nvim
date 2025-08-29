return {
  "folke/flash.nvim",
  -- Flash.nvim is a motion plugin, so it's best loaded when its keymaps are used.
  -- By defining `keys`, Lazy.nvim will automatically lazy-load the plugin
  -- when one of these keybindings is pressed, improving startup performance.
  keys = {
    -- Basic jump action: initiates a search for targets and jumps to the selected one.
    {
      "<CR>", -- Typically mapped to <CR> in normal, visual, and operator-pending modes
      function()
        require("flash").jump()
      end,
      mode = { "n", "x", "o" }, -- Normal, Visual, Operator-pending modes
      desc = "Flash: Jump",
    },
    -- Treesitter-based jump: targets Treesitter nodes for more intelligent jumps.
    {
      "S", -- Common mapping for Treesitter-aware search
      function()
        require("flash").treesitter()
      end,
      desc = "Flash: Treesitter Jump",
      mode = { "n", "x", "o" },
    },
    -- Remote flash: for jumping to targets on another window or buffer.
    {
      "r",
      function()
        require("flash").remote()
      end,
      mode = "o", -- Operator-pending mode (e.g., `yr` to yank to remote target)
      desc = "Flash: Remote Jump",
    },
    -- Remote Treesitter flash: combines remote jumping with Treesitter targeting.
    {
      "R",
      function()
        require("flash").treesitter_remote()
      end,
      mode = { "o", "x" }, -- Operator-pending and Visual modes
      desc = "Flash: Remote Treesitter Jump",
    },
    -- Flash in command-line mode: useful for jumping within command-line history or completion.
    {
      "<c-s>", -- Ctrl-s in command-line mode
      function()
        require("flash").jump()
      end,
      mode = { "c" }, -- Command-line mode
      desc = "Flash: Command Line Jump",
    },
  },
  -- Plugin options for customizing Flash's behavior.
  opts = {
    -- Configure different Flash modes.
    modes = {
      search = {
        enabled = true,
        jump_labels = true, -- Enable jump labels (e.g., 'a', 'b', 'c') for search results.
      },
      char = {
        enabled = true,
        jump_labels = true, -- Enable jump labels for character motions (like `f`, `t`).
      },
      treesitter = {
        enabled = true,
        jump_labels = true, -- Enable jump labels for Treesitter-based targets.
      },
    },
    -- Global options for jump labels.
    jump_labels = {
      style = "default", -- Use the default labeling style (e.g., single characters).
      -- You can explore other styles like 'alphabet', 'numbers', 'hash'.
      -- For example: `style = "alphabet"`
      -- Other options like `before_text`, `after_text` can be added here
      -- to customize the appearance of the labels further.
    },
    -- You can add any other Flash configuration options you wish to override here.
    -- For example:
    -- label = {
    --   before = { " ", " " }, -- Add space before and after labels for better visual separation
    --   after = { " ", " " },
    -- },
    -- patterns = {
    --   -- Customize which characters or patterns Flash should target.
    --   -- For example, to target only words:
    --   -- "\\<.\\+\\>",
    -- },
  },
}

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2", -- Specify the 'harpoon2' branch for the latest features
  dependencies = { "nvim-lua/plenary.nvim" }, -- Essential utility library for Neovim plugins
  -- Harpoon is typically loaded lazily by its keybindings.
  -- No explicit 'event' or 'lazy = true' is needed here, as the 'keys' table
  -- tells Lazy.nvim to load the plugin only when one of these keymaps is triggered.
  keys = {
    -- Add the current file to the Harpoon list.
    {
      "<leader>ha",
      function()
        require("harpoon"):list():add()
      end,
      desc = "Harpoon: Add File",
    },
    -- Toggle the Harpoon quick menu, showing all marked files.
    {
      "<leader>hm",
      function()
        -- Ensure harpoon.ui is loaded and then toggle the quick menu.
        -- The optional setup of the quick menu appearance should be done in 'config'.
        require("harpoon.ui"):toggle_quick_menu(require("harpoon"):list())
      end,
      desc = "Harpoon: Quick Menu",
    },
    -- Navigate directly to specific files in the Harpoon list by index.
    -- These are very common and efficient for quick jumps.
    {
      "<leader>h1",
      function()
        require("harpoon"):list():select(1)
      end,
      desc = "Harpoon: Go to File 1",
    },
    {
      "<leader>h2",
      function()
        require("harpoon"):list():select(2)
      end,
      desc = "Harpoon: Go to File 2",
    },
    {
      "<leader>h3",
      function()
        require("harpoon"):list():select(3)
      end,
      desc = "Harpoon: Go to File 3",
    },
    {
      "<leader>h4",
      function()
        require("harpoon"):list():select(4)
      end,
      desc = "Harpoon: Go to File 4",
    },
    -- Cycle through files in the Harpoon list.
    {
      "<leader>hn",
      function()
        require("harpoon"):list():next()
      end,
      desc = "Harpoon: Next File",
    },
    {
      "<leader>hp",
      function()
        require("harpoon"):list():prev()
      end,
      desc = "Harpoon: Previous File",
    },
  },
  -- The 'config' function is called once the plugin is loaded.
  -- This is where global setup for Harpoon should occur.
  config = function()
    local harpoon = require("harpoon")
    -- Basic setup for Harpoon. An empty table means using default options.
    harpoon:setup({})

    -- Optional: Configure the appearance of the Harpoon quick menu.
    -- This ensures that when the menu is toggled, it uses these visual settings.
    require("harpoon.ui").setup({
      border = "rounded", -- Use rounded borders for the menu popup
      title_pos = "center", -- Center the title of the menu
      -- You can add other UI options here, for example:
      -- ui_path = require("harpoon.ui.paths").relative, -- Display paths relative to the current working directory
      -- width = 0.8, -- Set menu width
      -- height = 0.8, -- Set menu height
    })
  end,
}

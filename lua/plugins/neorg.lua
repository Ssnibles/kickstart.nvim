return {
  {
    "nvim-neorg/neorg",
    -- Lazy-load Neorg when a .norg file is opened.
    ft = "norg",
    -- Ensure luarocks.nvim is a dependency, as Neorg often requires it.
    dependencies = { "vhyrro/luarocks.nvim" },
    -- Specify a version to pin Neorg to a stable release.
    version = "*", -- Pin to the latest stable release. Alternatively, use 'v1.0.0' or 'v1.0'.

    -- 'opts' table: This table is passed directly to `require("neorg").setup()`.
    -- Use this for configurations that are directly options for the plugin's setup function.
    opts = {
      load = {
        -- Core modules are essential for Neorg's basic functionality.
        ["core.defaults"] = {}, -- Loads default Neorg behaviors.
        ["core.concealer"] = {}, -- Adds pretty icons and conceals markup.
        ["core.dirman"] = {
          config = {
            -- Define your workspaces here. This is crucial for organizing your Neorg files.
            workspaces = {
              notes = "~/notes", -- Example workspace: all files under ~/notes are part of the 'notes' workspace.
              work = "~/documents/work_notes", -- Another example workspace.
            },
            -- Set a default workspace for when Neorg starts.
            default_workspace = "notes",
          },
        },
        -- Add other core modules as needed.
        -- ["core.completion"] = { config = { engine = "nvim-cmp" } }, -- Example for completion integration.
        -- ["core.looking-glass"] = {}, -- For better viewing of linked notes.
        -- ["core.gtd"] = {}, -- If you use Getting Things Done methodology.
      },
      -- You can add other top-level Neorg options here if available.
      -- e.g., enable_markdown = true,
    },

    -- 'keys' table: Define keybindings for Neorg.
    -- These mappings will be loaded when the plugin is loaded.
    keys = {
      -- Example keybinding: open the Neorg index file.
      -- This assumes your 'notes' workspace has an index.norg.
      { "<leader>ni", "<cmd>Neorg index<CR>", desc = "Neorg: Go to Index" },
      -- Example keybinding: switch to the 'notes' workspace.
      { "<leader>nw", "<cmd>Neorg workspace notes<CR>", desc = "Neorg: Switch to Notes Workspace" },
      -- Example keybinding: toggle the Neorg workspace tree (if dirman is configured).
      { "<leader>nt", "<cmd>Neorg toggle tree<CR>", desc = "Neorg: Toggle Tree" },
      -- Add more Neorg-specific keybindings here.
      -- For instance, to create a new note in the current workspace:
      -- { "<leader>nn", function() require("neorg.api").create_note() end, desc = "Neorg: New Note" },
    },

    -- 'config' function: Use this for any Lua code that needs to run *after* the plugin is loaded,
    -- but isn't just options for `require("neorg").setup()`.
    -- The `_` is the plugin table, and `opts` is the table you defined above.
    config = function(_, opts)
      -- This line ensures Neorg is set up with the options defined in `opts`.
      require("neorg").setup(opts)

      -- You can add additional configurations here that might depend on Neorg being loaded,
      -- but are not part of its direct `setup` options.
      -- For example, setting buffer-local options for Neorg files:
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "norg",
        callback = function()
          -- Set foldlevel for better folding in Neorg files.
          vim.wo.foldlevel = 99
          vim.wo.conceallevel = 2 -- Adjust as needed for concealer module
        end,
      })

      -- You could also set up custom commands or autocommands specific to Neorg here.
    end,
  },
  -- Also include the luarocks.nvim dependency if you haven't already in your main plugins file.
  { "vhyrro/luarocks.nvim", priority = 1000, config = true },
}

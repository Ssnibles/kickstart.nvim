-- Enable Lua module loader for better performance
-- This is a Neovim 0.10+ feature
if vim.loader then
  vim.loader.enable()
end

--- Neovim Theme Switching Integration ---
-- This block dynamically loads the active theme's plugin specification.
-- The `active_theme.lua` file is expected to be a symlink (created by your script)
-- pointing to one of your theme definition files in `lua/themes/`.
-- These theme files should `return` a lazy.nvim plugin specification table.
local theme_plugin_spec = {}
local status_ok, loaded_spec = pcall(require, "active_theme")

if status_ok and type(loaded_spec) == "table" then
  -- If active_theme.lua successfully returned a table (your plugin spec)
  theme_plugin_spec = loaded_spec
else
  -- Fallback to a default theme if active_theme.lua doesn't exist, is invalid,
  -- or hasn't been set by your script yet.
  -- Define a default rose-pine plugin spec here.
  -- This should match the structure of your `lua/themes/rose-pine.lua` if that's your default.
  theme_plugin_spec = {
    "rose-pine/neovim-rose-pine", -- The actual GitHub path for lazy.nvim
    name = "rose-pine", -- The name lazy.nvim uses for this plugin
    priority = 1000, -- Load colorscheme early
    -- lazy = false,              -- Uncomment if you want to force it to load immediately
    config = function()
      -- Default configuration for rose-pine when no specific theme is active
      vim.g.rose_pine_variant = "main" -- Set your preferred default variant
      vim.g.rose_pine_darker_floats = true
      vim.g.rose_pine_transparent_background = false
      vim.cmd("colorscheme rose-pine") -- Apply the default colorscheme
    end,
  }
  if not status_ok then
    -- Print an error if 'require' failed (e.g., file not found, syntax error)
    print("Error requiring active_theme.lua: " .. tostring(loaded_spec))
  else
    -- Print a warning if the file was found but didn't return a table
    print("active_theme.lua did not return a valid table, falling back to default theme.")
  end
end

--- End Neovim Theme Switching Integration ---

-- Source other configuration files
-- It's crucial that 'core.lazy' (which calls lazy.setup) is sourced AFTER
-- the 'theme_plugin_spec' has been determined, as it will receive it as an argument.
require("core.lazy")(theme_plugin_spec) -- Pass the determined theme_plugin_spec to core.lazy

require("core.keymaps") -- Source keymaps (e.g., ~/.config/nvim/lua/core/keymaps.lua)
require("core.options") -- Source options (e.g., ~/.config/nvim/lua/core/options.lua)
require("core.autocmds") -- Source autocmds (e.g., ~/.config/nvim/lua/core/autocmds.lua)
require("core.functions") -- Source custom functions (e.g., ~/.config/nvim/lua/core/functions.lua)

-- Optional: Disable virtual text for diagnostics if desired
-- vim.diagnostic.config({ virtual_text = false })

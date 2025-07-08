-- This file contains the bootstrap and setup for lazy.nvim.
-- It is designed to be called from init.lua, passing in the active_theme_spec.

-- Bootstrap lazy.nvim if it's not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
-- Add lazy.nvim to the runtime path
vim.opt.rtp:prepend(lazypath)

-- Set global leader keys (if not already set elsewhere)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Define a function to setup lazy.nvim.
-- This function accepts the `active_theme_spec` determined in init.lua.
local function setup_lazy_plugins(active_theme_spec)
  -- Setup lazy.nvim with your plugin specifications
  require("lazy").setup({
    -- The 'spec' table defines all plugins lazy.nvim should manage.
    spec = {
      -- *** IMPORTANT: Include the active_theme_spec here. ***
      -- This ensures that the dynamically chosen or default colorscheme plugin
      -- is processed and configured by lazy.nvim at startup.
      active_theme_spec,

      -- Import other plugin configurations from your 'plugins' directories.
      -- This assumes you have files in ~/.config/nvim/lua/plugins/ and ~/.config/nvim/lua/plugins/langs/.
      { import = "plugins" },
      { import = "plugins.langs" },
    },
    -- lazy.nvim configuration options:
    change_detection = { notify = false }, -- Suppress notifications about config changes

    -- Optional: Add a fallback colorscheme for lazy.nvim's initial install.
    -- This helps ensure a colorscheme is set even before your theme logic fully runs.
    install = { colorscheme = { "rose-pine" } },

    -- Optional: Enable checker for plugin updates
    checker = { enabled = true },

    -- Optional: Performance optimizations, e.g., disabling default Neovim plugins
    performance = {
      rtp = {
        disabled_plugins = {
          "netrw",
          "netrwPlugin",
          "tarPlugin",
          "zipPlugin",
          "tutor",
          "rplugin",
          "syntax",
          "synmenu",
          "optwin",
          "compiler",
          "matchit",
        },
      },
    },
    -- dev = {
    --   path = "~/projects/",
    -- },
  })
end

-- Return the `setup_lazy_plugins` function.
-- This allows `init.lua` to call `require("core.lazy")(theme_plugin_spec)`
-- to execute the lazy.nvim setup with the correct theme.
return setup_lazy_plugins

-- core/lazy.lua
-- Bootstrap and configure lazy.nvim, injecting the active theme spec.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })
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

vim.opt.rtp:prepend(lazypath)

-- Set leader keys early
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

--- Setup function for lazy.nvim
---@param active_theme_spec table
return function(active_theme_spec)
  require("lazy").setup({
    spec = {
      active_theme_spec,
      { import = "plugins" },
      -- { import = "plugins.langs" },
    },
    change_detection = { notify = false },
    install = { colorscheme = { "rose-pine" } },
    checker = { enabled = true },
    performance = {
      rtp = {
        disabled_plugins = {
          "netrw", "netrwPlugin", "tarPlugin", "zipPlugin",
          "tutor", "rplugin", "syntax", "synmenu",
          "optwin", "compiler", "matchit",
        },
      },
    },
    -- dev = { path = "~/projects/" },
  })
end


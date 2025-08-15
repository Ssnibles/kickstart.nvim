-- Enable Lua module loader (Neovim 0.10+)
if vim.loader then vim.loader.enable() end

-- Dynamic Theme Loader
local function load_theme_spec()
  local ok, spec = pcall(require, "active_theme")
  if ok and type(spec) == "table" then
    return spec
  end

  -- Fallback theme spec (rose-pine)
  if not ok then
    vim.notify("Failed to load active_theme.lua: " .. tostring(spec), vim.log.levels.WARN)
  else
    vim.notify("active_theme.lua did not return a valid table. Using default theme.", vim.log.levels.WARN)
  end

  return {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    config = function()
      vim.g.rose_pine_variant = "main"
      vim.g.rose_pine_darker_floats = true
      vim.g.rose_pine_transparent_background = false
      vim.cmd.colorscheme("rose-pine")
    end,
  }
end

-- Load theme spec
local theme_spec = load_theme_spec()

-- Load core configs
require("core.lazy")(theme_spec)
require("core.keymaps")
require("core.options")
require("core.autocmds")

-- Optional: Disable virtual text for diagnostics
-- vim.diagnostic.config({ virtual_text = false })


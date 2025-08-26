-- ~/.config/nvim/lua/core/autocmds.lua
local augroup = vim.api.nvim_create_augroup("GeneralAutocmds", { clear = true })

-- Use sets for faster lookups
local special_filetypes = {
  ["alpha"] = true,
  ["checkhealth"] = true,
  ["fzf"] = true,
  ["help"] = true,
  ["lazy"] = true,
  ["man"] = true,
  ["qf"] = true,
  ["NvimTree"] = true,
  ["startify"] = true,
  ["gitcommit"] = true,
  ["neo-tree"] = true,
  ["Trouble"] = true,
}

local special_buftypes = {
  ["nofile"] = true,
  ["acwrite"] = true,
  ["terminal"] = true,
  ["prompt"] = true,
}

-- Check if buffer should be excluded from enhancements
local function is_special_buffer()
  -- Exclude oil buffers from special treatment
  if vim.bo.filetype == "oil" then
    return false
  end
  return not not special_buftypes[vim.bo.buftype] or not not special_filetypes[vim.bo.filetype]
end

-- Cache for mode colors to avoid repeated lualine lookups
local mode_colors = {}

local function get_mode_color(mode)
  -- Use a more robust cache key
  local cache_key = mode:sub(1, 1)
  if mode_colors[cache_key] then
    return mode_colors[cache_key]
  end

  local ok, lualine = pcall(require, "lualine")
  if not ok then
    return nil
  end

  local config = lualine.get_config()
  local theme = config and config.options and config.options.theme
  if not theme then
    return nil
  end

  if type(theme) == "string" then
    local theme_ok, theme_module = pcall(require, "lualine.themes." .. theme)
    if not theme_ok then
      return nil
    end
    theme = theme_module
  end

  if type(theme) ~= "table" then
    return nil
  end

  local mode_map = {
    ["n"] = theme.normal,
    ["i"] = theme.insert,
    ["R"] = theme.replace,
    ["v"] = theme.visual,
    ["c"] = theme.command,
  }

  local mode_theme = mode_map[cache_key] or theme.normal
  local color = mode_theme and mode_theme.a and mode_theme.a.bg

  if color then
    mode_colors[cache_key] = color
  end

  return color
end

-- Update cursor line number color based on mode
local function update_cursorline_color()
  local mode = vim.fn.mode()
  local color = get_mode_color(mode)

  if color then
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = color, bold = true })
  end
end

-- Consolidated autocmds
-- Handle buffer settings on entry and filetype
vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
  group = augroup,
  callback = function(event)
    local win = vim.api.nvim_get_current_win()
    local is_special = is_special_buffer()

    if is_special then
      -- Disable options for special buffers
      vim.api.nvim_set_option_value("number", false, { win = win })
      vim.api.nvim_set_option_value("relativenumber", false, { win = win })
      vim.api.nvim_set_option_value("cursorline", false, { win = win })
      vim.opt_local.wrap = false
      vim.opt_local.spell = false

      -- Add keymaps for closeable buffers
      local closeable_types =
        { ["help"] = true, ["man"] = true, ["qf"] = true, ["lspinfo"] = true, ["checkhealth"] = true }
      if closeable_types[vim.bo.filetype] then
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", {
          buffer = event.buf,
          silent = true,
          desc = "Close buffer",
        })
      end
    else
      -- Enable options for normal buffers
      vim.api.nvim_set_option_value("number", true, { win = win })
      vim.api.nvim_set_option_value("relativenumber", true, { win = win })
      vim.api.nvim_set_option_value("cursorline", true, { win = win })

      -- Set text file settings
      local ft = vim.bo.filetype
      if ft == "markdown" or ft == "text" or ft == "txt" or ft == "gitcommit" then
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
        vim.opt_local.linebreak = true
      end

      -- Restore cursor position
      local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
      local line_count = vim.api.nvim_buf_line_count(event.buf)
      if mark and mark[1] > 1 and mark[1] <= line_count then
        vim.api.nvim_win_set_cursor(0, mark)
      end
    end
  end,
})

-- Mode-based cursor line number color.
vim.api.nvim_create_autocmd({ "VimEnter", "ModeChanged" }, {
  group = augroup,
  callback = function()
    if not is_special_buffer() then
      update_cursorline_color()
    end
  end,
})

-- Toggle relative numbers in insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
  group = augroup,
  callback = function()
    if not is_special_buffer() and not vim.wo.diff then
      vim.wo.relativenumber = false
    end
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = augroup,
  callback = function()
    if not is_special_buffer() and not vim.wo.diff then
      vim.wo.relativenumber = true
    end
  end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank({ timeout = 300 })
  end,
})

-- Clean trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  callback = function()
    if not is_special_buffer() then
      local view = vim.fn.winsaveview()
      vim.cmd("silent! keeppatterns %s/\\s\\+$//e")
      vim.fn.winrestview(view)
    end
  end,
})

-- Auto-resize windows when Neovim is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  command = "wincmd =",
})

-- Enable cursorline only in the current window
vim.api.nvim_create_autocmd("WinEnter", {
  group = augroup,
  callback = function()
    if not is_special_buffer() then
      vim.wo.cursorline = true
    end
  end,
})

vim.api.nvim_create_autocmd("WinLeave", {
  group = augroup,
  callback = function()
    if not is_special_buffer() then
      vim.wo.cursorline = false
    end
  end,
})

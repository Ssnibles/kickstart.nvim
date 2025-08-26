-- ~/.config/nvim/lua/autocmds.lua

local augroup = vim.api.nvim_create_augroup("ImprovedCommands", { clear = true })

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
  return special_buftypes[vim.bo.buftype] or special_filetypes[vim.bo.filetype]
end

-- Cache for mode colors to avoid repeated lualine lookups
local mode_colors = {}

local function get_mode_color(mode)
  if mode_colors[mode] then
    return mode_colors[mode]
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
    ["V"] = theme.visual,
    ["\22"] = theme.visual,
    ["c"] = theme.command,
  }

  local mode_theme = mode_map[mode:sub(1, 1)] or theme.normal
  local color = mode_theme and mode_theme.a and mode_theme.a.bg

  if color then
    mode_colors[mode] = color
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

-- Mode-based cursor line color.
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

-- 💡 NEW: Explicitly enable line numbers for normal file buffers
-- This fixes the issue where line numbers might not show up
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup,
  callback = function()
    if not is_special_buffer() then
      local win = vim.api.nvim_get_current_win()
      vim.api.nvim_set_option_value("number", true, { win = win })
      vim.api.nvim_set_option_value("relativenumber", true, { win = win })
      vim.api.nvim_set_option_value("cursorline", true, { win = win })
    end
  end,
})

-- Configure special filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = {
    "alpha",
    "checkhealth",
    "fzf",
    "help",
    "lazy",
    "man",
    "qf",
    "NvimTree",
    "startify",
    "gitcommit",
    "neo-tree",
    "Trouble",
  },
  callback = function(event)
    local current_buf = vim.api.nvim_get_current_buf()
    if current_buf ~= event.buf then
      return
    end

    local win = vim.api.nvim_get_current_win()
    -- Disable line numbers and cursor line for special buffers
    vim.api.nvim_set_option_value("number", false, { win = win })
    vim.api.nvim_set_option_value("relativenumber", false, { win = win })
    vim.api.nvim_set_option_value("cursorline", false, { win = win })

    local closeable_types =
      { ["help"] = true, ["man"] = true, ["qf"] = true, ["lspinfo"] = true, ["checkhealth"] = true }
    if closeable_types[event.match] then
      vim.bo[event.buf].buflisted = false
      vim.keymap.set("n", "q", "<cmd>close<cr>", {
        buffer = event.buf,
        silent = true,
        desc = "Close buffer",
      })
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

-- Restore cursor position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function(event)
    if is_special_buffer() then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(event.buf)
    if mark and mark[1] > 1 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
    end
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

-- Text file settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "markdown", "text", "txt", "gitcommit" },
  callback = function()
    if not is_special_buffer() then
      vim.opt_local.wrap = true
      vim.opt_local.spell = true
      vim.opt_local.linebreak = true
    end
  end,
})

-- Enable cursorline only in the current window
local function update_cursorline()
  local current_win = vim.api.nvim_get_current_win()
  for _, win_id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if not is_special_buffer() then
      if win_id == current_win then
        vim.api.nvim_set_option_value("cursorline", true, { win = win_id })
      else
        vim.api.nvim_set_option_value("cursorline", false, { win = win_id })
      end
    end
  end
end

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  group = augroup,
  callback = update_cursorline,
})

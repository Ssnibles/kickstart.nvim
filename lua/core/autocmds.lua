-- ~/.config/nvim/lua/core/autocmds.lua
local augroup = vim.api.nvim_create_augroup("GeneralAutocmds", { clear = true })

-- Use sets for O(1) lookups
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

local closeable_types = {
  ["help"] = true,
  ["man"] = true,
  ["qf"] = true,
  ["lspinfo"] = true,
  ["checkhealth"] = true,
}

local text_filetypes = {
  ["markdown"] = true,
  ["text"] = true,
  ["txt"] = true,
  ["gitcommit"] = true,
}

-- Check if buffer should be excluded
local function is_special_buffer(bufnr)
  bufnr = bufnr or 0
  return special_buftypes[vim.bo[bufnr].buftype] or special_filetypes[vim.bo[bufnr].filetype]
end

-- Cache for lualine theme colors
local mode_color_cache = {}
local function get_mode_color(mode)
  if mode_color_cache[mode] then
    return mode_color_cache[mode]
  end

  local ok, lualine = pcall(require, "lualine")
  if not ok then
    return nil
  end

  local config = lualine.get_config()
  local theme = config.options.theme

  if type(theme) == "string" then
    ok, theme = pcall(require, "lualine.themes." .. theme)
    if not ok then
      return nil
    end
  end

  if not theme then
    return nil
  end

  local mode_map = {
    ["n"] = theme.normal,
    ["i"] = theme.insert,
    ["v"] = theme.visual,
    ["V"] = theme.visual,
    ["\22"] = theme.visual,
    ["R"] = theme.replace,
    ["c"] = theme.command,
  }

  local color = mode_map[mode] and mode_map[mode].a and mode_map[mode].a.bg
  if color then
    mode_color_cache[mode] = color
  end

  return color
end

-- Update cursor line number color
local function update_cursorline_color()
  local mode = vim.fn.mode():sub(1, 1)
  local color = get_mode_color(mode)
  if color then
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = color, bold = true })
  end
end

-- Main buffer setup
vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
  group = augroup,
  callback = function(args)
    local bufnr = args.buf
    local filetype = vim.bo[bufnr].filetype

    -- Skip oil buffers
    if filetype == "oil" then
      return
    end

    local is_special = is_special_buffer(bufnr)
    local winnr = vim.api.nvim_get_current_win()

    -- Set window options using key-value pairs
    vim.api.nvim_set_option_value("number", not is_special, { win = winnr })
    vim.api.nvim_set_option_value("relativenumber", not is_special, { win = winnr })
    vim.api.nvim_set_option_value("cursorline", not is_special, { win = winnr })

    if is_special then
      -- Handle closeable buffers
      if closeable_types[filetype] then
        vim.bo[bufnr].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", {
          buffer = bufnr,
          silent = true,
          desc = "Close buffer",
        })
      end
    else
      -- Text file settings
      if text_filetypes[filetype] then
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
        vim.opt_local.linebreak = true
      end

      -- Restore cursor position
      local mark = vim.api.nvim_buf_get_mark(bufnr, '"')
      if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(bufnr) then
        pcall(vim.api.nvim_win_set_cursor, winnr, mark)
      end
    end
  end,
})

-- Mode-based cursor line highlighting
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
  callback = function(args)
    if not is_special_buffer(args.buf) then
      local view = vim.fn.winsaveview()
      vim.cmd.keeppatterns("%s/\\s\\+$//e")
      vim.fn.winrestview(view)
    end
  end,
})

-- Auto-resize windows
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  command = "wincmd =",
})

-- Cursorline management
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
    vim.wo.cursorline = false
  end,
})

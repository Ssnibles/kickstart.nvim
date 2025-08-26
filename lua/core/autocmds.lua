-- Improved autocommands - cleaner, more efficient, and idiomatic
local augroup = vim.api.nvim_create_augroup("ImprovedCommands", { clear = true })

-- Cache for performance
local mode_colors = {}
local special_filetypes = {
  alpha = true,
  checkhealth = true,
  fzf = true,
  help = true,
  lazy = true,
  man = true,
  qf = true,
  NvimTree = true,
  startify = true,
  term = true,
  gitcommit = true,
}

-- Mode-based cursor line coloring (with error handling)
local function update_cursorline_color()
  local mode = vim.api.nvim_get_mode().mode

  -- Use cached color if available
  if mode_colors[mode] then
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = mode_colors[mode], bold = true })
    return
  end

  -- Try to get lualine theme colors
  local ok, lualine = pcall(require, "lualine")
  if not ok then
    return
  end

  local config = lualine.get_config()
  if not config or not config.options then
    return
  end

  local theme = config.options.theme

  if type(theme) == "string" then
    local theme_ok, theme_module = pcall(require, "lualine.themes." .. theme)
    if not theme_ok then
      return
    end
    theme = theme_module
  end

  -- Ensure theme is valid
  if type(theme) ~= "table" then
    return
  end

  -- Simplified mode mapping (fixed visual block detection)
  local mode_theme = theme.normal
  if mode:find("^i") then
    mode_theme = theme.insert
  elseif mode:find("^R") then
    mode_theme = theme.replace
  elseif mode:find("^[vV]") or mode == "\22" then -- \22 is visual block mode
    mode_theme = theme.visual
  elseif mode:find("^c") then
    mode_theme = theme.command
  end

  local color = mode_theme and mode_theme.a and mode_theme.a.bg
  if color then
    mode_colors[mode] = color -- Cache the color
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = color, bold = true })
  end
end

-- Consolidated mode change handling (with buffer checks)
vim.api.nvim_create_autocmd({ "ModeChanged", "VimEnter", "CmdlineEnter" }, {
  group = augroup,
  desc = "Update cursor line color on mode change",
  callback = function()
    -- Only update for normal buffers
    if vim.bo.buftype == "" and not special_filetypes[vim.bo.filetype] then
      update_cursorline_color()
    end
  end,
})

-- Line number toggling (with proper buffer type checks)
vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
  group = augroup,
  desc = "Toggle relative line numbers",
  callback = function(event)
    -- Only for normal file buffers, not diffs or special buffers
    if vim.bo.buftype == "" and not vim.wo.diff and not special_filetypes[vim.bo.filetype] then
      vim.wo.relativenumber = event.event == "InsertLeave"
    end
  end,
})

-- Special buffer settings (with buffer validity checks)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = vim.tbl_keys(special_filetypes),
  desc = "Configure special buffers",
  callback = function(event)
    local buf = event.buf

    -- Ensure buffer is valid
    if not vim.api.nvim_buf_is_valid(buf) then
      return
    end

    local win = vim.fn.bufwinid(buf)

    if win ~= -1 then
      -- Use pcall for safety when setting window options
      pcall(vim.api.nvim_set_option_value, "number", false, { win = win })
      pcall(vim.api.nvim_set_option_value, "relativenumber", false, { win = win })
      pcall(vim.api.nvim_set_option_value, "cursorline", false, { win = win })
    end

    -- Add quit mapping for helper buffers
    if vim.tbl_contains({ "help", "man", "qf", "lspinfo", "checkhealth" }, event.match) then
      vim.bo[buf].buflisted = false
      vim.keymap.set("n", "q", "<cmd>close<cr>", {
        buffer = buf,
        silent = true,
        desc = "Close buffer",
      })
    end
  end,
})

-- Yank highlighting with cursor restore (with validation)
do
  local cursor_pos = nil

  -- Override yank commands to save cursor
  for _, key in ipairs({ "y", "Y" }) do
    vim.keymap.set({ "n", "x" }, key, function()
      -- Only save cursor for normal buffers
      if vim.bo.buftype == "" then
        cursor_pos = vim.api.nvim_win_get_cursor(0)
      end
      return key
    end, { expr = true, desc = "Yank with cursor save" })
  end

  vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,
    desc = "Highlight yank and restore cursor",
    callback = function()
      -- Only highlight for normal buffers
      if vim.bo.buftype == "" then
        vim.highlight.on_yank({ timeout = 200 })
        if cursor_pos then
          vim.schedule(function()
            -- Validate cursor position before restoring
            local line_count = vim.api.nvim_buf_line_count(0)
            if cursor_pos[1] <= line_count then
              pcall(vim.api.nvim_win_set_cursor, 0, cursor_pos)
            end
            cursor_pos = nil
          end)
        end
      end
    end,
  })
end

-- Buffer management - restore cursor position (fixed)
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  desc = "Restore cursor position",
  callback = function(event)
    local buf = event.buf

    -- Skip for special filetypes and non-file buffers
    if vim.bo[buf].buftype ~= "" or special_filetypes[vim.bo[buf].filetype] then
      return
    end

    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local line_count = vim.api.nvim_buf_line_count(buf)
    local line, col = mark[1], mark[2]

    -- Only restore if mark exists and line is valid
    if line > 0 and line <= line_count then
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(buf) then
          pcall(vim.api.nvim_win_set_cursor, 0, { line, col })
        end
      end)
    end
  end,
})

-- File operations (with buffer type check)
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  desc = "Clean up whitespace",
  callback = function()
    -- Only clean whitespace for normal file buffers
    if vim.bo.buftype ~= "" then
      return
    end

    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.cmd("silent! keepjumps keeppatterns %s/\\s\\+$//e")
    pcall(vim.api.nvim_win_set_cursor, 0, cursor)
  end,
})

-- Window management
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  desc = "Balance windows on resize",
  command = "wincmd =",
})

-- Text-based file settings (with buffer type check)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "markdown", "text", "txt" },
  desc = "Text file settings",
  callback = function(event)
    -- Only apply to normal file buffers
    if vim.bo[event.buf].buftype == "" then
      vim.opt_local.wrap = true
      vim.opt_local.spell = true
    end
  end,
})

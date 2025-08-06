vim.api.nvim_create_autocmd("ModeChanged", {
  callback = function()
    local mode = vim.api.nvim_get_mode().mode
    local filetype = vim.bo.filetype -- 'vim.bo' is short for 'vim.opt_local'

    -- Check if the current buffer's filetype is fzf
    if filetype == "fzf" then
      vim.opt.number = false
      vim.opt.relativenumber = false
      return -- Exit the callback early
    end

    -- Your original logic for all other filetypes
    if mode == "n" or mode:match("^[vV\22]$") then
      vim.opt.relativenumber = true
      vim.opt.number = true
    else
      -- In other modes (e.g., insert, command), only show the absolute line number
      vim.opt.relativenumber = false
      vim.opt.number = true
    end
  end,
})

-- Highlight text on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Keep the cursor position when yanking
local cursorPreYank

vim.keymap.set({ "n", "x" }, "y", function()
  cursorPreYank = vim.api.nvim_win_get_cursor(0)
  return "y"
end, { expr = true })

vim.keymap.set("n", "Y", function()
  cursorPreYank = vim.api.nvim_win_get_cursor(0)
  return "y$"
end, { expr = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    if vim.v.event.operator == "y" and cursorPreYank then
      vim.api.nvim_win_set_cursor(0, cursorPreYank)
    end
  end,
})

-- A table mapping modes to lualine highlight group names.
local mode_to_group = {
  n = "lualine_a_normal",
  i = "lualine_a_insert",
  v = "lualine_a_visual",
  V = "lualine_a_visual",
  ["\22"] = "lualine_a_visual",
  c = "lualine_a_command",
  R = "lualine_a_replace",
  r = "lualine_a_replace",
  s = "lualine_a_select",
  S = "lualine_a_select",
  ["\19"] = "lualine_a_select",
  t = "lualine_a_terminal",
}

-- The function that updates the highlight.
local function update_cursorlinenr_highlight()
  local mode = vim.fn.mode()
  local group_name = mode_to_group[mode] or "Normal"
  local attrs = vim.api.nvim_get_hl(0, { name = group_name, link = false })

  -- Check if the highlight group exists and has a background color.
  -- This handles the case where lualine hasn't loaded yet.
  if attrs and attrs.bg then
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = attrs.bg })
  else
    -- Fallback to the default Normal highlight group.
    vim.api.nvim_set_hl(0, "CursorLineNr", { link = "Normal" })
  end
end

-- Set up the autocommand group and events.
vim.api.nvim_create_augroup("CursorLineNrHighlight", { clear = true })
vim.api.nvim_create_autocmd({ "ModeChanged", "VimEnter" }, {
  group = "CursorLineNrHighlight",
  callback = update_cursorlinenr_highlight,
})

-- Restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.cmd('normal! g`"zz')
    end
  end,
})

-- removes trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Show cursorline only on active windows
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function()
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      vim.w.auto_cursorline = false
    end
  end,
})

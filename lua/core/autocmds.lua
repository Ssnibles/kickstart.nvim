--  see `:help lua-guide-autocommands`

-- Define the "currentline" sign with proper namespace and styling
-- vim.fn.sign_define("currentline", {
--   text = "▶", -- More visible symbol
--   texthl = "LineNr", -- Link to existing highlight group
--   numhl = "LineNr", -- Maintain number column appearance
-- })

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

-- Change currentline number colour based on mode
local mode_to_group = {
  n = "lualine_a_normal",       -- Normal mode
  i = "lualine_a_insert",       -- Insert mode
  v = "lualine_a_visual",       -- Visual mode
  V = "lualine_a_visual",       -- Visual Line mode
  ["\22"] = "lualine_a_visual", -- Visual Block mode (CTRL-V)
  c = "lualine_a_command",      -- Command-line mode
  R = "lualine_a_replace",      -- Replace mode
  Rv = "lualine_a_replace",     -- Virtual Replace mode
  s = "lualine_a_select",       -- Select mode
  S = "lualine_a_select",       -- Select Line mode
  ["\19"] = "lualine_a_select", -- Select Block mode (CTRL-S)
  t = "lualine_a_terminal",     -- Terminal mode
}

vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*",
  callback = function()
    local mode = vim.fn.mode()
    local group = mode_to_group[mode] or "StatusLine"
    local attrs = vim.api.nvim_get_hl(0, { name = group, link = true })
    -- Only set the foreground color for CursorLineNr
    vim.api.nvim_set_hl(0, "CursorLineNr", {
      fg = attrs.bg,
      bold = attrs.bold,
      italic = attrs.italic,
      underline = attrs.underline,
      undercurl = attrs.undercurl,
    })
  end,
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

-- Dim inactive windows
--
-- vim.cmd("highlight default DimInactiveWindows guifg=#666666")
--
-- -- When leaving a window, set all highlight groups to a "dimmed" hl_group
-- vim.api.nvim_create_autocmd({ "WinLeave" }, {
--   callback = function()
--     local highlights = {}
--     for hl, _ in pairs(vim.api.nvim_get_hl(0, {})) do
--       table.insert(highlights, hl .. ":DimInactiveWindows")
--     end
--     vim.wo.winhighlight = table.concat(highlights, ",")
--   end,
-- })
--
-- -- When entering a window, restore all highlight groups to original
-- vim.api.nvim_create_autocmd({ "WinEnter" }, {
--   callback = function()
--     vim.wo.winhighlight = ""
--   end,
-- })
--
-- vim.api.nvim_create_autocmd({ "VimResized" }, {
--   group = vim.api.nvim_create_augroup("EqualizeSplits", {}),
--   callback = function()
--     local current_tab = vim.api.nvim_get_current_tabpage()
--     vim.cmd("tabdo wincmd =")
--     vim.api.nvim_set_current_tabpage(current_tab)
--   end,
--   desc = "Resize splits with terminal window",
-- })

-- Show cursorline only on active windows
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function()
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      vim.w.auto_cursorline = false
    end
  end,
})

vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  callback = function()
    if vim.wo.cursorline then
      vim.w.auto_cursorline = true
      vim.wo.cursorline = false
    end
  end,
})

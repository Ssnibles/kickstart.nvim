-- Create autocommand group with clear=true to prevent duplication
local augroup = vim.api.nvim_create_augroup("GeneralCommands", { clear = true })

-- Line Number Toggling
vim.api.nvim_create_autocmd("InsertEnter", {
  group = augroup,
  desc = "Show absolute line numbers in Insert mode",
  callback = function()
    if vim.bo.buftype == "" and not vim.wo.diff then
      vim.wo.relativenumber = false
    end
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = augroup,
  desc = "Show relative line numbers in Normal mode",
  callback = function()
    if vim.bo.buftype == "" and not vim.wo.diff then
      vim.wo.relativenumber = true
    end
  end,
})

-- Special Buffer Settings
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  desc = "Set buffer options for special filetypes",
  pattern = {
    "alpha", "checkhealth", "cmp_menu", "fzf", "gitcommit",
    "help", "lazy", "man", "qf", "NvimTree", "startify", "term",
  },
  callback = function()
    vim.wo.number = false       -- window option
    vim.wo.relativenumber = false  -- window option
    vim.wo.wrap = false         -- window option
  end,
})

-- Yank Highlight & Cursor Restore
local yank_group = vim.api.nvim_create_augroup("YankRestore", { clear = true })
local cursor_pos = nil

local function save_cursor()
  cursor_pos = vim.api.nvim_win_get_cursor(0)
end

vim.keymap.set({"n", "x"}, "y", function()
  save_cursor()
  return "y"
end, { expr = true, desc = "Yank and save cursor position" })

vim.keymap.set("n", "Y", function()
  save_cursor()
  return "Y"
end, { expr = true, desc = "Yank line and save cursor position" })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = yank_group,
  desc = "Highlight yank and restore cursor",
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
    if cursor_pos then
      vim.schedule(function()
        vim.api.nvim_win_set_cursor(0, cursor_pos)
        cursor_pos = nil
      end)
    end
  end,
})

-- Restore Cursor Position
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  desc = "Restore cursor position",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line, col = mark[1], mark[2]
    local line_count = vim.api.nvim_buf_line_count(0)

    if line > 0 and line <= line_count then
      local ok, err = pcall(vim.api.nvim_win_set_cursor, 0, {line, math.max(0, col - 1)})
      if not ok then
        print("Error restoring cursor: " .. err)
      end
    end
  end,
})

-- Remove Trailing Whitespace
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  desc = "Remove trailing whitespace",
  callback = function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[keepjumps keeppatterns %s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, cursor)
  end,
})

-- Window Management
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  desc = "Balance windows on resize",
  callback = vim.schedule_wrap(function()
    vim.cmd("wincmd =")
  end),
})

-- Filetype-Specific Settings
local filetype_options = {
  markdown = { wrap = true, spell = true },
  gitcommit = { wrap = true, spell = true },
  txt = { wrap = true, spell = true },
  text = { wrap = true, spell = true },
}

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  desc = "Set filetype-specific options",
  callback = function(args)
    local ft = args.match
    if filetype_options[ft] then
      for option, value in pairs(filetype_options[ft]) do
        vim.wo[option] = value
      end
    end
  end,
})

-- Close Helper Buffers
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "help", "man", "qf", "lspinfo" },
  desc = "Close special buffers with q",
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true,
      nowait = true,
      desc = "Close buffer"
    })
  end,
})

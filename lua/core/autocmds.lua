-- ~/.config/nvim/lua/core/autocmds.lua
local aug = vim.api.nvim_create_augroup
local acmd = vim.api.nvim_create_autocmd
local group = aug("CoreAutocmds", { clear = true })

-- Treat helper/utility windows as special
local function is_special(buf)
  buf = buf or 0
  if not vim.api.nvim_buf_is_valid(buf) then
    return true
  end
  return vim.bo[buf].buftype ~= "" or vim.bo[buf].filetype == "help" or vim.bo[buf].filetype == "qf"
end

-- 'q' closes helper windows
acmd("FileType", {
  group = group,
  pattern = { "help", "qf", "man", "checkhealth", "lspinfo" },
  callback = function(args)
    vim.bo[args.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = args.buf, silent = true, desc = "Close window" })
  end,
})

-- Hide numbers in helper windows
acmd("FileType", {
  group = group,
  pattern = { "help", "qf", "man", "checkhealth", "lspinfo" },
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.cursorline = false
  end,
})

-- Show cursorline only in the active window
acmd("WinEnter", {
  group = group,
  callback = function()
    if not is_special(0) then
      vim.wo.cursorline = true
    end
  end,
})
acmd("WinLeave", {
  group = group,
  callback = function()
    if vim.api.nvim_win_is_valid(0) then
      vim.wo.cursorline = false
    end
  end,
})

-- Toggle relative numbers in insert mode
acmd("InsertEnter", {
  group = group,
  callback = function()
    if not is_special(0) and not vim.wo.diff then
      vim.wo.relativenumber = false
    end
  end,
})
acmd("InsertLeave", {
  group = group,
  callback = function()
    if not is_special(0) and not vim.wo.diff then
      vim.wo.relativenumber = true
    end
  end,
})

-- Briefly highlight on yank
acmd("TextYankPost", {
  group = group,
  callback = function()
    pcall(vim.highlight.on_yank, { timeout = 300 })
  end,
})

-- Equalize splits after terminal resize
acmd("VimResized", {
  group = group,
  callback = function()
    vim.cmd("wincmd =")
  end,
})

-- Create parent directories on save
acmd("BufWritePre", {
  group = group,
  callback = function(args)
    local b = args.buf
    if not vim.api.nvim_buf_is_valid(b) or vim.bo[b].buftype ~= "" then
      return
    end
    local name = vim.api.nvim_buf_get_name(b)
    if name == "" then
      return
    end
    local dir = vim.fn.fnamemodify(name, ":h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- Show matches while searching; clear afterward
acmd("CmdlineEnter", {
  group = group,
  pattern = { "/", "?" },
  callback = function()
    vim.opt.hlsearch = true
  end,
})
acmd("CmdlineLeave", {
  group = group,
  pattern = { "/", "?" },
  callback = function()
    vim.opt.hlsearch = false
  end,
})

-- Persist folds and cursor via views
acmd("BufWinLeave", {
  group = group,
  callback = function(args)
    local b = args.buf
    if not vim.api.nvim_buf_is_valid(b) then
      return
    end
    if vim.bo[b].buftype ~= "" or not vim.bo[b].modifiable then
      return
    end
    pcall(vim.cmd, "mkview")
  end,
})
acmd("BufWinEnter", {
  group = group,
  callback = function(args)
    local b = args.buf
    if not vim.api.nvim_buf_is_valid(b) then
      return
    end
    if vim.bo[b].buftype ~= "" then
      return
    end
    pcall(vim.cmd, "silent! loadview")
  end,
})

-- cd to the file's directory for normal buffers
acmd("BufEnter", {
  group = group,
  callback = function(args)
    local b = args.buf
    if not vim.api.nvim_buf_is_valid(b) or is_special(b) then
      return
    end
    local name = vim.api.nvim_buf_get_name(b)
    if name == "" then
      return
    end
    local dir = vim.fn.fnamemodify(name, ":h")
    if vim.fn.isdirectory(dir) == 1 and dir ~= vim.fn.getcwd() then
      pcall(vim.cmd.lcd, vim.fn.fnameescape(dir))
    end
  end,
})

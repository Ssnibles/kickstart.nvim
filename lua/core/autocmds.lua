-- Autocommand group helper function.
-- This creates and clears an autocommand group. All your autocmds
-- should belong to a single, descriptive group to prevent conflicts.
local augroup = vim.api.nvim_create_augroup("GeneralCommands", { clear = true })

--- Line Number Toggling ---
-- This section manages line number display based on the current mode and buffer type.
vim.api.nvim_create_autocmd("ModeChanged", {
  group = augroup,
  desc = "Toggle relative line numbers based on mode",
  callback = function()
    local buftype = vim.bo.buftype
    -- Don't apply this logic to special buffers.
    if buftype == "nofile" or buftype == "nowrite" or buftype == "terminal" then
      return
    end

    local mode = vim.api.nvim_get_mode().mode
    local is_normal_like = mode == "n" or mode:match("^[vV\22]$")
    if is_normal_like then
      -- In Normal, Visual, and Select modes, show both absolute and relative numbers.
      vim.wo.number = true
      vim.wo.relativenumber = true
    else
      -- In Insert, Command-line, and Replace modes, show only absolute numbers.
      vim.wo.number = true
      vim.wo.relativenumber = false
    end
  end,
})

--- Special Buffer Settings ---
-- Hide line numbers and disable wrapping in special buffers like popups and terminals.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  desc = "Hide numbers and disable wrap in special buffers",
  pattern = {
    "checkhealth",
    "fzf",
    "help",
    "man",
    "term",
    "qf",
    "NvimTree",
    "lazy",
    "alpha",
    "cmp_menu",
  },
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.wrap = false
  end,
})

--- Yank Actions ---
-- This highlights yanked text and restores the cursor position.
-- Note: The original code's keymaps for 'y' and 'Y' that stored the cursor
-- position were a good solution for that specific problem.
-- If you need to restore the cursor position after a yank, you can either
-- keep your custom keymaps or use a plugin that provides this functionality.
-- The built-in `vim.highlight.on_yank()` does not restore the cursor position.
-- For this example, I'll assume highlighting is the primary goal and reintroduce
-- a simplified version of your keymaps that are more robust.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  desc = "Highlight yanked text",
  callback = function()
    vim.highlight.on_yank({
      higroup = "Visual",
      timeout = 200,
    })
  end,
})

-- Re-implementing the keymaps for yank and cursor position restore.
-- The original keymaps are a good way to achieve this specific behavior.
local cursorPreYank

vim.keymap.set({ "n", "x" }, "y", function()
  cursorPreYank = vim.api.nvim_win_get_cursor(0)
  return "y"
end, { expr = true, desc = "Yank and store cursor position" })

vim.keymap.set("n", "Y", function()
  cursorPreYank = vim.api.nvim_win_get_cursor(0)
  return "y$"
end, { expr = true, desc = "Yank line and store cursor position" })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank()
    if cursorPreYank then
      vim.api.nvim_win_set_cursor(0, cursorPreYank)
      cursorPreYank = nil
    end
  end,
  desc = "Highlight yanked text and restore cursor",
})

--- CursorLineNr Highlight ---
-- Dynamically changes the highlight of the CursorLineNr to match the lualine mode color.
local function update_cursorlinenr_highlight()
  local mode_to_group = {
    n = "lualine_a_normal",
    i = "lualine_a_insert",
    v = "lualine_a_visual",
    V = "lualine_a_visual",
    ["\22"] = "lualine_a_visual", -- Ctrl-V (block visual)
    c = "lualine_a_command",
    R = "lualine_a_replace",
    r = "lualine_a_replace", -- pending replace
    s = "lualine_a_select",
    S = "lualine_a_select",
    ["\19"] = "lualine_a_select", -- Ctrl-S (block select)
    t = "lualine_a_terminal",
  }

  local mode = vim.fn.mode()
  local group_name = mode_to_group[mode] or "Normal"
  local attrs = vim.api.nvim_get_hl(0, { name = group_name, link = false })

  if attrs and attrs.bg then
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = attrs.bg })
  else
    vim.api.nvim_set_hl(0, "CursorLineNr", { link = "Normal" })
  end
end

vim.api.nvim_create_autocmd({ "ModeChanged", "VimEnter" }, {
  group = augroup,
  desc = "Update CursorLineNr highlight based on mode",
  callback = update_cursorlinenr_highlight,
})

--- Restore Cursor Position on File Read ---
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  desc = "Restore cursor to last position",
  callback = function(args)
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if line_count > 0 and vim.fn.line("'" .. '"') > 0 and vim.fn.line("'" .. '"') <= line_count then
      vim.cmd('normal! g`"')
    end
  end,
})

--- Remove Trailing Whitespace on Save ---
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  desc = "Remove trailing whitespace on save",
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

--- Close help/man pages with 'q' ---
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  desc = "Close help/man pages with 'q'",
  pattern = { "help", "man" },
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "q", ":quit<CR>", { noremap = true, silent = true })
  end,
})

--- Equalize windows on resize ---
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  desc = "Equalize window sizes on Vim resize",
  callback = function()
    vim.cmd("wincmd =")
  end,
})

--- Filetype-Specific Settings ---
-- A table that maps filetypes to a table of options.
-- This is a cleaner way to manage multiple filetype-specific settings.
local filetype_options = {
  markdown = {
    wrap = true,
    spell = true,
  },
  gitcommit = {
    wrap = true,
    spell = true,
  },
}

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  desc = "Set filetype-specific options",
  callback = function(args)
    local options = filetype_options[args.match]
    if options then
      for key, value in pairs(options) do
        vim.wo[key] = value
      end
    end
  end,
})

-- ===============================
--      KEYMAPS CONFIGURATION
-- ===============================

-- Set leader key (space)
vim.g.mapleader = " "

-- Shorten function name for convenience
local keymap = vim.keymap.set

-- ╭─────────────────────────────────────────────────────────────╮
-- │                       GENERAL MAPPINGS                      │
-- ╰─────────────────────────────────────────────────────────────╯

-- Disable suspend
keymap({ "n", "v", "x", "o", "t" }, "<C-z>", "<nop>", { noremap = true, silent = true, desc = "Disable suspend" })

-- Unbind the single-quote mark jump, which you are disabling
-- Consider removing this if you want to use marks
keymap("n", "'", "<nop>", { noremap = true, silent = true, desc = "Disable single quote" })

-- Unbind command-line window `q:`
keymap("n", "q:", "<nop>", { noremap = true, silent = true, desc = "Disable command-line window" })

-- Disable Ctrl-F in normal mode only, keep for insert mode
keymap("n", "<C-f>", "<nop>", { noremap = true, silent = true, desc = "Disable Ctrl-F" })

-- Disable 's' in normal mode
keymap("n", "s", "<nop>", { noremap = true, silent = true, desc = "Disable s key" })

-- Exit insert mode quickly by pressing 'jk'
keymap("i", "jk", "<Esc>", { noremap = true, silent = true, desc = "Exit insert mode with jk" })

-- Clear search highlights with <Esc> in normal mode
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { noremap = true, silent = true, desc = "Clear search highlights" })

-- Select all text with <C-a> in normal mode
keymap("n", "<C-a>", "gg<S-v>G", { noremap = true, silent = true, desc = "Select all" })

-- Exit terminal mode with double <Esc>
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Exit terminal mode" })

-- Use black hole register when deleting with 'x' (no yank)
keymap("n", "x", '"_x', { noremap = true, silent = true, desc = "Delete without yanking" })

-- Clear system clipboard via <leader>cc
keymap("n", "<leader>cc", function()
  vim.fn.setreg("+", "")
end, { noremap = true, silent = true, desc = "Clear system clipboard" })

-- Delete whole word in insert mode with Ctrl+Backspace
keymap("i", "<C-BS>", "<C-w>", { noremap = true, silent = true, desc = "Delete previous word" })

-- More reliable way to delete the whole line in insert mode
keymap("i", "<C-d>", "<C-o>dd", { noremap = true, silent = true, desc = "Delete whole line in insert mode" })

-- ╭─────────────────────────────────────────────────────────────╮
-- │                     WINDOW MANAGEMENT                       │
-- ╰─────────────────────────────────────────────────────────────╯

keymap("n", "<leader>wv", "<C-w>v", { noremap = true, silent = true, desc = "Split window vertically" })
keymap("n", "<leader>wh", "<C-w>s", { noremap = true, silent = true, desc = "Split window horizontally" })
keymap("n", "<leader>we", "<C-w>=", { noremap = true, silent = true, desc = "Make splits equal size" })
keymap("n", "<leader>wx", "<cmd>close<CR>", { noremap = true, silent = true, desc = "Close current split" })
keymap("n", "<leader>wo", "<C-w>o", { noremap = true, silent = true, desc = "Close all splits except current" })

-- Window navigation (like tmux)
keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, desc = "Focus left window" })
keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, desc = "Focus lower window" })
keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, desc = "Focus upper window" })
keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, desc = "Focus right window" })

-- ╭─────────────────────────────────────────────────────────────╮
-- │                      LINE OPERATIONS                        │
-- ╰─────────────────────────────────────────────────────────────╯

-- Delete current line using black hole register (no yank) in normal mode
keymap("n", "<C-x>", '"_dd', { noremap = true, silent = true, desc = "Delete line (no yank)" })

-- Delete current line using black hole register in insert mode
keymap("i", "<C-x>", '<Esc>"_ddi', { noremap = true, silent = true, desc = "Delete line (no yank) in insert mode" })

-- ╭─────────────────────────────────────────────────────────────╮
-- │              OPTIONAL: NUMBER INCREMENT                     │
-- ╰─────────────────────────────────────────────────────────────╯

-- Alt+Up to increment number, Alt+Down to decrement number
keymap("n", "<A-Up>", "<C-a>", { noremap = true, silent = true, desc = "Increment number" })
keymap("n", "<A-Down>", "<C-x>", { noremap = true, silent = true, desc = "Decrement number" })

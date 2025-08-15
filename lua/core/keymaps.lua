-- ===============================
--      KEYMAPS CONFIGURATION
-- ===============================

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Short alias
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ╭─────────────────────────────────────────────────────────────╮
-- │                       GENERAL MAPPINGS                      │
-- ╰─────────────────────────────────────────────────────────────╯

-- Disable suspend
keymap({ "n", "v", "x", "o", "t" }, "<C-z>", "<nop>", opts)

-- Disable single-quote jump (if you never use marks)
keymap("n", "'", "<nop>", opts)

-- Disable command-line window
keymap("n", "q:", "<nop>", opts)

-- Disable 's' in normal mode
keymap("n", "s", "<nop>", opts)

-- Exit insert mode quickly
keymap("i", "jk", "<Esc>", opts)

-- Clear search highlights with <Esc>
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- Select all
keymap("n", "<C-a>", "gg<S-v>G", opts)

-- Exit terminal mode with double <Esc>
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", opts)

-- Delete/change without yanking
keymap({ "n", "x" }, "x", '"_x', opts)
keymap({ "n", "x" }, "c", '"_c', opts)
keymap("n", "C", '"_C', opts)
keymap("n", "<A-d>", '"_cc', opts)

-- Clear system clipboard
keymap("n", "<leader>cc", function()
  vim.fn.setreg("+", "")
end, vim.tbl_extend("force", opts, { desc = "Clear clipboard" }))

-- Delete previous word in insert mode
keymap("i", "<C-BS>", "<C-w>", opts)

-- Delete whole line in insert mode
keymap("i", "<C-d>", "<C-o>dd", opts)

-- ╭─────────────────────────────────────────────────────────────╮
-- │                     WINDOW MANAGEMENT                       │
-- ╰─────────────────────────────────────────────────────────────╯

-- Split windows
keymap("n", "<leader>wv", "<C-w>v", opts)
keymap("n", "<leader>wh", "<C-w>s", opts)
keymap("n", "<leader>we", "<C-w>=", opts)
keymap("n", "<leader>wx", "<cmd>close<CR>", opts)
keymap("n", "<leader>wo", "<C-w>o", opts)

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize splits
keymap("n", "<A-Left>", "<cmd>vertical resize -2<CR>", opts)
keymap("n", "<A-Right>", "<cmd>vertical resize +2<CR>", opts)
keymap("n", "<A-Up>", "<cmd>resize -2<CR>", opts)
keymap("n", "<A-Down>", "<cmd>resize +2<CR>", opts)

-- ╭─────────────────────────────────────────────────────────────╮
-- │                      LINE OPERATIONS                        │
-- ╰─────────────────────────────────────────────────────────────╯

-- Delete current line (no yank)
keymap("n", "<C-x>", '"_dd', opts)
keymap("i", "<C-x>", '<Esc>"_ddi', opts)

-- Move lines up/down (normal/visual)
keymap("n", "<A-j>", ":m .+1<CR>==", opts)
keymap("n", "<A-k>", ":m .-2<CR>==", opts)
keymap("x", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap("x", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- ╭─────────────────────────────────────────────────────────────╮
-- │                 NUMBER INCREMENT / DECREMENT                 │
-- ╰─────────────────────────────────────────────────────────────╯

keymap("n", "<A-Up>", "<C-a>", opts)
keymap("n", "<A-Down>", "<C-x>", opts)

-- ╭─────────────────────────────────────────────────────────────╮
-- │                   QUICK SAVE / QUIT                          │
-- ╰─────────────────────────────────────────────────────────────╯

keymap("n", "<leader>w", "<cmd>w<CR>", opts)
keymap("n", "<leader>q", "<cmd>q<CR>", opts)
keymap("n", "<leader>Q", "<cmd>q!<CR>", opts)

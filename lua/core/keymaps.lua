-- ===============================
--      KEYMAPS CONFIGURATION
-- ===============================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ╭─────────────────────────────────────────────────────────────╮
-- │                 GENERAL MAPPINGS                            │
-- ╰─────────────────────────────────────────────────────────────╯

-- Clear search highlights with leader-ch
keymap("n", "<leader>ch", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Clear search highlights and pattern with <Esc> in normal mode
keymap("n", "<Esc>", function()
  if vim.v.hlsearch == 1 then
    vim.cmd("nohlsearch")
    vim.fn.setreg("/", "")
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  end
end, { desc = "Clear search highlights and pattern", noremap = true, silent = true })

-- Select all with a common keyboard shortcut
keymap("n", "<C-a>", "ggVG", { desc = "Select all" })

-- Exit terminal mode with double <Esc>
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Delete/change without yanking (using the black hole register)
keymap({ "n", "x" }, "x", '"_x', { desc = "Delete character (no yank)" })
keymap({ "n", "x" }, "c", '"_c', { desc = "Change text (no yank)" })
keymap("n", "C", '"_C', { desc = "Change rest of line (no yank)" })
keymap("n", "<A-d>", '"_cc', { desc = "Delete current line (no yank)" })

-- Clear system clipboard
keymap("n", "<leader>cc", function()
  vim.fn.setreg("+", "")
end, { desc = "Clear system clipboard" })

-- Insert mode operations
keymap("i", "<C-BS>", "<C-w>", { desc = "Delete previous word in insert mode" })
keymap("i", "<C-d>", "<C-o>dd", { desc = "Delete current line in insert mode" })

-- ╭─────────────────────────────────────────────────────────────╮
-- │                  WINDOW MANAGEMENT                          │
-- ╰─────────────────────────────────────────────────────────────╯

-- Split windows
keymap("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
keymap("n", "<leader>wh", "<C-w>s", { desc = "Split window horizontally" })
keymap("n", "<leader>we", "<C-w>=", { desc = "Balance window sizes" })
keymap("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close current window" })
keymap("n", "<leader>wo", "<C-w>o", { desc = "Close other windows" })

-- -- Window navigation with Ctrl + H/J/K/L
-- keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
-- keymap("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
-- keymap("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
-- keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
--
-- ╭─────────────────────────────────────────────────────────────╮
-- │                  LINE OPERATIONS                            │
-- ╰─────────────────────────────────────────────────────────────╯

-- Move lines up/down (normal/visual)
-- Uncomment if you want these:
-- keymap("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
-- keymap("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
-- keymap("x", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
-- keymap("x", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- ╭─────────────────────────────────────────────────────────────╮
-- │             NUMBER INCREMENT / DECREMENT                    │
-- ╰─────────────────────────────────────────────────────────────╯

keymap("n", "<leader>a", "<C-a>", { desc = "Increment number under cursor" })
keymap("n", "<leader>x", "<C-x>", { desc = "Decrement number under cursor" })

-- ╭─────────────────────────────────────────────────────────────╮
-- │                 QUICK SAVE / QUIT                           │
-- ╰─────────────────────────────────────────────────────────────╯

keymap("n", "<leader>ww", "<cmd>w<CR>", { desc = "Save file" })
keymap("n", "<leader>qq", "<cmd>q<CR>", { desc = "Quit current buffer" })
keymap("n", "<leader>QQ", "<cmd>q!<CR>", { desc = "Force quit buffer" })

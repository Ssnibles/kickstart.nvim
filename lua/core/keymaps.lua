-- ~/.config/nvim/lua/core/keymaps.lua
-- Leaders are set in init.lua to ensure early availability.

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Clear search highlight
map("n", "<leader>ch", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight", unpack(opts) })

-- <Esc>: clear highlight if active, else behave normally
map("n", "<Esc>", function()
  if vim.v.hlsearch == 1 then
    vim.cmd.nohlsearch()
    vim.fn.setreg("/", "")
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  end
end, { desc = "Smart clear highlight", unpack(opts) })

-- Select all
map("n", "<C-a>", "ggVG", { desc = "Select all", unpack(opts) })

-- Terminal: double <Esc> to leave Terminal mode (single <Esc> passes through)
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal", unpack(opts) })

-- Don't yank on single-char delete
map({ "n", "x" }, "x", '"_x', { desc = "Delete char (no yank)", unpack(opts) })

-- Change without yanking
map({ "n", "x" }, "c", '"_c', { desc = "Change (no yank)", unpack(opts) })
map("n", "C", '"_C', { desc = "Change to EOL (no yank)", unpack(opts) })

-- Delete current line (no yank), stay in Normal mode
map("n", "<A-d>", '"_dd', { desc = "Delete line (no yank)", unpack(opts) })

-- Clear system clipboard
map("n", "<leader>cc", function()
  vim.fn.setreg("+", "")
end, { desc = "Clear + register", unpack(opts) })

-- Insert mode: word delete and line delete
map("i", "<C-BS>", "<C-w>", { desc = "Delete previous word", unpack(opts) })
map("i", "<C-d>", "<C-o>dd", { desc = "Delete current line", unpack(opts) })

-- Splits and windows
map("n", "<leader>wv", "<C-w>v", { desc = "Vertical split", unpack(opts) })
map("n", "<leader>wh", "<C-w>s", { desc = "Horizontal split", unpack(opts) })
map("n", "<leader>we", "<C-w>=", { desc = "Balance windows", unpack(opts) })
map("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close window", unpack(opts) })
map("n", "<leader>wo", "<C-w>o", { desc = "Close other windows", unpack(opts) })

-- Number increment/decrement helpers
map("n", "<leader>a", "<C-a>", { desc = "Increment number", unpack(opts) })
map("n", "<leader>x", "<C-x>", { desc = "Decrement number", unpack(opts) })

-- Save / quit
map("n", "<leader>ww", "<cmd>w<CR>", { desc = "Save", unpack(opts) })
map("n", "<leader>qq", "<cmd>q<CR>", { desc = "Quit", unpack(opts) })
map("n", "<leader>QQ", "<cmd>q!<CR>", { desc = "Force quit", unpack(opts) })

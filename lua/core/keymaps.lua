-- ===============================
--      KEYMAPS CONFIGURATION
-- ===============================
-- See :help vim.keymap.set()

-- Set leader key (space)
vim.g.mapleader = " "

-- Shorten function name for convenience
local keymap = vim.keymap.set

-- ╭─────────────────────────────────────────────────────────────╮
-- │                      GENERAL MAPPINGS                       │
-- ╰─────────────────────────────────────────────────────────────╯

-- Disable accidental suspend (<C-z>) in all modes
keymap(
  { "n", "v", "i", "s", "x", "o", "c", "t" },
  "<C-z>",
  "<Nop>",
  { noremap = true, silent = true, desc = "Disable suspend" }
)

-- Disable single quote (') and Shift+' in normal mode
keymap("n", "'", "<Nop>", { noremap = true, desc = "Disable single quote" })
keymap("n", "<S-'>", "<Nop>", { noremap = true, desc = "Disable Shift+'" })

-- Disable some other things
keymap("c", "<C-F>", "<nop>", { noremap = true, silent = true })
keymap("n", "s", "<nop>")
keymap("c", "<C-d>", "<nop>", { noremap = true, silent = true })
keymap("c", "<C-s>", "<nop>")

-- Exit insert mode quickly by pressing 'jk'
keymap("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- Clear search highlights with <Esc> in normal mode
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Unbind <C-a> (increment number) if you don't want it
keymap("n", "<C-a>", "<Nop>", { desc = "Unbind increment" })

-- Exit terminal mode with double <Esc>
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Remap x to send to black hole instead of clipboard
keymap("n", "x", '"_x')

-- Basic single-character deletion (doesn't work for operators)
keymap("n", "c", '"_c', { noremap = true })

-- Full operator mapping requiring motion (e.g., cw, ciw)
keymap("n", "c", '"_c', { noremap = true, expr = false })

-- Clear system clipboard (requires clipboard tools)
keymap("n", "<leader>cc", function()
  vim.fn.setreg("+", "") -- Clear "+ register (system clipboard)
end, { desc = "Clear system clipboard" })

-- Select all
keymap("n", "<C-a>", "gg<S-v>G")

keymap("i", "<C-BS>", "<C-w>", { noremap = true, silent = true }) -- Delete whole word
keymap("i", "<C-Del>", '<ESC>"ccc', { noremap = true, silent = true }) -- Delte whole line

-- ╭─────────────────────────────────────────────────────────────╮
-- │                      WINDOW MANAGEMENT                      │
-- ╰─────────────────────────────────────────────────────────────╯

keymap("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
keymap("n", "<leader>wh", "<C-w>s", { desc = "Split window horizontally" })
keymap("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" })
keymap("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close current split" })
keymap("n", "<leader>wo", "<C-w>o", { desc = "Close all splits except current" })

-- Window navigation (like tmux)
keymap("n", "<C-h>", "<C-w>h", { desc = "Focus left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Focus lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Focus upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Focus right window" })

-- ╭─────────────────────────────────────────────────────────────╮
-- │                      LINE OPERATIONS                        │
-- ╰─────────────────────────────────────────────────────────────╯

-- Delete current line using black hole register (no yank)
keymap("n", "<C-x>", '"_dd', { noremap = true, silent = true, desc = "Delete line (no yank)" })
keymap("i", "<C-x>", '<Esc>"_ddi', { noremap = true, silent = true, desc = "Delete line (no yank) in insert" })

-- ╭─────────────────────────────────────────────────────────────╮
-- │                  OPTIONAL: NUMBER INCREMENT                 │
-- ╰─────────────────────────────────────────────────────────────╯

-- Uncomment for Alt+Up/Down to increment/decrement numbers
keymap("n", "<A-Up>", "<C-a>", { desc = "Increment number" })
keymap("n", "<A-Down>", "<C-x>", { desc = "Decrement number" })

-- ===============================
--           END OF MAPPINGS
-- ===============================

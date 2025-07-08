--  see `:help lua-guide-autocommands`

-- Define the "currentline" sign with proper namespace and styling
-- vim.fn.sign_define("currentline", {
--   text = "▶", -- More visible symbol
--   texthl = "LineNr", -- Link to existing highlight group
--   numhl = "LineNr", -- Maintain number column appearance
-- })

-- Highlight text on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", {}),
  desc = "Highlight selection on yank",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 500 })
  end,
})

-- Disable diagnostics in insert mode (for better performance)
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  desc = "Disable diagnostics in insert mode",
  group = vim.api.nvim_create_augroup("diagnostics_insert", { clear = true }),
  callback = function()
    vim.diagnostic.enable(false)
  end,
})
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("diagnostics_normal", { clear = true }),
  callback = function()
    vim.diagnostic.enable()
  end,
})

-- Auto-fix imports on save for TypeScript/JavaScript
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
  callback = function()
    local clients = vim.lsp.get_active_clients({ name = "tsserver" })
    if #clients > 0 then
      vim.lsp.buf.code_action({
        context = { only = { "source.organizeImports" } },
        apply = true,
      })
    end
  end,
})

-- Automatically expand React fragments
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescriptreact", "javascriptreact" },
  callback = function()
    vim.keymap.set("i", "<C-f>", "<><Esc>hi</><Esc>4hi", { buffer = true })
  end,
})

-- Typewriter mode (centered cursor)
local typewriter_mode = false
local function toggle_typewriter()
  typewriter_mode = not typewriter_mode
  if typewriter_mode then
    -- Enable typewriter mode
    vim.wo.scrolloff = 999     -- Center vertically
    vim.wo.sidescrolloff = 999 -- Center horizontally
    vim.wo.colorcolumn = "80"  -- Optional: show line length marker
    vim.notify("Typewriter mode ON ✍️", vim.log.levels.INFO)
  else
    -- Disable typewriter mode
    vim.wo.scrolloff = 5     -- Default value (adjust to your preference)
    vim.wo.sidescrolloff = 0 -- Default value
    vim.wo.colorcolumn = ""  -- Clear line length marker
    vim.notify("Typewriter mode OFF ✍️", vim.log.levels.INFO)
  end
end
vim.keymap.set("n", "<leader>tw", toggle_typewriter, { desc = "Toggle typewriter mode" })

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
  -- Add more as needed
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

-- vim.api.nvim_create_autocmd("BufRead,BufNewFile", {
--   pattern = "config",
--   callback = function() vim.bo.filetype = "json" end,
-- })

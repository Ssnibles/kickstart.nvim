--  see `:help lua-guide-autocommands`

-- Define the "currentline" sign with proper namespace and styling
-- vim.fn.sign_define("currentline", {
--   text = "▶", -- More visible symbol
--   texthl = "LineNr", -- Link to existing highlight group
--   numhl = "LineNr", -- Maintain number column appearance
-- })

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
    vim.wo.scrolloff = 999 -- Center vertically
    vim.wo.sidescrolloff = 999 -- Center horizontally
    vim.wo.colorcolumn = "80" -- Optional: show line length marker
    vim.notify("Typewriter mode ON ✍️", vim.log.levels.INFO)
  else
    -- Disable typewriter mode
    vim.wo.scrolloff = 5 -- Default value (adjust to your preference)
    vim.wo.sidescrolloff = 0 -- Default value
    vim.wo.colorcolumn = "" -- Clear line length marker
    vim.notify("Typewriter mode OFF ✍️", vim.log.levels.INFO)
  end
end
vim.keymap.set("n", "<leader>tw", toggle_typewriter, { desc = "Toggle typewriter mode" })

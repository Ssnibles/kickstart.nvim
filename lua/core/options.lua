-- ~/.config/nvim/lua/core/options.lua

local g, o = vim.g, vim.opt

-- Icons assume a Nerd Font
g.have_nerd_font = true

-- Disable netrw when using an alternative file explorer
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- Neovide-specific UI
if g.neovide then
  o.guifont = "JetBrainsMono Nerd Font:h12"
  g.neovide_scale_factor = 1.0
  g.neovide_refresh_rate = 144
  g.neovide_hide_mouse_when_typing = true
  g.neovide_floating_shadow = false
  g.neovide_scroll_animation_length = 0.3
  g.neovide_cursor_animation_length = 0.05
  g.neovide_cursor_trail_length = 0.2
  g.neovide_cursor_vfx_mode = "pixie"
  g.neovide_cursor_vfx_opacity = 150.0
  g.neovide_cursor_vfx_particle_lifetime = 0.8
  g.neovide_cursor_vfx_particle_density = 3.0
  g.neovide_cursor_vfx_particle_speed = 5.0
  g.neovide_cursor_animate_in_insert_mode = false
  g.neovide_cursor_animate_command_line = false
  g.neovide_padding_top = 5
  g.neovide_padding_bottom = 5
  g.neovide_padding_left = 5
  g.neovide_padding_right = 5
  g.neovide_fullscreen = false
  g.neovide_floating_blur = false
  g.neovide_remember_window_size = true
  g.neovide_input_use_logo = true
  g.neovide_refresh_rate_idle = 5
end

-- Clipboard
o.clipboard = "unnamedplus"

-- Tabs & indentation
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.smartindent = true
o.autoindent = true
o.breakindent = true

-- Wrapping
o.wrap = false
o.linebreak = true -- used when wrap is toggled on

-- Line numbers & cursor
o.number = true
o.relativenumber = true
o.cursorline = true
o.cursorlineopt = "number,line"

-- Visuals
o.termguicolors = true
o.signcolumn = "yes"
o.scrolloff = 8
o.sidescrolloff = 8
o.list = true
o.listchars = {
  tab = "▸ ",
  trail = "·",
  nbsp = "␣",
  extends = "»",
  precedes = "«",
  eol = "↲",
}
o.fillchars = {
  eob = " ",
  fold = " ",
  foldopen = "",
  foldclose = "",
  foldsep = "│",
  vert = "│",
  horiz = "─",
  horizup = "┴",
  horizdown = "┬",
  vertleft = "┤",
  vertright = "├",
  verthoriz = "┼",
}

-- Search
o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.incsearch = true
o.inccommand = "split"
o.showmatch = true

-- Performance
o.updatetime = 200
o.timeoutlen = 1000
o.redrawtime = 150
o.synmaxcol = 500

-- Files
o.undofile = true
o.swapfile = false
o.backup = false
o.writebackup = false
o.autoread = true

-- Windows
o.splitright = true
o.splitbelow = true
o.splitkeep = "screen"

-- Mouse
o.mouse = "a" -- enable in all modes

-- Interface
o.laststatus = 3
o.showmode = false
o.completeopt = { "menuone", "noinsert", "noselect" }
o.viewoptions = { "folds", "cursor", "curdir", "slash", "unix" }
o.showtabline = 1
o.wildmenu = true
o.wildmode = { "longest:full", "full" }
o.pumheight = 12
o.cmdheight = 0 -- modern minimal cmdline

-- Folding
o.foldmethod = "indent"
o.foldlevel = 99
o.foldenable = true

-- Encoding
o.fileencoding = "utf-8"
o.encoding = "utf-8"

-- Misc
o.title = true
o.backspace = { "start", "eol", "indent" }
o.confirm = true

-- UI highlights
local set_hl = vim.api.nvim_set_hl
local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
set_hl(0, "NormalFloat", { bg = normal.bg, fg = normal.fg })
set_hl(0, "FloatBorder", { bg = normal.bg, fg = "#565f89" })

-- Plugin/UI-specific highlights
set_hl(0, "IndentLine", { fg = "#565f89" })
set_hl(0, "FzfLuaBorder", { bg = normal.bg, fg = "#565f89" })
set_hl(0, "FzfLuaNormal", { bg = normal.bg, fg = normal.fg })
set_hl(0, "BlinkCmpMenu", { bg = normal.bg, fg = "#565f89" })
set_hl(0, "BlinkCmpMenuBorder", { bg = normal.bg, fg = "#565f89" })
set_hl(0, "BlinkCmpDoc", { bg = normal.bg, fg = "#565f89" })
set_hl(0, "BlinkCmpDocBorder", { bg = normal.bg, fg = "#565f89" })
set_hl(0, "BlinkCmpDocSeparator", { bg = normal.bg, fg = "#565f89" })
set_hl(0, "BlinkCmpSignatureHelp", { bg = normal.bg, fg = "#565f89" })
set_hl(0, "BlinkCmpSignatureHelpBorder", { bg = normal.bg, fg = "#565f89" })
set_hl(0, "NoiceCmdline", { bg = normal.bg, fg = "#565f89" })
set_hl(0, "NoiceCmdlinePopup", { bg = normal.bg })
set_hl(0, "NoiceCmdlinePopupBorder", { bg = normal.bg, fg = "#565f89" })

-- LSP: disable signature help popups
vim.lsp.handlers["textDocument/signatureHelp"] = function() end

-- Terminal windows: hide gutters
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  command = "setlocal nonumber norelativenumber signcolumn=no",
})

-- Diagnostics: stable signs and ordering
vim.diagnostic.config({
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
    },
  },
})

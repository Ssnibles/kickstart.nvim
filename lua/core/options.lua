--            __  __  _
--   ___ ___ / /_/ /_(_)__  ___ ____
--  (_-</ -_) __/ __/ / _ \/ _ `(_-<
-- /___/\__/\__/\__/_/_//_/\_, /___/
--                        /___/

-- =========================
--  GLOBAL & CORE SETTINGS
-- =========================

local global = vim.g
local option = vim.opt

-- General global Neovim settings
global.have_nerd_font = true
-- global.loaded_netrw = 1
-- global.loaded_netrePlugin = 1

-- =========================
--  NEOVIDE-SPECIFIC SETTINGS
-- =========================

if global.neovide then
  -- Font
  option.guifont = "JetBrainsMono Nerd Font:h12"

  -- Appearance & Scaling
  global.neovide_scale_factor = 1.0
  global.neovide_refresh_rate = 144
  global.neovide_hide_mouse_when_typing = true
  global.neovide_floating_shadow = false

  -- Scrolling
  global.neovide_scroll_animation_length = 0.3

  -- Cursor
  global.neovide_cursor_animation_length = 0.05
  global.neovide_cursor_trail_length = 0.2
  global.neovide_cursor_vfx_mode = "pixie"
  global.neovide_cursor_vfx_opacity = 150.0
  global.neovide_cursor_vfx_particle_lifetime = 0.8
  global.neovide_cursor_vfx_particle_density = 3.0
  global.neovide_cursor_vfx_particle_speed = 5.0
  global.neovide_cursor_animate_in_insert_mode = false
  global.neovide_cursor_animate_command_line = false

  -- Window Padding
  global.neovide_padding_top = 5
  global.neovide_padding_bottom = 5
  global.neovide_padding_left = 5
  global.neovide_padding_right = 5

  -- Fullscreen & Floating
  global.neovide_fullscreen = false
  global.neovide_floating_blur = false

  -- Advanced
  global.neovide_remember_window_size = true
  global.neovide_input_use_logo = true -- Enable Super/Logo key

  -- Performance
  global.neovide_refresh_rate_idle = 5
end

-- =========================
--  CORE EDITOR OPTIONS
-- =========================

local function set_options(options)
  for k, v in pairs(options) do
    option[k] = v
  end
end

set_options({
  -- Clipboard
  clipboard = "unnamedplus",

  -- Text formatting
  expandtab = true,
  shiftwidth = 2,
  tabstop = 2,
  softtabstop = 2,
  smartindent = true,
  autoindent = true,
  wrap = true,
  breakindent = true,

  -- Line numbers & Cursor
  number = true,
  relativenumber = true,
  cursorline = true,
  cursorlineopt = "both",

  -- Visuals
  winbar = "",
  termguicolors = true,
  list = true,
  listchars = {
    tab = "▸ ",
    trail = "·",
    nbsp = "␣",
    extends = "»",
    precedes = "«",
  },
  fillchars = {
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
  },

  -- Search
  ignorecase = true,
  smartcase = true,
  hlsearch = true,
  incsearch = true,
  inccommand = "split",

  -- Performance
  lazyredraw = false,
  updatetime = 250,
  timeoutlen = 300,
  redrawtime = 150,
  synmaxcol = 500,
  ttyfast = true,

  -- File handling
  undofile = true,
  swapfile = false,
  backup = false,
  writebackup = false,
  autoread = true,

  -- Window management
  splitright = true,
  splitbelow = true,
  splitkeep = "cursor",
  mouse = "a",
  scrolloff = 10,
  sidescrolloff = 10,

  -- Interface
  wildmenu = true,
  wildmode = "longest:full,full",
  completeopt = "noselect",
  viewoptions = "folds,cursor,curdir,slash,unix",
  showtabline = 0,

  -- Folding
  foldlevelstart = 99,

  -- Encoding
  fileencoding = "utf-8",
  encoding = "utf-8",

  -- Miscellaneous
  title = true,
  backspace = { "start", "eol", "indent" },
})

-- =========================
--  UI HIGHLIGHTS & APPEARANCE
-- =========================

local setHighlights = vim.api.nvim_set_hl
local nontext_hl = vim.api.nvim_get_hl(0, { name = "NonText" })
local normal = vim.api.nvim_get_hl(0, { name = "Normal" })

-- Floating windows (global)
setHighlights(0, "NormalFloat", { bg = normal.bg, fg = normal.fg })
setHighlights(0, "FloatBorder", { bg = normal.bg, fg = "#565f89" })

-- fzf-lua specific
setHighlights(0, "FzfLuaBorder", { bg = normal.bg, fg = "#565f89" })
setHighlights(0, "FzfLuaNormal", { bg = normal.bg, fg = normal.fg })

-- blink.cmp specific
setHighlights(0, "BlinkCmpMenu", { bg = normal.bg, fg = "#565f89" })
setHighlights(0, "BlinkCmpMenuBorder", { bg = normal.bg, fg = "#565f89" })
setHighlights(0, "BlinkCmpDoc", { bg = normal.bg, fg = "#565f89" })
setHighlights(0, "BlinkCmpDocBorder", { bg = normal.bg, fg = "#565f89" })
setHighlights(0, "BlinkCmpDocSeparator", { bg = normal.bg, fg = "#565f89" })
setHighlights(0, "BlinkCmpSignatureHelp", { bg = normal.bg, fg = "#565f89" })
setHighlights(0, "BlinkCmpSignatureHelpBorder", { bg = normal.bg, fg = "#565f89" })

-- Noice.nvim specific
setHighlights(0, "NoiceCmdline", { bg = normal.bg, fg = "#565f89" })
setHighlights(0, "NoiceCmdlinePopup", { bg = normal.bg, fg = "#565f89" })
setHighlights(0, "NoiceCmdlinePopupBorder", { bg = normal.bg, fg = "#565f89" })

-- Hybrid highlight for CursorLineNr
setHighlights(0, "CursorLineNr", {
  fg = nontext_hl.fg,
  bg = nontext_hl.bg,
  bold = false,
  italic = true,
  undercurl = nontext_hl.undercurl,
  underline = nontext_hl.underline,
})

-- =========================
--  AUTOCOMMANDS & DIAGNOSTICS
-- =========================

-- Disable LSP signature help
vim.lsp.handlers["textDocument/signatureHelp"] = function() end

-- Terminal: hide line numbers and signcolumn
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  command = "setlocal nonumber norelativenumber signcolumn=no",
})

-- Diagnostics configuration
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

-- =========================
--  END OF OPTIONS
-- =========================

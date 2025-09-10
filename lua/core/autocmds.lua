-- ~/.config/nvim/lua/core/autocmds.lua
local augroup = vim.api.nvim_create_augroup("GeneralAutocmds", { clear = true })

-- Configuration tables for better maintainability
local special_filetypes = {
    alpha = true,
    checkhealth = true,
    fzf = true,
    help = true,
    lazy = true,
    man = true,
    qf = true,
    NvimTree = true,
    startify = true,
    gitcommit = true,
    ["neo-tree"] = true, -- needs brackets due to hyphen
    Trouble = true,
    oil = true,
}

local special_buftypes = {
    nofile = true,
    acwrite = true,
    terminal = true,
    prompt = true,
    quickfix = true,
    help = true,
}

local closeable_types = {
    help = true,
    man = true,
    qf = true,
    lspinfo = true,
    checkhealth = true,
}

local text_filetypes = {
    markdown = true,
    text = true,
    txt = true,
    gitcommit = true,
}

local indent_detection_filetypes = {
    lua = true,
    python = true,
    vim = true,
    c = true,
    cpp = true,
    rust = true,
    go = true,
    yaml = true,
    json = true,
}

-- Utility functions
local function is_special_buffer(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    if not vim.api.nvim_buf_is_valid(bufnr) then
        return true
    end

    local buftype = vim.bo[bufnr].buftype
    local filetype = vim.bo[bufnr].filetype

    return special_buftypes[buftype] or special_filetypes[filetype]
end

-- Cache for lualine theme colors to avoid repeated lookups
local mode_color_cache = {}
local function get_mode_color(mode)
    if mode_color_cache[mode] then
        return mode_color_cache[mode]
    end

    local ok, lualine = pcall(require, "lualine")
    if not ok then
        return nil
    end

    local config = lualine.get_config()
    if not config or not config.options then
        return nil
    end

    local theme = config.options.theme
    if type(theme) == "string" then
        ok, theme = pcall(require, "lualine.themes." .. theme)
        if not ok then
            return nil
        end
    end

    if not theme or type(theme) ~= "table" then
        return nil
    end

    local mode_map = {
        n = theme.normal,
        i = theme.insert,
        v = theme.visual,
        V = theme.visual,
        ["\22"] = theme.visual, -- CTRL-V (needs brackets for special character)
        R = theme.replace,
        c = theme.command,
    }

    local mode_theme = mode_map[mode]
    local color = mode_theme and mode_theme.a and mode_theme.a.bg

    if color then
        mode_color_cache[mode] = color
    end

    return color
end

local function update_cursorline_color()
    if is_special_buffer() then
        return
    end

    local mode = vim.fn.mode():sub(1, 1)
    local color = get_mode_color(mode)

    if color then
        pcall(vim.api.nvim_set_hl, 0, "CursorLineNr", { fg = color, bold = true })
    end
end

-- Main buffer setup - handles most buffer-related configuration
vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
    group = augroup,
    callback = function(args)
        local bufnr = args.buf
        if not vim.api.nvim_buf_is_valid(bufnr) then
            return
        end

        local filetype = vim.bo[bufnr].filetype
        local is_special = is_special_buffer(bufnr)

        -- Set window-local options
        if vim.api.nvim_win_is_valid(0) then
            vim.wo.number = not is_special
            vim.wo.relativenumber = not is_special
            vim.wo.cursorline = not is_special
        end

        if is_special then
            -- Handle closeable buffers with 'q' mapping
            if closeable_types[filetype] then
                vim.bo[bufnr].buflisted = false
                vim.keymap.set("n", "q", "<cmd>close<cr>", {
                    buffer = bufnr,
                    silent = true,
                    desc = "Close buffer",
                })
            end
        else
            -- Configure text file settings
            if text_filetypes[filetype] then
                vim.opt_local.wrap = true
                vim.opt_local.spell = true
                vim.opt_local.linebreak = true
            end

            -- Restore cursor position to last known location
            local mark = vim.api.nvim_buf_get_mark(bufnr, '"')
            local line_count = vim.api.nvim_buf_line_count(bufnr)

            if mark[1] > 0 and mark[1] <= line_count and mark[2] >= 0 then
                pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
        end
    end,
})

-- Mode-based cursor line highlighting
vim.api.nvim_create_autocmd({ "VimEnter", "ModeChanged" }, {
    group = augroup,
    callback = update_cursorline_color,
})

-- Toggle relative numbers in insert mode for better editing experience
vim.api.nvim_create_autocmd("InsertEnter", {
    group = augroup,
    callback = function()
        if not is_special_buffer() and not vim.wo.diff then
            vim.wo.relativenumber = false
        end
    end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
    group = augroup,
    callback = function()
        if not is_special_buffer() and not vim.wo.diff then
            vim.wo.relativenumber = true
        end
    end,
})

-- Highlight yanked text briefly for visual feedback
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,
    callback = function()
        pcall(vim.highlight.on_yank, { timeout = 300 })
    end,
})

-- Window management - equalize splits on resize
vim.api.nvim_create_autocmd("VimResized", {
    group = augroup,
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
})

-- Cursorline management - show only in active window
vim.api.nvim_create_autocmd("WinEnter", {
    group = augroup,
    callback = function()
        if not is_special_buffer() then
            vim.wo.cursorline = true
        end
    end,
})

vim.api.nvim_create_autocmd("WinLeave", {
    group = augroup,
    callback = function()
        if vim.api.nvim_win_is_valid(0) then
            vim.wo.cursorline = false
        end
    end,
})

-- Auto-balance windows when one is closed
vim.api.nvim_create_autocmd("WinClosed", {
    group = augroup,
    callback = function()
        vim.defer_fn(function()
            if vim.fn.winnr("$") > 1 then
                vim.cmd("wincmd =")
            end
        end, 10)
    end,
})

-- File system operations
vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    callback = function(args)
        local bufnr = args.buf
        if not vim.api.nvim_buf_is_valid(bufnr) then
            return
        end

        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname == "" or vim.bo[bufnr].buftype ~= "" then
            return
        end

        -- Auto-create directories when saving files
        local dir = vim.fn.fnamemodify(bufname, ":h")
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
        end
    end,
})

-- Check for external file changes
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    group = augroup,
    callback = function(args)
        local bufnr = args.buf
        if not vim.api.nvim_buf_is_valid(bufnr) then
            return
        end

        if vim.bo[bufnr].buftype ~= "" or not vim.bo[bufnr].modifiable then
            return
        end

        vim.cmd("checktime")
    end,
})

-- Improve search experience with dynamic highlighting
vim.api.nvim_create_autocmd("CmdlineEnter", {
    group = augroup,
    pattern = { "/", "?" },
    callback = function()
        vim.opt.hlsearch = true
    end,
})

-- Clear search highlight when entering insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
    group = augroup,
    callback = function()
        vim.opt.hlsearch = false
    end,
})

-- Fold management - remember folds between sessions
vim.api.nvim_create_autocmd("BufWinLeave", {
    group = augroup,
    pattern = "*.*",
    callback = function(args)
        local bufnr = args.buf
        if not vim.api.nvim_buf_is_valid(bufnr) or
            vim.bo[bufnr].buftype ~= "" or
            not vim.bo[bufnr].modifiable then
            return
        end

        vim.cmd("mkview")
    end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    group = augroup,
    pattern = "*.*",
    callback = function(args)
        local bufnr = args.buf
        if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].buftype ~= "" then
            return
        end

        vim.cmd("silent! loadview")
    end,
})

-- Smart indentation detection based on file content
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup,
    callback = function(args)
        local bufnr = args.buf
        if not vim.api.nvim_buf_is_valid(bufnr) then
            return
        end

        local filetype = vim.bo[bufnr].filetype
        if not indent_detection_filetypes[filetype] then
            return
        end

        -- Analyze first 50 lines for indentation patterns
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 50, false)
        local tab_count = 0
        local space_counts = {}

        for _, line in ipairs(lines) do
            local leading = line:match("^%s*")
            if leading and #leading > 0 then
                if leading:match("^\t") then
                    tab_count = tab_count + 1
                else
                    local spaces = #leading
                    if spaces > 0 then
                        space_counts[spaces] = (space_counts[spaces] or 0) + 1
                    end
                end
            end
        end

        if tab_count > 0 then
            vim.bo[bufnr].expandtab = false
        else
            -- Find most common indentation (prefer 2, 4, or 8 spaces)
            local max_count = 0
            local common_indent = 4

            for spaces, count in pairs(space_counts) do
                if count > max_count and (spaces == 2 or spaces == 4 or spaces == 8) then
                    max_count = count
                    common_indent = spaces
                end
            end

            if max_count > 0 then
                vim.bo[bufnr].expandtab = true
                vim.bo[bufnr].shiftwidth = common_indent
                vim.bo[bufnr].tabstop = common_indent
                vim.bo[bufnr].softtabstop = common_indent
            end
        end
    end,
})

-- Auto-change directory to file's directory (for non-special buffers)
vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    callback = function(args)
        local bufnr = args.buf
        if not vim.api.nvim_buf_is_valid(bufnr) or is_special_buffer(bufnr) then
            return
        end

        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname == "" then
            return
        end

        local dir = vim.fn.fnamemodify(bufname, ":h")
        if vim.fn.isdirectory(dir) == 1 and dir ~= vim.fn.getcwd() then
            pcall(vim.cmd.lcd, vim.fn.fnameescape(dir))
        end
    end,
})

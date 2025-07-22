-- Disable Netrw to allow Oil to take over as the default file explorer.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- Required for file icons in Oil.
  -- Define custom keybindings for Oil.
  keys = {
    -- Toggle Oil at the current working directory (CWD).
    {
      "<leader>oo",
      function()
        local oil = require("oil")
        local cwd = vim.uv.cwd() -- Get the current working directory using libuv.
        -- If Oil is already open in the CWD, close it; otherwise, open it.
        if vim.bo.filetype == "oil" and oil.get_current_dir() == cwd then
          vim.cmd.close()
        else
          oil.open(cwd)
        end
      end,
      desc = "Toggle Oil at CWD",
    },
    -- Toggle Oil at the directory of the current buffer.
    {
      "<leader>ob",
      function()
        local oil = require("oil")
        local bufdir = vim.fn.expand("%:p:h") -- Get the directory of the current buffer.
        -- If Oil is already open in the buffer's directory, close it; otherwise, open it.
        if vim.bo.filetype == "oil" and oil.get_current_dir() == bufdir then
          vim.cmd.close()
        else
          oil.open(bufdir)
        end
      end,
      desc = "Toggle Oil at buffer directory",
    },
  },

  -- Oil plugin configuration options.
  opts = {
    default_file_explorer = true, -- Make Oil the default file explorer.
    delete_to_trash = true, -- Move deleted files to trash instead of permanent deletion.
    skip_confirm_for_simple_edits = true, -- Skip confirmation for simple file operations.
    prompt_save_on_select_new_entry = true, -- Prompt to save changes when selecting a new entry.
    watch_for_changes = true, -- Enable experimental watching for file system changes.

    -- View options for how files and directories are displayed.
    view_options = {
      show_hidden = true, -- Show hidden files (e.g., dotfiles).
      natural_order = true, -- Sort entries in a human-friendly natural order.
      -- Custom function to determine if a file is hidden.
      is_hidden_file = function(name)
        return vim.startswith(name, ".")
      end,
    },

    -- Columns to display in the Oil buffer.
    columns = { "icon", "permissions" },

    -- Buffer options specific to Oil buffers.
    buf_options = {
      buflisted = false, -- Do not list Oil buffers in the buffer list.
      bufhidden = "wipe", -- Wipe the buffer when it's no longer visible.
    },

    -- Window options specific to Oil windows.
    win_options = {
      wrap = false, -- Do not wrap lines.
      signcolumn = "no", -- Do not show the sign column.
      cursorline = true, -- Highlight the current line.
      number = true, -- Show line numbers.
      relativenumber = true, -- Show relative line numbers.
      foldcolumn = "0", -- Do not show the fold column.
      conceallevel = 3, -- Conceal text up to level 3 (useful for icons/placeholders).
      concealcursor = "nvic", -- Conceal text under the cursor in normal, visual, insert, and command-line modes.
    },

    -- Keymaps within the Oil buffer.
    keymaps = {
      ["g?"] = { "actions.show_help", mode = "n" },
      ["<CR>"] = "actions.select",
      ["<C-s>"] = { "actions.select", opts = { vertical = true } },
      ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
      ["<C-t>"] = { "actions.select", opts = { tab = true } },
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = { "actions.close", mode = "n" },
      ["<C-l>"] = "actions.refresh",
      ["-"] = { "actions.parent", mode = "n" },
      ["_"] = { "actions.open_cwd", mode = "n" },
      ["`"] = { "actions.cd", mode = "n" },
      ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
      ["gs"] = { "actions.change_sort", mode = "n" },
      ["gx"] = "actions.open_external",
      ["g."] = { "actions.toggle_hidden", mode = "n" },
      ["g\\"] = { "actions.toggle_trash", mode = "n" },
    },
  },

  -- Configuration function, executed after the plugin is loaded.
  config = function(_, opts)
    require("oil").setup(opts)

    -- Autocmd to open Oil when Neovim is started with a directory.
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function(event)
        if vim.fn.isdirectory(event.file) == 1 then
          require("oil").open(event.file)
        end
      end,
    })

    -- Autocmd for Oil filetype specific settings.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "oil",
      callback = function()
        vim.opt_local.spell = false -- Disable spellcheck in Oil buffers.
        -- The 'q' keymap to close Oil is already defined in `opts.keymaps`
        -- and is automatically buffer-local. No need to redefine it here.
      end,
    })
  end,
}

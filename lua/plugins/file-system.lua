-- MUST BE AT THE VERY TOP OF YOUR INIT.LUA OR PLUGIN CONFIG
-- These global variables are crucial to disable Neovim's built-in netrw
-- file explorer, preventing conflicts with plugins like Oil or Neo-tree.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

return {
  {
    "stevearc/oil.nvim",
    -- Set a high priority to ensure Oil loads early, as it can act as the
    -- default file explorer. `lazy = false` forces immediate loading.
    priority = 1000,
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Required for displaying file icons
    -- Keybindings for interacting with Oil.
    keys = {
      -- Open Oil in the parent directory of the current file.
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },

      -- Toggle Oil explorer globally.
      -- This binding checks if an Oil buffer is currently open and closes it,
      -- otherwise, it opens Oil in the current working directory.
      {
        "<leader>oo",
        function()
          local oil = require("oil")
          -- Check if an Oil buffer is the current buffer.
          if oil.get_current_dir() then
            -- If Oil is open, close its buffer. `bd!` ensures it's forcefully closed.
            -- Consider using `oil.close()` or `vim.cmd("q")` for a softer close
            -- depending on desired behavior.
            vim.cmd("bd!")
          else
            -- If Oil is not open, open it in the current working directory.
            oil.open()
          end
        end,
        desc = "Toggle Oil explorer",
      },

      -- Toggle Oil in the current buffer's directory.
      -- This allows opening Oil specifically for the directory containing the
      -- file in the active buffer.
      {
        "<leader>ob",
        function()
          local oil = require("oil")
          -- Check if an Oil buffer is the current buffer.
          if oil.get_current_dir() then
            -- If Oil is open, close its buffer.
            vim.cmd("bd!")
          else
            -- Open Oil in the directory of the current file.
            -- `vim.fn.expand("%:p:h")` gets the full path to the current file's directory.
            -- `is_target_window = function() return true end` ensures Oil opens in the current window.
            -- Note: `win_options` here are specific to this mapping and override global `opts.win_options`.
            -- If these options are meant to be global, move them to `opts.win_options`.
            oil.open(vim.fn.expand("%:p:h"), {
              is_target_window = function()
                return true
              end,
              -- Removed redundant `win_options` here; the global `opts.win_options` will apply.
              -- If you need specific `win_options` for *only* this toggle, uncomment and configure them here.
              -- win_options = {
              --   wrap = false,
              --   signcolumn = "no",
              --   cursorcolumn = false,
              --   spell = false,
              --   list = false,
              --   conceallevel = 3,
              --   concealcursor = "nvic",
              -- },
            })
          end
        end,
        desc = "Toggle Oil in current buffer",
      },
    },
    -- Global options for Oil.
    opts = {
      default_file_explorer = true, -- Make Oil the default file explorer (e.g., when opening a directory)
      columns = { "icon" }, -- Show file icons in the Oil buffer
      -- Buffer-specific options for Oil buffers.
      buf_options = {
        buflisted = false, -- Prevent Oil buffers from appearing in the buffer list
        bufhidden = "wipe", -- When closed, remove the buffer from memory
      },
      -- Window-specific options for Oil windows.
      win_options = {
        wrap = false, -- Do not wrap lines in the Oil window
        signcolumn = "no", -- Hide the sign column
        cursorcolumn = false, -- Do not highlight the cursor column
        spell = false, -- Disable spell checking
        list = false, -- Do not show list characters (e.g., tabs, spaces)
        conceallevel = 3, -- Hide characters if possible (e.g., in markdown)
        concealcursor = "nvic", -- Hide concealed characters when cursor is on them in normal, visual, insert, and command line modes
      },
      -- Keymaps specific to the Oil buffer. These are defined within the Oil plugin itself.
      keymaps = {
        ["g?"] = "actions.show_help", -- Show Oil help menu
        ["<CR>"] = "actions.select", -- Open selected file/directory
        ["<leader>ov"] = "actions.select_vsplit", -- Open selected in a vertical split
        ["<leader>os"] = "actions.select_split", -- Open selected in a horizontal split
        ["<leader>ot"] = "actions.select_tab", -- Open selected in a new tab
        ["<leader>op"] = "actions.preview", -- Preview selected file
        ["<leader>oc"] = "actions.close", -- Close the Oil buffer
        ["<leader>or"] = "actions.refresh", -- Refresh the Oil buffer
        ["<BS>"] = "actions.parent", -- Navigate to the parent directory
        ["_"] = "actions.open_cwd", -- Open the current working directory in Oil
        ["`"] = "actions.cd", -- Change Neovim's current working directory to the selected one
        ["~"] = "actions.tcd", -- Change the tab's current working directory
        ["g."] = "actions.toggle_hidden", -- Toggle visibility of hidden files
        ["H"] = "actions.toggle_trash", -- Toggle the trash view (for deleted files)
        ["<C-s>"] = "actions.change_sort", -- Change sorting method
        ["<C-h>"] = "actions.toggle_hidden", -- Toggle visibility of hidden files (duplicate, common for user preference)
      },
      skip_confirm_for_simple_edits = true, -- Don't ask for confirmation on simple edits (rename, delete)
      delete_to_trash = true, -- Use the OS trash bin for deletions if possible
      -- Options for how the file view is rendered.
      view_options = {
        show_hidden = true, -- Show hidden files by default
        -- Custom function to determine if a file is hidden (starts with '.')
        is_hidden_file = function(name, _)
          return vim.startswith(name, ".")
        end,
      },
    },
    -- Main configuration function for Oil.
    config = function(_, opts)
      require("oil").setup(opts)

      -- Autocmd to auto-open Oil if Neovim is started with a directory as an argument.
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = vim.schedule_wrap(function(event)
          -- Check if the argument provided to VimEnter is a directory.
          if vim.fn.isdirectory(event.file) == 1 then
            -- Close the initial empty buffer (if any) created when opening a directory.
            vim.cmd.bwipeout()
            -- Open Oil in the specified directory.
            require("oil").open(event.file)
          end
        end),
      })

      -- Autocmd for specific settings when an Oil buffer is opened.
      -- This ensures that buffer-local options are set correctly for Oil.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "oil", -- Apply to buffers with 'oil' filetype
        callback = function()
          vim.opt_local.number = true -- Show line numbers
          vim.opt_local.relativenumber = true -- Show relative line numbers
          vim.opt_local.signcolumn = "no" -- Hide the sign column in Oil buffer
          vim.opt_local.cursorline = true -- Highlight the current line
          -- Map 'q' to close the Oil buffer.
          vim.keymap.set("n", "q", "<CMD>bd!<CR>", { buffer = true, desc = "Close Oil buffer" })
        end,
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "main",
    -- Lazy load Neo-tree: It will only be loaded when one of its commands
    -- (like `Neotree` or `Neotree filesystem toggle`) is called or
    -- when Neovim enters a very lazy state (after all other plugins are loaded).
    event = "VeryLazy",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim", -- General-purpose utilities
      "nvim-tree/nvim-web-devicons", -- For file icons
      "MunifTanjim/nui.nvim", -- UI toolkit for Neovim (dependency for Neo-tree)
    },
    -- Keybindings for Neo-tree.
    keys = {
      { "<leader>e", "<cmd>Neotree filesystem toggle<cr>", desc = "Toggle Neotree" },
    },
    -- Configuration options for Neo-tree.
    opts = {
      close_if_last_window = true, -- Close Neo-tree if it's the last open window
      enable_git_status = true, -- Show Git status indicators
      -- File system specific options.
      filesystem = {
        -- CRITICAL: Disable Neo-tree's hijacking of netrw to avoid conflicts with Oil.
        hijack_netrw_behavior = "disabled",
        filtered_items = {
          visible = true, -- Make filtered items visible (e.g., hidden files)
          hide_dotfiles = false, -- Do not hide dotfiles by default (consistent with Oil's `show_hidden`)
        },
        follow_current_file = {
          enabled = true, -- Automatically reveal the current file in the tree
        },
      },
      -- Window-specific options for the Neo-tree sidebar.
      window = {
        mappings = {
          ["l"] = "open", -- Open selected file/directory
          ["h"] = "close_node", -- Close the current directory node
        },
      },
    },
  },
}

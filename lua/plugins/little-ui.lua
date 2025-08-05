return {
  -- Smear Cursor: Creates a visual trail behind the cursor for better visibility.
  {
    "sphamba/smear-cursor.nvim",
    enabled = not vim.g.neovide, -- Only enable if not using Neovide
    event = { "BufReadPre", "BufNewFile" }, -- Load before reading/creating a buffer
    lazy = true,
    opts = {
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      scroll_buffer_space = true,
      legacy_computing_symbols_support = false,
      smear_insert_mode = false,
    },
    -- Disable when the cmdline is entered and enable when left.
    init = function()
      vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
        callback = function()
          require("smear_cursor").toggle()
        end,
      })
    end,
  },

  -- Statuscol: Custom status column for line numbers, signs, etc.
  -- Needs to load early to properly set up the status column when a buffer is opened.
  {
    "luukvbaal/statuscol.nvim",
    event = { "BufReadPre", "BufNewFile" }, -- Load before reading/creating a buffer
    lazy = true,
    opts = {
      relculright = true, -- Show relative line numbers on the right
    },
  },

  -- Tiny Inline Diagnostic: Shows diagnostics inline at the end of lines.
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = { "LspAttach" }, -- Load when Neovim is mostly idle and ready for user interaction
    priority = 1000, -- Needs to load early to capture diagnostics
    opts = {
      options = {
        use_icons_from_diagnostic = true,
        multilines = { enabled = true }, -- Show on all lines
      },
    },
  },

  -- Fidget.nvim: Elegant LSP progress notifications and UI.
  {
    "j-hui/fidget.nvim",
    lazy = false, -- Load on startup for immediate LSP feedback
    opts = {
      -- Notification configuration
      notification = {
        override_vim_notify = true,
        window = {
          normal_hl = "Comment", -- Base highlight group in the notification window
          winblend = 100, -- Background color opacity (0-100)
          border = "none", -- Border around the notification window
          zindex = 45, -- Stacking priority
          max_width = 0, -- Auto width
          max_height = 0, -- Auto height
          x_padding = 1, -- Padding from right edge
          y_padding = 0, -- Padding from bottom edge
          align = "bottom", -- Align to bottom right
          relative = "editor", -- Position relative to the editor window
        },
      },
      -- Progress configuration
      progress = {
        suppress_on_insert = true, -- Hide progress while in insert mode
        ignore_done_already = true, -- Don't show progress that's already completed
      },
    },
    integration = {
      ["nvim-tree"] = {
        enable = true, -- Enable integration with nvim-tree if you use it
      },
    },
  },

  -- Incline.nvim: Customizable winbar (top statusline per window).
  {
    "b0o/incline.nvim",
    enabled = false, -- Currently disabled as per your original config
    event = "BufReadPost", -- Load after a buffer is read
    lazy = true, -- Explicitly mark as lazy-loaded
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Dependency for file type icons
    opts = {
      window = {
        margin = { horizontal = 0, vertical = 0 },
        placement = { horizontal = "right", vertical = "top" },
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        if filename == "" then
          filename = "[No Name]"
        end

        local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filename)
        local modified = vim.bo[props.buf].modified

        return {
          ft_icon and { " ", ft_icon, " ", guifg = ft_color } or "",
          { filename, gui = modified and "bold,italic" or "bold" },
          modified and { " " } or "", -- Modified icon
        }
      end,
    },
  },

  -- Nvim Treesitter Context: Shows parent function/class context above the cursor.
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost", -- Load after a buffer is read
    lazy = true, -- Explicitly mark as lazy-loaded
    opts = {}, -- Keep options empty for default behavior
  },

  -- Nvim Scrollbar: Displays a scrollbar for the current buffer.
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost", -- Load after a buffer is read
    lazy = true, -- Explicitly mark as lazy-loaded
    opts = {
      excluded_buftypes = {
        "terminal",
      },
      excluded_filetypes = {
        "blink-cmp-menu",
        "NvimTree",
        "dropbar_menu",
        "dropbar_menu_fzf",
        "DressingInput",
        "cmp_docs",
        "cmp_menu",
        "noice",
        "prompt",
        "TelescopePrompt",
      },
    },
  },
}

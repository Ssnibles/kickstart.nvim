return {
  "lewis6991/gitsigns.nvim",
  -- Lazy load the plugin:
  -- "BufReadPre": Loads before a buffer is read, ensuring Git signs are ready immediately.
  -- "BufNewFile": Loads when a new file is created.
  -- This ensures Gitsigns loads only when needed, contributing to faster Neovim startup.
  event = { "BufReadPre", "BufNewFile" },
  -- Plugin options for customizing Gitsigns' behavior and appearance.
  opts = {
    -- Define the text characters used for different Git diff signs in the sign column.
    signs = {
      add = { text = "│" }, -- New added lines
      change = { text = "│" }, -- Modified lines
      delete = { text = "_" }, -- Deleted lines (indicator at the line where deletion occurred)
      topdelete = { text = "‾" }, -- Deleted lines (indicator at the top of a deletion block)
      changedelete = { text = "~" }, -- Lines that were both changed and deleted
      untracked = { text = "│" }, -- Untracked lines
    },
    -- Display options for Git signs.
    signcolumn = true, -- Always show the sign column for Gitsigns indicators
    numhl = false, -- Do not highlight line numbers for Git changes
    linehl = false, -- Do not highlight the entire line for Git changes
    word_diff = false, -- Disable word-level diffing (set to `true` for more granular diffs)

    -- Configuration for watching the Git directory.
    watch_gitdir = {
      interval = 1000, -- Check Git directory for changes every 1000ms (1 second)
      follow_files = true, -- Update signs when files are moved/renamed
    },

    -- When `true`, Git signs will be attached to untracked files as well.
    attach_to_untracked = true,

    -- Current line blame: displays Git blame information for the current line.
    current_line_blame = false, -- Set to `true` to enable current line blame
    current_line_blame_opts = {
      virt_text = true, -- Display blame information as virtual text
      virt_text_pos = "eol", -- Position virtual text at the end of the line
      delay = 1000, -- Delay (in ms) before showing blame on line change
      ignore_whitespace = false, -- Include whitespace changes in blame calculation
    },

    -- Formatter for the current line blame virtual text.
    -- Displays author, formatted author time (YYYY-MM-DD), and commit summary.
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",

    sign_priority = 6, -- Priority of Gitsigns compared to other sign column plugins (higher = more priority)
    update_debounce = 100, -- Debounce time (in ms) for updating signs after changes
    status_formatter = nil, -- Custom function to format Git status (nil uses default)
    max_file_length = 40000, -- Maximum file length (in lines) for which Gitsigns will operate.
    -- Files larger than this will not show Git signs to prevent performance issues.

    -- Configuration for Gitsigns preview popups (e.g., when hovering over a sign).
    preview_config = {
      border = "rounded", -- Use rounded borders for the preview popup
      style = "minimal", -- Minimal style for the popup content
      relative = "cursor", -- Position the popup relative to the cursor
      row = 0, -- Offset row from the cursor (0 = same row)
      col = 2, -- Offset column from the cursor (2 = slightly to the right)
    },
  },
}

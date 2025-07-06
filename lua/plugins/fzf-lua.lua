return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- Essential for displaying icons in fzf-lua results
  -- Explicitly set lazy loading to true.
  -- This ensures the plugin is only loaded when one of its defined `keys`
  -- is pressed or its commands are executed.
  lazy = true,
  -- The `config` function is called when the plugin is loaded (due to `keys` aor `cmd`).
  -- This is the correct place for `setup` calls in Lazy.nvim.
  config = function()
    require("fzf-lua").setup({
      -- Global window options for all fzf-lua pickers.
      winopts = {
        backdrop = 100, -- Sets the opacity (higher = more transparent)
        height = 0.95, -- Window height as a percentage of Neovim's window height
        width = 0.95, -- Window width as a percentage of Neovim's window width
        row = 0.5, -- Center the window vertically (0.5 means 50% from top)
        col = 0.5, -- Center the window horizontally (0.5 means 50% from left)
        border = "rounded", -- Use rounded borders for the popup window, similar to Telescope
        title = "Files", -- Default title for the main fzf-lua window
        preview = {
          -- layout = "vertical", -- Uncomment to position preview vertically (e.g., on the right)
          -- vertical = "right:60%", -- If vertical, set width for preview (60% of window width)
          border = "border", -- Use a border around the preview window
          scrollbar = true, -- Show a scrollbar in the preview window
        },
        -- Optional: Add padding around the main window.
        -- margin = { top = 1, bottom = 1, left = 2, right = 2 },
      },
      -- Customize the colors used by fzf.
      -- These map fzf's internal color names to Neovim highlight groups.
      -- fzf_colors = {
      --   ["fg"] = { "fg", "Normal" },
      --   ["bg"] = { "bg", "Normal" },
      --   ["hl"] = { "fg", "Comment" }, -- Highlighted text color
      --   ["fg+"] = { "fg", "CursorLine" }, -- Foreground of selected item
      --   ["bg+"] = { "br", "CursorLine" }, -- Background of selected item
      --   ["hl+"] = { "fg", "Statement" }, -- Highlighted text color of selected item
      --   ["info"] = { "fg", "PreProc" }, -- Info text color
      --   ["border"] = { "fg", "FloatBorder" }, -- Border color of the popup
      --   ["prompt"] = { "fg", "Conditional" }, -- Prompt text color
      --   ["pointer"] = { "fg", "Exception" }, -- Pointer symbol color
      --   ["marker"] = { "fg", "Keyword" }, -- Marker symbol color
      --   ["spinner"] = { "fg", "Label" }, -- Spinner color
      --   ["header"] = { "fg", "Comment" }, -- Header text color
      -- },
      -- Specific configuration for the 'files' picker (used by `<leader>ff`).
      files = {
        -- `rg` (ripgrep) command to list files.
        -- `--files`: Only print file paths.
        -- `--color=never`: Disable color output to avoid parsing issues.
        -- `--hidden`: Include hidden files.
        -- `--follow`: Follow symlinks.
        -- `-g '!{.git,node_modules}'`: Exclude .git and node_modules directories.
        cmd = "rg --files --color=never --hidden --follow -g '!{.git,node_modules}'",
        fzf_opts = {
          ["--tiebreak"] = "index", -- Break ties by index (order of appearance)
          ["--prompt"] = "> ", -- Custom prompt for the fzf input line
        },
      },
      -- Specific configuration for the 'grep' picker (used by `live_grep` and `grep_curbuf`).
      grep = {
        -- `rg` (ripgrep) options for searching content.
        rg_opts = "--column --line-number --no-heading --color=never --smart-case --hidden -g '!{.git,node_modules}'",
      },
      file_icon_colors = true, -- Enable filetype-specific colors for icons
      color_icons = true, -- Enable colors for all icons
      git_icons = true, -- Show Git status icons
      -- Define what information is displayed for each item in the results list.
      display = {
        "file-icon", -- File type icon
        "git", -- Git status (modified, added, etc.)
        "file", -- File name
        "dir", -- Directory path
        "hidden", -- Hidden file indicator
        "date", -- Last modified date
        "size", -- File size
      },
      -- Configure built-in previewers.
      previewers = {
        builtin = {
          syntax = true, -- Enable syntax highlighting in preview
          treesitter = true, -- Use Treesitter for better syntax highlighting
          -- snacks_image = { enabled = true }, -- Uncomment if you want image previews (requires 'snacks')
        },
      },
      -- Customize keymaps for both fzf-lua's built-in functions and the underlying fzf process.
      keymap = {
        builtin = {
          ["ctrl-r"] = "preview-reset", -- Reset preview to top
          ["ctrl-d"] = "preview-page-down", -- Scroll preview down
          ["ctrl-u"] = "preview-page-up", -- Scroll preview up
        },
        fzf = {
          ["ctrl-j"] = "preview-page-down", -- fzf-specific keymap for scrolling preview down
          ["ctrl-k"] = "preview-page-up", -- fzf-specific keymap for scrolling preview up
        },
      },
    })
  end,
  -- Keybindings to trigger various fzf-lua pickers.
  keys = {
    {
      "<leader>ff",
      function()
        require("fzf-lua").files() -- Find files in the current project
      end,
      desc = "FzfLua: Find Files",
    },
    {
      "<leader>fr",
      function()
        require("fzf-lua").oldfiles() -- Find recently opened files
      end,
      desc = "FzfLua: Recent Files",
    },
    {
      "<leader>fg",
      function()
        require("fzf-lua").live_grep() -- Live search across files using ripgrep
      end,
      desc = "FzfLua: Live Grep",
    },
    {
      "<leader>fb",
      function()
        require("fzf-lua").buffers() -- List and switch between open buffers
      end,
      desc = "FzfLua: Buffers",
    },
    {
      "<leader>fh",
      function()
        require("fzf-lua").help_tags() -- Search Neovim help tags
      end,
      desc = "FzfLua: Help Tags",
    },
    {
      "<leader>fs",
      function()
        require("fzf-lua").spell_suggest() -- Get spell suggestions
      end,
      desc = "FzfLua: Spell suggest",
    },
    {
      "<leader>ft",
      function()
        -- Search for common TODO/FIXME/etc. comments across the project.
        require("fzf-lua").grep({
          search = [[TODO|FIXME|BUG|FIXIT|ISSUE|HACK|WARN|WARNING|XXX|PERF|OPTIM|PERFORMANCE|OPTIMIZE|NOTE|INFO]],
          no_esc = true, -- Do not escape the search pattern (treat as literal regex)
          prompt = "TODOs: ", -- Custom prompt for this specific grep
        })
      end,
      desc = "FzfLua: Project TODOs",
    },
    {
      "<leader>fc",
      function()
        require("fzf-lua").grep_curbuf() -- Search only within the current buffer
      end,
      desc = "FzfLua: Grep Current Buffer",
    },
  },
}

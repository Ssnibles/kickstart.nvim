return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = function()
    require("fzf-lua").setup({
      "telescope",
      winopts = {
        height = 0.95,
        width = 0.95,
        row = 0.5,
        col = 0.5,
        border = "rounded", -- Telescope-like rounded borders
        title = "Files", -- Main window title
        preview = {
          -- layout = "vertical", -- Preview on the right
          -- vertical = "right:60%", -- 60% of window width for preview
          border = "border",
          scrollbar = true,
        },
        -- Padding can be increased with margin if needed (not always supported)
        -- margin = { top = 1, bottom = 1, left = 2, right = 2 },
      },
      fzf_colors = {
        ["fg"] = { "fg", "Normal" },
        ["bg"] = { "bg", "Normal" },
        ["hl"] = { "fg", "Comment" },
        ["fg+"] = { "fg", "CursorLine" },
        ["bg+"] = { "bg", "CursorLine" },
        ["hl+"] = { "fg", "Statement" },
        ["info"] = { "fg", "PreProc" },
        ["border"] = { "fg", "FloatBorder" },
        ["prompt"] = { "fg", "Conditional" },
        ["pointer"] = { "fg", "Exception" },
        ["marker"] = { "fg", "Keyword" },
        ["spinner"] = { "fg", "Label" },
        ["header"] = { "fg", "Comment" },
      },
      files = {
        cmd = "rg --files --color=never --hidden --follow -g '!{.git,node_modules}'",
        fzf_opts = {
          ["--tiebreak"] = "index",
          ["--prompt"] = "> ",
        },
      },
      grep = {
        rg_opts = "--column --line-number --no-heading --color=never --smart-case --hidden -g '!{.git,node_modules}'",
      },
      file_icon_colors = true,
      color_icons = true,
      git_icons = true,
      display = {
        "file-icon",
        "git",
        "file",
        "dir",
        "hidden",
        "date",
        "size",
      },
      previewers = {
        builtin = {
          syntax = true,
          treesitter = true,
          -- snacks_image = { enabled = true },
        },
      },
      keymap = {
        fzf = {
          ["ctrl-j"] = "preview-down",
          ["ctrl-k"] = "preview-up",
          ["ctrl-d"] = "preview-half-page-down",
          ["ctrl-u"] = "preview-half-page-up",
        },
      },
    })
  end,
  keys = {
    {
      "<leader>ff",
      function()
        require("fzf-lua").files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>fr",
      function()
        require("fzf-lua").oldfiles()
      end,
      desc = "Recent Files",
    },
    {
      "<leader>fg",
      function()
        require("fzf-lua").live_grep()
      end,
      desc = "Live Grep",
    },
    {
      "<leader>fb",
      function()
        require("fzf-lua").buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>fh",
      function()
        require("fzf-lua").help_tags()
      end,
      desc = "Help Tags",
    },
    {
      "<leader>fs",
      function()
        require("fzf-lua").spell_suggest()
      end,
      desc = "Spell suggest",
    },
  },
}

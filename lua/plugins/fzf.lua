return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = true,
  config = function()
    require("fzf-lua").setup({
      winopts = {
        backdrop = "NormalFloat",
        height = 0.95,
        width = 0.95,
        row = 0.5,
        col = 0.5,
        border = "rounded",
        title = "Files",
        preview = {
          layout = "vertical",
          vertical = "right:60%",
          border = "border",
          scrollbar = true,
        },
      },
      fzf_colors = {
        ["hl"] = { "fg", "Keyword" },
        ["hl+"] = { "fg", "Statement" },
        ["info"] = { "fg", "Type" },
        ["border"] = { "fg", "FloatBorder" },
        ["prompt"] = { "fg", "Variable" },
        ["spinner"] = { "fg", "Label" },
        ["header"] = { "fg", "Comment" },
      },
      files = {
        cmd = "fd --type f --hidden --exclude .git --exclude node_modules",
      },
      grep = {
        rg_opts = "--color=never --hidden --glob '!{.git,node_modules}' --no-heading --line-number --column",
      },
      file_icons = {
        enabled = true,
        color = true,
      },
      git = {
        status = true,
        untracked = true,
      },
      previewers = {
        builtin = {
          syntax = true,
          treesitter = true,
        },
      },
      keymap = {
        builtin = {
          ["<C-f>"] = "preview-page-down",
          ["<C-b>"] = "preview-page-up",
          ["<C-s>"] = "select-horizontal-split",
          ["<C-v>"] = "select-vertical-split",
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
      desc = "FzfLua: Find Files",
    },
    {
      "<leader>fr",
      function()
        require("fzf-lua").oldfiles()
      end,
      desc = "FzfLua: Recent Files",
    },
    {
      "<leader>fg",
      function()
        require("fzf-lua").live_grep()
      end,
      desc = "FzfLua: Live Grep",
    },
    {
      "<leader>fb",
      function()
        require("fzf-lua").buffers()
      end,
      desc = "FzfLua: Buffers",
    },
    {
      "<leader>fh",
      function()
        require("fzf-lua").help_tags()
      end,
      desc = "FzfLua: Help Tags",
    },
    {
      "<leader>fs",
      function()
        require("fzf-lua").spell_suggest()
      end,
      desc = "FzfLua: Spell suggest",
    },
    {
      "<leader>ft",
      function()
        require("fzf-lua").grep({
          search = "TODO|FIXME|BUG|FIXIT|HACK|WARN|NOTE",
          no_esc = true,
          prompt = "TODOs: ",
        })
      end,
      desc = "FzfLua: Project TODOs",
    },
    {
      "<leader>fc",
      function()
        require("fzf-lua").grep_curbuf()
      end,
      desc = "FzfLua: Grep Current Buffer",
    },
    {
      "<leader>fw",
      function()
        require("fzf-lua").grep_word()
      end,
      desc = "FzfLua: Grep Word",
    },
    {
      "<leader>fl",
      function()
        require("fzf-lua").loclist()
      end,
      desc = "FzfLua: Location List",
    },
    {
      "<leader>fq",
      function()
        require("fzf-lua").quickfix()
      end,
      desc = "FzfLua: Quickfix List",
    },
    {
      "<leader>fm",
      function()
        require("fzf-lua").man_pages()
      end,
      desc = "FzfLua: Man Pages",
    },
    {
      "<leader>fd",
      function()
        require("fzf-lua").diagnostics()
      end,
      desc = "FzfLua: Diagnostics",
    },
  },
}

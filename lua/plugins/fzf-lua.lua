return {
  {
    "ibhagwan/fzf-lua",
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
    },
    config = function()
      require("fzf-lua").setup({
        winopts = {
          height = 0.4,
          width = 0.80,
          row = 0.35,
          col = 0.50,
          border = "rounded",
          preview = {
            layout = "vertical",
            vertical = "up:60%",
            horizontal = "right:50%",
            border = "border",
          },
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
        },
        previewers = {
          bat = {
            theme = "TwoDark",
          },
        },
      })
    end,
  },
}

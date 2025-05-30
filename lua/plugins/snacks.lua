return {

  "folke/snacks.nvim",
  event = "VimEnter",
  opts = {
    indent = {
      enabled = false,
      priority = 1,
      char = "│",
      scope = {
        enabled = true,
        show_start = true,
        show_end = true,
      },
      animate = { enabled = false },
    },
    picker = {
      layout = {
        preview = true,
        layout = {
          backdrop = false,
          width = 0.6,
          min_width = 80,
          height = 0.6,
          border = "none",
          box = "vertical",
          -- Window layouts as subtables
          {
            win = "input",
            height = 1,
            border = "rounded",
            title = "{title} {live} {flags}",
            title_pos = "center",
          },
          {
            win = "list",
            border = "hpad",
          },
          {
            win = "preview",
            title = "{live}",
            border = "rounded",
          },
        },
      },
      matcher = {
        fuzzy = true,
        smartcase = true,
        ignorecase = true,
        sort_empty = true,
        filename_bonus = true,
        file_pos = true,
        history_bonus = true,
      },
      ui_select = true,
      previewers = {
        diff = {
          builtin = false,
          cmd = { "bat" },
        },
        git = {
          builtin = true,
        },
      },
      recent = {
        finder = "recent_files",
        format = "file",
      },
      -- Optional: Add a section for TODO keywords if using with todo-comments.nvim
      todo_keywords = {
        "TODO",
        "FIX",
        "FIXME",
        "BUG",
        "HACK",
        "WARN",
        "WARNING",
        "NOTE",
        "INFO",
        "ISSUE",
      },
    },
    image = {
      enabled = true,
      formats = {
        "png",
        "jpg",
        "jpeg",
        "gif",
        "bmp",
        "webp",
        "tiff",
        "heic",
        "avif",
        "mp4",
        "mov",
        "avi",
        "mkv",
        "webm",
        "pdf",
      },
      doc = {
        enabled = true,
        inline = true,
        float = false,
        max_width = 80,
        max_height = 40,
        conceal = function(lang, type)
          return type == "math"
        end,
      },
      math = {
        enabled = true,
      },
    },
    profiler = {
      autocmds = true,
    },
  },
  config = function(_, opts)
    require("snacks").setup(opts)
  end,
}

return {
  "folke/snacks.nvim",
  event = "VimEnter",
  opts = {
    dim = {
      enabled = true,
      scope = {
        min_size = 5,
        max_size = 20,
        siblings = true,
      },
      animate = { enabled = false },
    },
    notifier = {
      timeout = 3000,
      width = { min = 40, max = 0.4 },
      height = { min = 1, max = 0.6 },
      margin = { top = 0.5, right = 0.5, bottom = 0 },
      padding = true,
      sort = { "level", "time" },
      level = vim.log.levels.TRACE,
      icons = {
        error = " ",
        warn = " ",
        info = " ",
        debug = " ",
        trace = " ",
      },
      style = "compact",
    },
    indent = {
      enabled = true,
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
      enabled = false,
      layout = {
        preview = true,
        layout = {
          backdrop = false,
          width = 0.6,
          min_width = 80,
          height = 0.6,
          border = "none",
          box = "vertical",
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
            title = "{preview}",
            border = "rounded",
          },
        },
      },
      matcher = {
        fuzzy = true,
        smartcse = true,
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

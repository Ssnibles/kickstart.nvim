return {
  "MeanderingProgrammer/render-markdown.nvim",
  -- 'enabled' can be true here if you want it to always be on for specified filetypes.
  -- Alternatively, keep it false and use :RenderMarkdown enable in specific buffers.
  enabled = false,
  ft = { "markdown", "quarto" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons", -- if you prefer nvim-web-devicons
    -- Consider adding 'pylatexenc' requirement if you want robust latex2text conversion.
    -- This is a Python library that needs to be installed system-wide.
    -- If you want actual image rendering for LaTeX, you'd look into other plugins like:
    -- "edluffy/nvim-fira-code-retina", -- For Retina font ligatures (not direct rendering)
    -- "jbyuki/nabla.nvim", -- For inline LaTeX equation previews (image-based)
    -- "sammyne/image.nvim", -- General image display in Neovim
    -- "snacks.nvim", -- Another collection that might include image rendering
  },
  opts = {
    -- General options
    render_modes = { "n", "c", "t" }, -- Modes where rendering is active. 'n' for normal, 'c' for command, 't' for terminal.
    -- You might want to adjust this based on when you want the rendering to be active.
    max_file_size = 5.0, -- Max file size (in MB) to render. Prevents performance issues on very large files.
    update_delay = 100, -- Milliseconds to wait before re-rendering after changes. Adjust for responsiveness.

    completions = {
      lsp = { enabled = true },
      -- Add other completion sources if you use them (e.g., 'cmp', 'blink', 'coq')
      -- cmp = { enabled = true },
    },

    anti_conceal = {
      enabled = true,
      -- ignore = {
      --   code_background = true, -- Usually good to keep this true to not mess with code block background
      --   sign = true,            -- Usually good to keep this true for signs in the sign column
      -- },
      -- above = 0, -- Set to a higher number to reveal more context above the cursor
      -- below = 0, -- Set to a higher number to reveal more context below the cursor
      -- You can comment out 'ignore' and adjust 'above'/'below' if you want more aggressive anti-conceal.
      -- The default for 'above' and 'below' is typically 0, meaning only the current line is unconcealed.
      -- To show a few lines around the cursor:
      above = 2,
      below = 2,
    },

    -- Styling
    heading = {
      signs = false, -- Disable line number signs for headings if you don't want them
      -- You can also configure colors, icons, borders, padding, and width for headings here
      -- For example:
      -- icons = { " ", " ", " ", " ", " ", " " }, -- No icons
      -- colors = { "#FF0000", "#00FF00", "#0000FF", "#FFFF00", "#00FFFF", "#FF00FF" },
    },

    latex = {
      enabled = true,
      converter = "latex2text", -- Uses pylatexenc to convert LaTeX to Unicode text.
      -- This is the primary way render-markdown.nvim handles LaTeX.
      -- Ensure 'pylatexenc' is installed on your system if you want this to work well.
      -- pip install pylatexenc
      highlight = "RenderMarkdownMath", -- The highlight group for LaTeX. You can define this in your colorscheme.
      -- top_pad = 0,    -- Keep at 0 for compact inline display
      -- bottom_pad = 0, -- Keep at 0 for compact inline display
      -- The pads control vertical spacing *around* the rendered text, not an overlay.
      -- If you want truly "on top" rendering (like an image overlay),
      -- 'render-markdown.nvim' with `latex2text` isn't designed for that directly.
      -- You'd need a separate plugin for image rendering as mentioned above.
    },

    -- Other components you might want to configure:
    -- code_blocks = {
    --   enabled = true,
    --   background = true,
    --   icons = { enabled = true },
    -- },
    -- inline_code = { enabled = true, background = true },
    -- lists = {
    --   enabled = true,
    --   icons = { enabled = true },
    -- },
    -- checkboxes = { enabled = true },
    -- block_quotes = { enabled = true },
    -- tables = { enabled = true },
    -- links = { enabled = true, icons = { enabled = true } },
  },
}

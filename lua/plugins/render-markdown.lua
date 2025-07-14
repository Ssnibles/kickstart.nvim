return {
  "MeanderingProgrammer/render-markdown.nvim",
  enabled = false,
  ft = { "markdown", "quarto" },
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
  opts = {
    completions = { lsp = { enabled = true } },

    anti_conceal = {
      enabled = true,
      ignore = {
        code_background = true,
        sign = true,
      },
      above = 0,
      below = 0,
    },

    -- Styling

    -- Heading
    heading = {
      signs = false, -- Disable line number signs
    },

    latex = {
      enabled = true,
      converter = "latex2text",
      highlight = "RenderMarkdownMath",
      top_pad = 0,
      bottom_pad = 0,
    },
  },
}

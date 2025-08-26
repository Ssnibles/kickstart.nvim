return {
  "saghen/blink.cmp",
  version = "^1.0.0",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "archie-judd/blink-cmp-words",
    "rafamadriz/friendly-snippets",
    "L3MON4D3/LuaSnip",
  },
  opts = {
    keymap = { preset = "super-tab" },

    appearance = {
      nerd_font_variant = "mono",
    },

    completion = {
      accept = { create_undo_point = true },
      ghost_text = { enabled = true },
      menu = {
        auto_show = true,
        border = "rounded",
        draw = { align_to = "label" },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 0,
        treesitter_highlighting = true,
        window = { border = "rounded" },
      },
    },

    fuzzy = { implementation = "rust" },

    signature = {
      enabled = true,
      trigger = { enabled = true },
      window = { border = "rounded" },
    },

    cmdline = {
      enabled = true,
      completion = { menu = { auto_show = true } },
      keymap = { preset = "super-tab" },
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      per_filetype = {
        text = { "dictionary" },
        markdown = { "dictionary", "lsp", "path", "snippets", "buffer" },
      },
      providers = {
        thesaurus = {
          name = "blink-cmp-words",
          module = "blink-cmp-words.thesaurus",
          opts = {
            score_offset = 0,
            pointer_symbols = { "!", "&", "^" },
          },
        },
        dictionary = {
          name = "blink-cmp-words",
          module = "blink-cmp-words.dictionary",
          opts = {
            dictionary_search_threshold = 3,
            score_offset = 0,
            pointer_symbols = { "!", "&", "^" },
          },
        },
        path = {
          score_offset = 3,
          fallbacks = { "buffer" },
          opts = {
            trailing_slash = true,
            label_trailing_slash = true,
            show_hidden_files_by_default = true,
            get_cwd = function(context)
              return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
            end,
          },
        },
      },
    },
  },

  config = function(_, opts)
    require("blink.cmp").setup(opts)
    require("luasnip.loaders.from_vscode").lazy_load()
  end,
}

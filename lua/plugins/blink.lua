return {
  "saghen/blink.cmp",
  version = "^1.0.0",
  event = { "CmdlineEnter", "InsertEnter" },
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
        border = "rounded",
        draw = {
          align_to = "label",
          treesitter = { "lsp" },
        },
        max_height = 12,
        min_width = 24,
      },
      documentation = {
        window = { border = "rounded", max_width = 60 },
        auto_show = true,
        auto_show_delay_ms = 50,
      },
      list = {
        selection = {
          preselect = false,
          auto_insert = false,
        },
      },
    },
    fuzzy = {
      sorts = { "exact", "score", "sort_text" },
    },
    signature = {
      window = { border = "rounded" },
      trigger = { enabled = true },
    },
    cmdline = {
      keymap = { preset = "super-tab" },
      completion = { menu = { auto_show = true } },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      per_filetype = {
        text = { "dictionary" },
        markdown = { "dictionary" },
      },
      providers = {
        thesaurus = {
          name = "blink-cmp-words",
          module = "blink-cmp-words.thesaurus",
          opts = {
            score_offset = 0,
            definition_pointers = { "!", "&", "^" },
          },
        },
        dictionary = {
          name = "blink-cmp-words",
          module = "blink-cmp-words.dictionary",
          opts = {
            dictionary_search_threshold = 3,
            score_offset = 0,
            definition_pointers = { "!", "&", "^" },
          },
        },
        path = {
          score_offset = 3,
          fallbacks = { "buffer" },
          opts = {
            trailing_slash = true,
            label_trailing_slash = true,
            show_hidden_files_by_default = false,
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

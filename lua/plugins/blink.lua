return {
  "saghen/blink.cmp",
  version = "^1.0.0", -- Pin to major version (adjust based on latest release)
  event = { "CmdlineEnter", "InsertEnter" },
  dependencies = {
    "Kaiser-Yang/blink-cmp-dictionary",
    dependencies = { "nvim-lua/plenary.nvim" },
    "rafamadriz/friendly-snippets",
    "L3MON4D3/LuaSnip",
  },
  opts = {
    keymap = {
      preset = "super-tab",
    },
    appearance = {
      nerd_font_variant = "mono", -- Ensure your terminal uses a Nerd Font
    },
    completion = {
      menu = {
        auto_show = true,
        border = "rounded",
        draw = {
          align_to = "label",
          components = {
            kind_icon = {
              text = function(ctx)
                local icon = ctx.kind_icon
                -- If LSP source, check for color
                if ctx.item.source_name == "LSP" then
                  local color_item =
                    require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
                  if color_item and color_item.abbr ~= "" then
                    icon = color_item.abbr
                  end
                end
                return icon .. (ctx.icon_gap or "")
              end,
              highlight = function(ctx)
                local highlight = "BlinkCmpKind" .. ctx.kind
                if ctx.item.source_name == "LSP" then
                  local color_item =
                    require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
                  if color_item and color_item.abbr_hl_group then
                    highlight = color_item.abbr_hl_group
                  end
                end
                return highlight
              end,
            },
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        window = { border = "rounded" },
        treesitter_highlighting = true,
      },
      ghost_text = {
        enabled = true,
      },
      accept = {
        create_undo_point = true,
      },
    },
    cmdline = {
      enabled = true,
      completion = {
        menu = {
          auto_show = true,
        },
      },
      keymap = {
        preset = "super-tab",
      },
    },
    fuzzy = {
      implementation = "rust", -- Updated to stable Rust implementation
    },
    signature = {
      enabled = true,
      trigger = {
        enabled = true, -- Auto show
      },
      window = {
        border = "rounded",
      },
    },
    sources = {
      default = { "dictionary", "lsp", "path", "snippets", "buffer" },
      providers = {
        dictionary = {
          module = "blink-cmp-dictionary",
          name = "Dict",
          -- Make sure this is at least 2.
          -- 3 is recommended
          min_keyword_length = 3,
          opts = {
            dictionary_directories = { "~/.dictionary/" },
          },
        },
        path = {
          score_offset = 3,
          fallbacks = { "buffer" },
          opts = {
            trailing_slash = true,
            label_trailing_slash = true,
            get_cwd = function(context)
              return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
            end,
            show_hidden_files_by_default = true,
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

return {
  "L3MON4D3/LuaSnip",
  event = { "InsertEnter", "BufReadPre", "BufNewFile" },
  version = "v2.*",
  build = "make install_jsregexp",
  dependencies = { "rafamadriz/friendly-snippets" },

  opts = {
    history = true,
    delete_check_events = "TextChanged",
  },

  config = function(_, opts)
    local ls = require("luasnip")
    ls.config.setup(opts)

    -- VSCode-style snippets (friendly-snippets + user path)
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_vscode").lazy_load({
      paths = { vim.fn.stdpath("config") .. "/snippets" },
    })

    -- Lua snippets (optional, keep user directory)
    require("luasnip.loaders.from_lua").lazy_load({
      paths = { vim.fn.stdpath("config") .. "/snippets" },
    })
  end,
}

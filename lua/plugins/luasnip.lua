return {
  "L3MON4D3/LuaSnip",
  event = { "BufReadPre", "BufNewFile", "InsertEnter" },
  build = "make install_jsregexp",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load() -- friendly-snippets
    -- Load snippets from local
    require("luasnip.loaders.from_lua").lazy_load({
      paths = { "~/.config/nvim/snippets" }, -- adjust path as needed
    })
  end,
}

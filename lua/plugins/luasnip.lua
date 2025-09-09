return {
  "L3MON4D3/LuaSnip",
  event = { "BufReadPre", "BufNewFile", "InsertEnter" },
  build = "make install_jsregexp",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    -- Load VSCode-style snippets (including friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()
    -- Load your own Lua snippets from ~/.config/nvim/snippets
    require("luasnip.loaders.from_lua").lazy_load({
      paths = { vim.fn.expand("~/.config/nvim/snippets") },
    })
  end,
}

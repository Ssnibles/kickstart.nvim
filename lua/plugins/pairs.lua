return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true, -- use Treesitter to avoid false positives
    disable_filetype = { "TelescopePrompt", "vim" },
    fast_wrap = { map = "<A-e>" }, -- keep your fast wrap muscle memory
    disable_in_macro = true,
    disable_in_visualblock = true,
  },
}

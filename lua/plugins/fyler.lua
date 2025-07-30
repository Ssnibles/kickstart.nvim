vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

return {
  "A7Lavinraj/fyler.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  branch = "stable",
  opts = {
    icon_provider = "nvim-web-devicons",
    views = {
      confirm = {
        win = {
          border = "rounded",
          kind = "float",
          kind_presets = {
            float = {
              height = 0.95,
              width = 0.95,
            },
          },
        },
      },
    },
  },
}

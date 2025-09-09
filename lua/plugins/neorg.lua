return {
  "nvim-neorg/neorg",
  lazy = false,
  version = "*",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {
          config = {
            icon_preset = "diamond",
            folds = true,
          },
        },
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/Notes",
              journal = "~/Notes/journal",
              work = "~/Notes/work",
            },
            default_workspace = "notes",
            index = "index.norg",
            autochdir = true,
          },
        },
        ["core.keybinds"] = {
          config = {
            default_keybinds = true,
            neorg_leader = "<Leader>o",
          },
        },
        ["core.summary"] = {},
        ["core.presenter"] = { config = { zen_mode = "zen-mode" } },
        ["core.export"] = {},
        ["core.export.markdown"] = {},
        ["core.qol.todo_items"] = { config = { create_todo_parents = true } },
        ["core.esupports.indent"] = {},
        ["core.esupports.metagen"] = {},
        ["core.esupports.hop"] = {},
        ["core.ui.calendar"] = {},
      },
    })

    vim.wo.foldlevel = 99
    vim.wo.conceallevel = 2
  end,
}

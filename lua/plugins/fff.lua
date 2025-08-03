return {
  "dmtrKovalenko/fff.nvim",
  enabled = false,
  build = "cargo build --release",
  opts = {
    width = 0.95,
    height = 0.95,
    prompt = " ",
  },
  keys = {
    {
      "<leader>ff", -- try it if you didn't it is a banger keybinding for a picker
      "<cmd>FFFFind<cr>",
      desc = "Toggle FFF",
    },
  },
}

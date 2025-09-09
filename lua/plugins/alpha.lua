return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Custom header: fun ASCII cat!
    local header = {
      "               ᯓᡣ𐭩",
      "      /ᐠ- ˕-マ ノ ",
      "   乀(  J  し)    ",
    }

    -- Custom footer: Steven Wright quote
    local footer = {
      "“If at first you don't succeed,",
      "then skydiving definitely isn't for you.”",
      "― Steven Wright",
    }

    -- Helper for dynamic vertical centering
    local function get_center_padding()
      -- Count lines in each section
      local header_lines = #header
      local footer_lines = #footer
      local buttons_lines = 8 -- update if you change number of buttons below
      local total_lines = header_lines + buttons_lines + footer_lines
      local available_lines = vim.o.lines - 2
      local padding = math.max(0, math.floor((available_lines - total_lines) / 3))
      return padding
    end

    -- Buttons, kept simple and clear, using FzfLua and Telescope for core actions
    dashboard.section.buttons.val = {
      dashboard.button("f", "󰈞  Find File", "<cmd>FzfLua files<cr>"),
      dashboard.button("t", "  Find Text", "<cmd>FzfLua grep<cr>"),
      dashboard.button("r", "󰞌  Recent Files", "<cmd>FzfLua oldfiles<cr>"),
      dashboard.button("p", "󰉖  Projects", "<cmd>Telescope projects<cr>"),
      dashboard.button("n", "  New File", "<cmd>ene | startinsert<cr>"),
      dashboard.button("c", "  Config", "<cmd>FzfLua files cwd=" .. vim.fn.stdpath("config") .. "<cr>"),
      dashboard.button("l", "󰒲 Open Lazy", "<cmd>Lazy<cr>"),
      dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
    }

    dashboard.section.header.val = header
    dashboard.section.header.opts.hl = "Type"
    dashboard.section.footer.val = footer
    dashboard.section.footer.opts.hl = "Comment"

    dashboard.config.layout = {
      { type = "padding", val = get_center_padding() },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }

    alpha.setup(dashboard.config)

    -- Hide statusline and tabline for a clean dashboard
    local augroup = vim.api.nvim_create_augroup("AlphaVisibility", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = augroup,
      pattern = "AlphaReady",
      callback = function()
        vim.opt_local.laststatus = 0
        vim.opt_local.showtabline = 0
      end,
    })
  end,
}

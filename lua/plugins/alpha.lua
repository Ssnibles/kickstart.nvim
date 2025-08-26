return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    local custom_dashboard = {}

    -- You can customize your header here!
    custom_dashboard.header = {
      -- Cat ASCII art
      "               ᯓᡣ𐭩",
      "      /ᐠ- ˕-マ ノ ",
      "   乀(  J  し)    ",
    }

    -- Your favorite Steven Wright quote!
    custom_dashboard.footer = {
      "“If at first you don't succeed,",
      "then skydiving definitely isn't for you.”",
      "― Steven Wright",
    }

    -- Dynamically calculate vertical padding to keep things centered.
    local function get_center_padding()
      local header_lines = #custom_dashboard.header
      local footer_lines = #custom_dashboard.footer
      local buttons_lines = #dashboard.section.buttons.val
      local total_lines = header_lines + buttons_lines + footer_lines
      local available_lines = vim.o.lines - 2
      local padding = math.max(0, math.floor((available_lines - total_lines) / 3))
      return padding
    end

    -- Define the buttons with descriptive names and commands.
    local function create_buttons()
      local buttons = {
        dashboard.button("f", "󰈞  Find File", "<cmd>FzfLua files<cr>"),
        dashboard.button("t", "  Find Text", "<cmd>FzfLua grep<cr>"),
        dashboard.button("r", "󰞌  Recent Files", "<cmd>FzfLua oldfiles<cr>"),
        dashboard.button("p", "󰉖  Projects", "<cmd>Telescope projects<cr>"),
        dashboard.button("n", "  New File", "<cmd>ene | startinsert<cr>"),
        dashboard.button("c", "  Config", "<cmd>FzfLua files cwd=" .. vim.fn.stdpath("config") .. "<cr>"),
        dashboard.button("l", "󰒲 Open Lazy", "<cmd>Lazy<cr>"),
        dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
      }
      return buttons
    end

    -- Configure the sections of the dashboard.
    dashboard.section.header.val = custom_dashboard.header
    dashboard.section.header.opts.hl = "Type" -- Adding back the header highlight

    dashboard.section.buttons.val = create_buttons()

    dashboard.section.footer.val = custom_dashboard.footer
    -- This is the change: applying the "Comment" highlight group to the footer
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

    -- Hide the statusline and tabline.
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

return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- Only show dashboard on empty start
    if vim.fn.argc(-1) > 0 or vim.o.diff then
      return
    end

    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Header
    local header = {
      "               ᯓᡣ𐭩",
      "      /ᐠ- ˕-マ ノ ",
      "   乀(  J  し)    ",
    }
    dashboard.section.header.val = header
    dashboard.section.header.opts = { hl = "Title", position = "center" }

    -- Buttons (stick to FzfLua to avoid overlapping finders)
    dashboard.section.buttons.val = {
      dashboard.button("f", "󰈞  Find File", "<cmd>FzfLua files<cr>"),
      dashboard.button("t", "  Find Text", "<cmd>FzfLua live_grep<cr>"),
      dashboard.button("r", "󰞌  Recent Files", "<cmd>FzfLua oldfiles<cr>"),
      dashboard.button("n", "  New File", "<cmd>ene | startinsert<cr>"),
      dashboard.button("c", "  Config", "<cmd>FzfLua files cwd=" .. vim.fn.stdpath("config") .. "<cr>"),
      dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<cr>"),
      dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
    }
    dashboard.section.buttons.opts = { spacing = 1 }

    -- Footer
    local footer = {
      "“If at first you don't succeed,",
      "then skydiving definitely isn't for you.”",
      "― Steven Wright",
    }
    dashboard.section.footer.val = footer
    dashboard.section.footer.opts = { hl = "Comment", position = "center" }

    -- Compute top padding so the WHOLE block (header + buttons + footer) is centered
    local function top_pad()
      local winh = vim.api.nvim_win_get_height(0)
      local header_lines = #header
      local btns = dashboard.section.buttons.val
      local spacing = (dashboard.section.buttons.opts and dashboard.section.buttons.opts.spacing) or 0
      local nbtn = #btns
      local btn_lines = nbtn + math.max(nbtn - 1, 0) * spacing
      local footer_lines = #footer
      local static_between = 2 + 1 -- padding entries between header/buttons and buttons/footer
      local content = header_lines + btn_lines + footer_lines + static_between
      local pad = math.floor((winh - content) / 2)
      return math.max(pad, 0)
    end

    -- Initial layout (dynamic first padding updated after UI settles)
    dashboard.config.layout = {
      { type = "padding", val = 0 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }

    alpha.setup(dashboard.config)

    -- Hide status/tabline on dashboard; recenter on ready and resize; restore on close
    local grp = vim.api.nvim_create_augroup("AlphaUI", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = grp,
      pattern = "AlphaReady",
      callback = function()
        vim.opt_local.laststatus = 0
        vim.opt_local.showtabline = 0

        local function recenter()
          dashboard.config.layout[1].val = top_pad()
          pcall(alpha.redraw)
        end
        -- Recenter once UI options took effect
        vim.schedule(recenter)

        -- Recenter on terminal resize while dashboard is visible
        vim.api.nvim_create_autocmd("VimResized", {
          group = grp,
          callback = function()
            if vim.bo.filetype == "alpha" then
              dashboard.config.layout[1].val = top_pad()
              pcall(alpha.redraw)
            end
          end,
        })

        -- Restore UI when dashboard closes
        local buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_create_autocmd("BufUnload", {
          group = grp,
          buffer = buf,
          once = true,
          callback = function()
            vim.opt.laststatus = 3
            vim.opt.showtabline = 1
          end,
        })
      end,
    })
  end,
}

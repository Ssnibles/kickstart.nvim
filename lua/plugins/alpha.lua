return {
  "goolord/alpha-nvim",
  -- Load alpha-nvim only after Neovim has fully entered (e.g., at startup).
  -- This is the ideal event for a dashboard-style plugin, ensuring lazy loading.
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- Essential for displaying icons
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Calculate vertical centering padding for the dashboard elements.
    -- This ensures the content (header, buttons, footer) is roughly centered
    -- in the Neovim window, adapting to different terminal sizes.
    local function get_padding()
      -- Calculate the total number of lines occupied by the content.
      -- It sums header lines, one line per button, and one for the footer.
      local content_lines = #dashboard.section.header.val
      content_lines = content_lines + #dashboard.section.buttons.val
      content_lines = content_lines + 1 -- For the footer section

      -- 'vim.o.lines' provides the total height of the Neovim window.
      -- We subtract 2 lines for the command line at the bottom.
      local available_space = vim.o.lines - 2
      -- Determine the top padding. Dividing by 3 often provides a visually
      -- appealing offset, placing the header in the top-third of the screen.
      return math.max(0, math.floor((available_space - content_lines) / 3))
    end

    -- Set a custom header for the dashboard.
    -- This uses Unicode characters to create a distinct and appealing visual.
    dashboard.section.header.val = {
      "               ᯓᡣ𐭩",
      "     /ᐠ- ˕-マ  ノ",
      "  乀(  J  し)",
    }
    -- Apply a highlight group to the header for consistent styling.
    dashboard.section.header.opts.hl = "Type"

    -- Define the interactive menu buttons for the dashboard.
    -- Each button includes a keybinding, a descriptive label (with a devicon),
    -- and the Neovim command to execute when the button is pressed.
    dashboard.section.buttons.val = {
      dashboard.button("f", "󰈞  Find File", "<cmd>FzfLua files<cr>"), -- Fuzzy find files in the current project
      dashboard.button("t", "  Find Text", "<cmd>FzfLua grep<cr>"), -- Fuzzy find text using grep
      dashboard.button("r", "󰞌  Recent Files", "<cmd>FzfLua oldfiles<cr>"), -- List and open recent files
      dashboard.button("n", "  New File", "<cmd>ene | startinsert<cr>"), -- Create a new, empty buffer and enter insert mode
      -- 'Config' button: Opens fuzzy finder focused on Neovim configuration files.
      dashboard.button("c", "  Config", "<cmd>FzfLua files cwd=" .. vim.fn.stdpath("config") .. "<cr>"),
      dashboard.button("l", "󰒲 Open Lazy", "<cmd>Lazy<cr>"), -- Opens the Lazy.nvim plugin manager UI
      dashboard.button("q", "  Quit", "<cmd>qa<cr>"), -- Quits all Neovim windows
    }

    -- Set a custom footer for the dashboard, displaying a quote.
    dashboard.section.footer.val = {
      "“If at first you don't succeed,",
      "then skydiving definitely isn't for you.”",
      "― Steven Wright",
    }
    -- Apply a highlight group to the footer for styling, often a subtle 'Comment' style.
    dashboard.section.footer.opts.hl = "Comment"

    -- Define the overall layout of the dashboard sections.
    -- This uses padding elements to control the vertical spacing and alignment
    -- of the header, buttons, and footer.
    dashboard.config.layout = {
      { type = "padding", val = get_padding() }, -- Dynamic top padding for centering
      dashboard.section.header,
      { type = "padding", val = 2 }, -- Fixed space between header and buttons
      dashboard.section.buttons,
      { type = "padding", val = 1 }, -- Fixed space between buttons and footer
      dashboard.section.footer,
    }

    -- Apply the defined dashboard configuration to the alpha-nvim plugin.
    alpha.setup(dashboard.config)

    -- Autocommands to manage the visibility of the statusline and tabline.
    -- When the Alpha dashboard is displayed, these lines are hidden for a cleaner
    -- and more focused startup screen.
    vim.api.nvim_create_autocmd("User", {
      pattern = "AlphaReady", -- Fired by alpha-nvim when the dashboard is visible
      callback = function()
        vim.opt.laststatus = 0 -- Hide the global statusline
        vim.opt.showtabline = 0 -- Hide the tabline
      end,
    })

    -- When the Alpha dashboard buffer is unloaded (e.g., when a file is opened
    -- and the dashboard is replaced), restore the statusline and tabline
    -- to their default or desired visibility.
    vim.api.nvim_create_autocmd("BufUnload", {
      buffer = 0, -- Applies to the current buffer (which is the Alpha dashboard)
      callback = function()
        vim.opt.laststatus = 1 -- Restore statusline to show if multiple windows are open
        vim.opt.showtabline = 0 -- Keep tabline hidden, or change to 1/2 if you use tabs often
      end,
    })
  end,
}

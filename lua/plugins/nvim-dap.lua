return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
      "nvim-neotest/nvim-nio",
      "ibhagwan/fzf-lua",
    },
    config = function()
      local dap = require("dap")
      local utils = require("dap.utils")
      local fzf_lua = require("fzf-lua")

      -- Keybindings (maintained with session handling)
      vim.keymap.set("n", "<leader>dc", function()
        if dap.session() then
          dap.continue()
        else
          dap.continue()
          require("dapui").open({})
        end
      end, { desc = "Start/Continue debugging" })

      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run last debug session" })
      vim.keymap.set("n", "<leader>dB", function()
        fzf_lua.dap_breakpoints({})
      end, { desc = "List breakpoints (fzf)" })
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
      vim.keymap.set("n", "<leader>du", dap.step_out, { desc = "Step out" })
      vim.keymap.set("n", "<leader>dt", function()
        dap.terminate()
        require("dapui").close({})
      end, { desc = "Terminate session" })
      vim.keymap.set("n", "<leader>dr", function()
        dap.restart()
        require("dapui").open({})
      end, { desc = "Restart session" })
      vim.keymap.set("n", "<leader>dR", function()
        dap.repl.open({ height = 15 }, "vsplit")
      end, { desc = "Open REPL (vertical)" })
      vim.keymap.set("n", "<leader>dv", function()
        fzf_lua.dap_variables({})
      end, { desc = "List variables (fzf)" })
      vim.keymap.set("n", "<leader>df", function()
        fzf_lua.dap_frames({})
      end, { desc = "List frames (fzf)" })

      -- Mason DAP setup
      require("mason-nvim-dap").setup({
        ensure_installed = { "python", "codelldb", "delve" },
        automatic_installation = true,
        handlers = {
          function(config)
            require("mason-nvim-dap").default_setup(config)
          end,
          python = function(config)
            config.adapters = {
              type = "executable",
              command = "python",
              args = { "-m", "debugpy.adapter" },
            }
            require("mason-nvim-dap").default_setup(config)
          end,
        },
      })

      -- Python Configuration
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch File",
          program = "${file}",
          pythonPath = function()
            local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
            return venv and venv .. "/bin/python" or vim.fn.exepath("python3") or "python"
          end,
          justMyCode = false,
          console = "integratedTerminal",
        },
        {
          type = "python",
          request = "attach",
          name = "Attach Remote",
          connect = { port = 5678, host = "localhost" },
          pathMappings = {
            { localRoot = "${workspaceFolder}", remoteRoot = "." },
          },
        },
      }

      -- Go Configuration
      dap.configurations.go = {
        {
          type = "delve",
          name = "Debug (Go)",
          request = "launch",
          program = "${file}",
          buildFlags = "-buildvcs=false",
        },
        {
          type = "delve",
          name = "Debug Test (Go)",
          request = "launch",
          mode = "test",
          program = "${file}",
        },
        {
          type = "delve",
          name = "Attach (Go)",
          request = "attach",
          processId = require("dap.utils").pick_process,
        },
      }

      -- Rust Configuration
      dap.configurations.rust = {
        {
          name = "Debug Rust",
          type = "codelldb",
          request = "launch",
          program = function()
            local cargo_crate = vim.fn.getcwd() .. "/target/debug/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            return vim.fn.filereadable(cargo_crate) == 1 and cargo_crate
              or vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          terminal = "integrated",
          sourceLanguages = { "rust" },
        },
      }

      -- Virtual text configuration
      require("nvim-dap-virtual-text").setup({
        commented = true,
        display_callback = function(variable, _buf, _stackframe, _node)
          return variable.name .. " = " .. variable.value
        end,
      })

      -- Adapter checks
      local check_adapters = function()
        local mason_registry = require("mason-registry")
        local check = function(pkg)
          if not mason_registry.is_installed(pkg) then
            vim.notify(
              ("Debug adapter %s not installed! Install with :MasonInstall %s"):format(pkg, pkg),
              vim.log.levels.WARN
            )
          end
        end
        check("debugpy")
        check("codelldb")
        check("delve")
      end
      vim.defer_fn(check_adapters, 1000)
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    config = function()
      require("dapui").setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = { expand = { "o", "<2-LeftMouse>" }, open = "O", remove = "d", edit = "e" },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.3 },
              { id = "breakpoints", size = 0.2 },
              { id = "stacks", size = 0.2 },
              { id = "watches", size = 0.3 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.8 },
              { id = "console", size = 0.2 },
            },
            size = 15,
            position = "bottom",
          },
        },
        render = {
          max_value_lines = 5,
          indent = 2,
          max_type_length = 20,
        },
      })

      -- Modified UI automation
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({ reset = true }) -- Reset UI on new session
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
        dapui.float_element("console", { position = "center", height = 20 }) -- Keep console visible
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.float_element("console", { position = "center", height = 20 })
      end
    end,
  },
}

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "igorlfs/nvim-dap-view",
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
      "nvim-neotest/nvim-nio",
      "ibhagwan/fzf-lua",
    },
    config = function()
      local dap = require("dap")
      local fzf_lua = require("fzf-lua")

      -- Keybindings (unchanged)
      vim.keymap.set("n", "<leader>dc", function()
        dap.continue()
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
        require("dap-view").close()
      end, { desc = "Terminate session" })
      vim.keymap.set("n", "<leader>dr", function()
        dap.restart()
        require("dap-view").open()
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

      -- 󰛩 Mason DAP setup - FIXED debugpy installation
      require("mason-nvim-dap").setup({
        ensure_installed = { "debugpy", "codelldb", "delve" }, -- Changed from "python"
        automatic_installation = true,
        handlers = {
          -- 󰛩 Removed Python-specific handler to use default config
          function(config)
            require("mason-nvim-dap").default_setup(config)
          end,
        },
      })

      -- Python Configuration (unchanged but now uses correct adapter)
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
          console = "internalConsole",
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

      -- Go Configuration (unchanged)
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

      -- Rust Configuration (unchanged)
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

      -- Virtual text configuration (unchanged)
      require("nvim-dap-virtual-text").setup({
        commented = true,
        display_callback = function(variable, _buf, _stackframe, _node)
          return variable.name .. " = " .. variable.value
        end,
      })

      -- 󰛩 Updated adapter checks for debugpy
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
        check("debugpy") -- Now checking for correct package
        check("codelldb")
        check("delve")
      end
      vim.defer_fn(check_adapters, 1000)
    end,
  },
  {
    "igorlfs/nvim-dap-view",
    config = function()
      require("dap-view").setup({})

      -- Auto open/close (unchanged)
      local dap = require("dap")
      local dapview = require("dap-view")
      dap.listeners.after.event_initialized["dapview_autoopen"] = function()
        dapview.open()
      end
      dap.listeners.before.event_terminated["dapview_autoclose"] = function()
        dapview.close()
      end
      dap.listeners.before.event_exited["dapview_autoclose"] = function()
        dapview.close()
      end
    end,
  },
}

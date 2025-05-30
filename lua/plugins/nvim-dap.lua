
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
    keys = {
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Start/Continue debugging",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "Run last debug session",
      },
      {
        "<leader>dB",
        function()
          require("fzf-lua").dap_breakpoints({})
        end,
        desc = "List breakpoints",
      },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle breakpoint",
      },
      {
        "<leader>dC",
        function()
          require("dap").set_breakpoint(vim.fn.input("Condition: "))
        end,
        desc = "Conditional breakpoint",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Step over",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step into",
      },
      {
        "<leader>du",
        function()
          require("dap").step_out()
        end,
        desc = "Step out",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
          require("dap-view").close()
        end,
        desc = "Terminate session",
      },
      {
        "<leader>dr",
        function()
          require("dap").restart()
          require("dap-view").open()
        end,
        desc = "Restart session",
      },
      {
        "<leader>dR",
        function()
          require("dap").repl.toggle({ height = 15 }, "vsplit")
        end,
        desc = "Toggle REPL",
      },
      {
        "<leader>dv",
        function()
          require("fzf-lua").dap_variables({})
        end,
        desc = "List variables",
      },
      {
        "<leader>df",
        function()
          require("fzf-lua").dap_frames({})
        end,
        desc = "List frames",
      },
      {
        "<leader>dh",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Hover variables",
      },
      {
        "<leader>ds",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.scopes)
        end,
        desc = "Show scopes",
      },
    },
    config = function()
      local dap = require("dap")

      -- Signs for breakpoints
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◐", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "✗", texthl = "DiagnosticError" })

      -- Mason DAP setup with better error handling
      local mason_dap_ok, mason_dap = pcall(require, "mason-nvim-dap")
      if mason_dap_ok then
        mason_dap.setup({
          ensure_installed = { "debugpy", "codelldb", "delve" },
          automatic_installation = true,
          handlers = {
            function(config)
              mason_dap.default_setup(config)
            end,
          },
        })
      end

      -- Python configuration with better virtual environment detection
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch File",
          program = "${file}",
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            -- Check for common virtual environment locations
            local venv_paths = {
              os.getenv("VIRTUAL_ENV"),
              os.getenv("CONDA_PREFIX"),
              cwd .. "/.venv",
              cwd .. "/venv",
              cwd .. "/env",
            }

            for _, path in ipairs(venv_paths) do
              if path and vim.fn.isdirectory(path) == 1 then
                local python_path = path .. "/bin/python"
                if vim.fn.executable(python_path) == 1 then
                  return python_path
                end
              end
            end

            return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
          end,
          justMyCode = false,
          console = "internalConsole",
          args = function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " ", { trimempty = true })
          end,
        },
        {
          type = "python",
          request = "launch",
          name = "Launch with args",
          program = "${file}",
          pythonPath = function()
            local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
            return venv and venv .. "/bin/python" or vim.fn.exepath("python3") or "python"
          end,
          args = function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " ", { trimempty = true })
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

      -- Go configuration with improved build flags
      dap.configurations.go = {
        {
          type = "delve",
          name = "Debug (Go)",
          request = "launch",
          program = "${file}",
          buildFlags = "-buildvcs=false",
          args = function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " ", { trimempty = true })
          end,
        },
        {
          type = "delve",
          name = "Debug Package (Go)",
          request = "launch",
          program = "${workspaceFolder}",
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

      -- Rust configuration with cargo integration
      dap.configurations.rust = {
        {
          name = "Debug Rust",
          type = "codelldb",
          request = "launch",
          program = function()
            -- Try to find the binary in target/debug
            local cwd = vim.fn.getcwd()
            local package_name = vim.fn.fnamemodify(cwd, ":t")
            local binary_path = cwd .. "/target/debug/" .. package_name

            if vim.fn.filereadable(binary_path) == 1 then
              return binary_path
            end

            return vim.fn.input("Path to executable: ", cwd .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          terminal = "integrated",
          sourceLanguages = { "rust" },
          args = function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " ", { trimempty = true })
          end,
        },
        {
          name = "Debug Rust Tests",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to test executable: ", vim.fn.getcwd() .. "/target/debug/deps/", "file")
          end,
          cwd = "${workspaceFolder}",
          terminal = "integrated",
          sourceLanguages = { "rust" },
        },
      }

      -- C/C++ configuration
      dap.configurations.c = {
        {
          name = "Debug C",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " ", { trimempty = true })
          end,
        },
      }

      -- Copy C config to C++
      dap.configurations.cpp = dap.configurations.c

      -- Virtual text setup with better formatting
      local virtual_text_ok, virtual_text = pcall(require, "nvim-dap-virtual-text")
      if virtual_text_ok then
        virtual_text.setup({
          enabled = true,
          enabled_commands = true,
          highlight_changed_variables = true,
          highlight_new_as_changed = false,
          show_stop_reason = true,
          commented = true,
          only_first_definition = true,
          all_references = false,
          display_callback = function(variable, buf, stackframe, node, options)
            if options.virt_text_pos == "inline" then
              return " = " .. variable.value:gsub("%s+", " ")
            else
              return variable.name .. " = " .. variable.value:gsub("%s+", " ")
            end
          end,
        })
      end

      -- DAP View auto open/close with error handling
      local dap_view_ok, dap_view = pcall(require, "dap-view")
      if dap_view_ok then
        dap.listeners.after.event_initialized["dapview_autoopen"] = function()
          dap_view.open()
        end
        dap.listeners.before.event_terminated["dapview_autoclose"] = function()
          dap_view.close()
        end
        dap.listeners.before.event_exited["dapview_autoclose"] = function()
          dap_view.close()
        end
      end

      -- Improved adapter checks with delayed execution
      local function check_adapters()
        local mason_registry_ok, mason_registry = pcall(require, "mason-registry")
        if not mason_registry_ok then
          return
        end

        local adapters = { "debugpy", "codelldb", "delve" }
        local missing = {}

        for _, pkg in ipairs(adapters) do
          if not mason_registry.is_installed(pkg) then
            table.insert(missing, pkg)
          end
        end

        if #missing > 0 then
          vim.notify(
            "Missing debug adapters: "
              .. table.concat(missing, ", ")
              .. "\nInstall with: :MasonInstall "
              .. table.concat(missing, " "),
            vim.log.levels.WARN,
            { title = "DAP Setup" }
          )
        end
      end

      -- Check adapters after a delay to ensure Mason is loaded
      vim.defer_fn(check_adapters, 2000)
    end,
  },
  {
    "igorlfs/nvim-dap-view",
    config = function()
      require("dap-view").setup({
        -- Add any specific dap-view configuration here if needed
      })
    end,
  },
}

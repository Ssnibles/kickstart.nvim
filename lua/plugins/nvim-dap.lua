return {
  {
    -- Main nvim-dap plugin
    "mfussenegger/nvim-dap",
    -- Load the plugin only when a buffer is read or entered.
    -- This helps improve Neovim startup time without sacrificing immediate availability.
    event = "BufReadPost", -- Changed from BufReadPre to BufReadPost for slightly later loading
    -- Dependencies for nvim-dap, providing UI, virtual text, and adapter management
    dependencies = {
      "igorlfs/nvim-dap-view", -- For visual debugging UI (windows for variables, stack, etc.)
      "theHamsta/nvim-dap-virtual-text", -- Displays variable values directly in your code
      "jay-babu/mason-nvim-dap.nvim", -- Integrates DAP adapters with Mason (plugin manager for LSP/DAP servers)
      "nvim-neotest/nvim-nio", -- Neovim I/O library, a dependency for some DAP features
      "ibhagwan/fzf-lua", -- Used for fuzzy-finding DAP elements like breakpoints, variables, frames
      -- Optional, but highly recommended for enhanced UI if dap-view is not sufficient.
      -- If you prefer nvim-dap-ui, uncomment the line below and comment out "igorlfs/nvim-dap-view".
      -- "rcarriga/nvim-dap-ui",
    },
    -- Keybindings for common DAP actions
    keys = {
      -- Debugging session control
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "DAP: Start/Continue",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "DAP: Run last session",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "DAP: Terminate session",
      },
      {
        "<leader>dr",
        function()
          require("dap").restart()
        end,
        desc = "DAP: Restart session",
      },

      -- Breakpoint management
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "DAP: Toggle breakpoint",
      },
      {
        "<leader>dC",
        function()
          require("dap").set_breakpoint(vim.fn.input("Condition: "))
        end,
        desc = "DAP: Conditional breakpoint",
      },
      {
        "<leader>dB",
        function()
          require("fzf-lua").dap_breakpoints({})
        end,
        desc = "DAP: List breakpoints",
      },
      {
        "<leader>dX",
        function()
          require("dap").clear_breakpoints()
        end,
        desc = "DAP: Clear all breakpoints",
      },
      {
        "<leader>de",
        function()
          require("dap").set_exception_breakpoints({})
        end,
        desc = "DAP: Set exception breakpoint",
      },

      -- Stepping actions
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "DAP: Step over",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "DAP: Step into",
      },
      {
        "<leader>du",
        function()
          require("dap").step_out()
        end,
        desc = "DAP: Step out",
      },

      -- UI and Information
      {
        "<leader>dR",
        function()
          -- Use a safer way to toggle if dap-view is not loaded, or simply use dap.repl.toggle()
          if require("dap-view").is_open then
            require("dap").repl.close()
          else
            require("dap").repl.open({ height = 15 }, "vsplit")
          end
        end,
        desc = "DAP: Toggle REPL",
      },
      -- Explicit REPL open/close bindings are good if the toggle isn't enough
      {
        "<leader>dRo",
        function()
          require("dap").repl.open({ height = 15 }, "vsplit")
        end,
        desc = "DAP: Open REPL",
      },
      {
        "<leader>dRc",
        function()
          require("dap").repl.close()
        end,
        desc = "DAP: Close REPL",
      },
      {
        "<leader>dv",
        function()
          require("fzf-lua").dap_variables({})
        end,
        desc = "DAP: List variables",
      },
      {
        "<leader>df",
        function()
          require("fzf-lua").dap_frames({})
        end,
        desc = "DAP: List frames",
      },
      {
        "<leader>dh",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "DAP: Hover variables",
      },
      {
        "<leader>ds",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.scopes)
        end,
        desc = "DAP: Show scopes",
      },
    },
    -- Configuration function for the plugin
    config = function()
      local dap = require("dap")

      -- Define signs for breakpoints in the sign column
      -- These signs provide visual cues in the gutter for debugging status.
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◐", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "✗", texthl = "DiagnosticError", linehl = "", numhl = "" })

      -- Setup mason-nvim-dap for managing debug adapters
      -- This plugin integrates DAP adapters with Mason, simplifying their installation.
      local mason_dap_ok, mason_dap = pcall(require, "mason-nvim-dap")
      if mason_dap_ok then
        mason_dap.setup({
          ensure_installed = { "debugpy", "codelldb", "delve" }, -- Automatically install these adapters if not present
          automatic_installation = true, -- Enable automatic installation
          handlers = {
            -- A handler function for each installed adapter.
            -- This ensures debuggers are correctly configured by mason-nvim-dap.
            function(config)
              mason_dap.default_setup(config)
            end,
          },
        })
      else
        vim.notify(
          "mason-nvim-dap not found. Debug adapters might not be managed automatically.",
          vim.log.levels.WARN,
          { title = "DAP Setup" }
        )
      end

      -- Helper function to detect and return the correct Python executable path
      -- This function tries to find Python in various virtual environments and then falls back to system paths.
      local function get_python_path()
        local cwd = vim.fn.getcwd()
        -- Common virtual environment paths to check
        local venv_paths = {
          os.getenv("VIRTUAL_ENV"), -- Standard VIRTUAL_ENV environment variable
          os.getenv("CONDA_PREFIX"), -- Conda environment variable
          cwd .. "/.venv", -- Common local .venv directory
          cwd .. "/venv", -- Common local venv directory
          cwd .. "/env", -- Common local env directory
        }

        for _, path in ipairs(venv_paths) do
          if path and vim.fn.isdirectory(path) == 1 then
            local python_path_unix = path .. "/bin/python" -- Unix-like path
            if vim.fn.executable(python_path_unix) == 1 then
              return python_path_unix
            end
            -- Check for Windows path if applicable (e.g., in Scripts folder)
            local python_path_windows = path .. "/Scripts/python.exe"
            if vim.fn.executable(python_path_windows) == 1 then
              return python_path_windows
            end
          end
        end

        -- Fallback to system-wide python executables
        return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
      end

      -- Python configurations for nvim-dap
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch File",
          program = "${file}", -- Debug the currently open file
          pythonPath = get_python_path(), -- Use the robust helper function for Python executable
          justMyCode = false, -- Set to true to skip debugging into third-party libraries
          console = "integratedTerminal", -- Use Neovim's integrated terminal for I/O (recommended for interactive scripts)
          args = function()
            local args_string = vim.fn.input("Arguments (space-separated): ")
            -- Split arguments by space, removing empty strings
            return vim.split(args_string, " ", { trimempty = true })
          end,
        },
        {
          type = "python",
          request = "attach",
          name = "Attach Remote",
          connect = { port = 5678, host = "localhost" }, -- Default port and host for remote attachment
          pathMappings = {
            -- Map local project root to remote root if code is running on a different machine/container
            { localRoot = "${workspaceFolder}", remoteRoot = "." },
          },
        },
      }

      -- Go configurations for nvim-dap
      dap.configurations.go = {
        {
          type = "delve",
          name = "Debug (Go Current File)",
          request = "launch",
          program = "${file}", -- Debug the currently open Go file
          buildFlags = "-buildvcs=false", -- Prevents embedding VCS info, useful for reproducible builds
          args = function()
            local args_string = vim.fn.input("Arguments (space-separated): ")
            return vim.split(args_string, " ", { trimempty = true })
          end,
        },
        {
          type = "delve",
          name = "Debug (Go Package)",
          request = "launch",
          program = "${workspaceFolder}", -- Debug the entire package at workspace root
          buildFlags = "-buildvcs=false",
        },
        {
          type = "delve",
          name = "Debug (Go Test)",
          request = "launch",
          mode = "test", -- Specifically for Go tests
          program = "${file}", -- Debug tests in the current file
        },
        {
          type = "delve",
          name = "Attach (Go)",
          request = "attach",
          -- Allows picking a running process to attach to (requires 'go install github.com/go-delve/delve/cmd/dlv' and 'dlv attach <PID>')
          processId = require("dap.utils").pick_process,
        },
      }

      -- Rust configurations for nvim-dap
      dap.configurations.rust = {
        {
          name = "Debug Rust (Launch)",
          type = "codelldb",
          request = "launch",
          program = function()
            -- Attempt to find the binary in the common target/debug location
            local cwd = vim.fn.getcwd()
            local package_name = vim.fn.fnamemodify(cwd, ":t") -- Get current directory name as potential package name
            local binary_path = cwd .. "/target/debug/" .. package_name

            if vim.fn.filereadable(binary_path) == 1 then
              return binary_path
            end

            -- If not found, prompt user for path
            return vim.fn.input("Path to executable: ", cwd .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}", -- Current working directory for the debugger
          terminal = "integrated", -- Use Neovim's integrated terminal for program output
          sourceLanguages = { "rust" }, -- Hint to the debugger that the source is Rust
          args = function()
            local args_string = vim.fn.input("Arguments (space-separated): ")
            return vim.split(args_string, " ", { trimempty = true })
          end,
        },
        {
          name = "Debug Rust (Test)",
          type = "codelldb",
          request = "launch",
          program = function()
            -- Prompt for test executable path, commonly found in target/debug/deps/
            return vim.fn.input("Path to test executable: ", vim.fn.getcwd() .. "/target/debug/deps/", "file")
          end,
          cwd = "${workspaceFolder}",
          terminal = "integrated",
          sourceLanguages = { "rust" },
        },
        {
          name = "Attach Rust",
          type = "codelldb",
          request = "attach",
          processId = require("dap.utils").pick_process, -- Allows picking a running process to attach to
          cwd = "${workspaceFolder}",
          terminal = "integrated",
          sourceLanguages = { "rust" },
        },
      }

      -- C/C++ configurations (using codelldb) for nvim-dap
      dap.configurations.c = {
        {
          name = "Debug C/C++ (Launch)",
          type = "codelldb",
          request = "launch",
          program = function()
            -- Prompt user for executable path, defaulting to current working directory
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false, -- Set to true to stop at the entry point of the program automatically
          args = function()
            local args_string = vim.fn.input("Arguments (space-separated): ")
            return vim.split(args_string, " ", { trimempty = true })
          end,
        },
        {
          name = "Attach C/C++",
          type = "codelldb",
          request = "attach",
          processId = require("dap.utils").pick_process, -- Allows picking a running process to attach to
          cwd = "${workspaceFolder}",
        },
      }
      -- C++ configuration reuses the C configuration
      dap.configurations.cpp = dap.configurations.c

      -- Setup nvim-dap-virtual-text for inline variable display
      -- This plugin shows variable values directly next to your code lines.
      local virtual_text_ok, virtual_text = pcall(require, "nvim-dap-virtual-text")
      if virtual_text_ok then
        virtual_text.setup({
          enabled = true,
          enabled_commands = true, -- Enable virtual text for commands (e.g., in REPL)
          highlight_changed_variables = true, -- Highlight variables that have changed since last step
          highlight_new_as_changed = false, -- Don't highlight new variables as changed
          show_stop_reason = true, -- Show the reason for stopping (e.g., breakpoint hit, exception)
          commented = true, -- Display virtual text as comments (e.g., ` -- var = value`)
          only_first_definition = true, -- Only show virtual text for the first definition of a variable in a scope
          all_references = false, -- Set to true to show virtual text for all references of a variable
          -- Custom display callback for formatting variable output
          display_callback = function(variable, buf, stackframe, node, options)
            if options.virt_text_pos == "inline" then
              -- For inline display, format as " = value"
              return " = " .. variable.value:gsub("%s+", " ") -- Trim excessive whitespace
            else
              -- For line display, format as "name = value"
              return variable.name .. " = " .. variable.value:gsub("%s+", " ") -- Trim excessive whitespace
            end
          end,
        })
      else
        vim.notify(
          "nvim-dap-virtual-text not found. Inline variable display will be disabled.",
          vim.log.levels.WARN,
          { title = "DAP Setup" }
        )
      end

      -- Setup nvim-dap-view for the debugging UI windows
      -- This plugin provides dedicated windows for variables, stack, breakpoints, etc.
      local dap_view_ok, dap_view = pcall(require, "dap-view")
      if dap_view_ok then
        dap_view.setup({}) -- No specific configuration needed, uses sensible defaults
        -- Auto-open dap-view on session initialization
        dap.listeners.after.event_initialized["dapview_autoopen"] = function()
          dap_view.open()
        end
        -- Auto-close dap-view when session terminates or exits
        dap.listeners.before.event_terminated["dapview_autoclose"] = function()
          dap_view.close()
        end
        dap.listeners.before.event_exited["dapview_autoclose"] = function()
          dap_view.close()
        end
      else
        vim.notify(
          "nvim-dap-view not found. Debugging UI windows will be unavailable.",
          vim.log.levels.WARN,
          { title = "DAP Setup" }
        )
      end

      -- Function to check for installed debug adapters and notify if missing
      -- This provides helpful feedback to the user if a required debugger is not installed via Mason.
      local function check_adapters()
        local mason_registry_ok, mason_registry = pcall(require, "mason-registry")
        if not mason_registry_ok then
          vim.notify("Mason not found. Cannot check for debug adapters.", vim.log.levels.WARN, { title = "DAP Setup" })
          return -- Mason not installed, cannot check adapters
        end

        local adapters_to_check = { "debugpy", "codelldb", "delve" }
        local missing_adapters = {}

        for _, pkg in ipairs(adapters_to_check) do
          if not mason_registry.is_installed(pkg) then
            table.insert(missing_adapters, pkg)
          end
        end

        if #missing_adapters > 0 then
          vim.notify(
            "Missing debug adapters: "
              .. table.concat(missing_adapters, ", ")
              .. "\nInstall with: :MasonInstall "
              .. table.concat(missing_adapters, " "),
            vim.log.levels.WARN,
            { title = "DAP Setup" }
          )
        end
      end

      -- Check for missing adapters after a short delay to ensure Mason has loaded
      vim.defer_fn(check_adapters, 2000)
    end,
  },
}

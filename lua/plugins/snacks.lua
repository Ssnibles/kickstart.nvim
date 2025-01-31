-- I use snacks mainly as a performance profiler
-- To run it as such use "PROF=1 nvim" to run neovim
return {
  "folke/snacks.nvim",
  opts = function()
    -- Toggle the profiler
    Snacks.toggle.profiler():map "<leader>pp"
    -- Toggle the profiler highlights
    Snacks.toggle.profiler_highlights():map "<leader>ph"

    return {
      profiler = {
        autocmds = true,
        runtime = vim.env.VIMRUNTIME,
        thresholds = {
          time = { 2, 10 },
          pct = { 10, 20 },
          count = { 10, 100 },
        },
        on_stop = {
          highlights = true,
          pick = true,
        },
        highlights = {
          min_time = 0,
          max_shade = 20,
          badges = { "time", "pct", "count", "trace" },
          align = 80,
        },
      },
    }
  end,
  keys = {
    {
      "<leader>ps",
      function()
        Snacks.profiler.scratch()
      end,
      desc = "Profiler Scratch Buffer",
    },
  },
}

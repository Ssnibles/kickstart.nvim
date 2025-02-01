return {
	"folke/noice.nvim",
	config = function()
		require("noice").setup({
			cmdline = {
				view = "cmdline_popup",
				position = {
					row = "50%",
					col = "50%",
				},
			},
			views = {
				cmdline_popup = {
					position = {
						row = "50%",
						col = "50%",
					},
					size = {
						width = 60,
						height = "auto",
					},
				},
			},
		})
	end,
}

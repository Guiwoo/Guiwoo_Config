return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		dashboard = {
			enabled = true,
			text = {
				{ "  ", hl = "SnacksDashboardIcon" },
				{ "Find File", hl = "SnacksDashboardDesc", width = 50 },
				{ "[f]", hl = "SnacksDashboardKey" },
			},
			action = ":Telescope find_files",
			key = "f",
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				{ section = "startup" },
				{
					section = "terminal",
					cmd = "/usr/local/bin/pokemon-colorscripts -r -s --no-title; sleep .1",
					random = 10,
					pane = 2,
					indent = 4,
					height = 30,
				},
			},
		},
		indent = { enabled = true },
		input = { enabled = true },
		picker = { enabled = true },
		notifier = { enabled = true },
		scope = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		command = { enabled = true },
	},
}

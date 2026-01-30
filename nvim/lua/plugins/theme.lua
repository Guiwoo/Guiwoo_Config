return {
	{
		"rebelot/kanagawa.nvim",
		lazy = true,
		priority = 1001,
		config = function()
			require("kanagawa").setup({
				compile = true,
				transparent = true,
				theme = "wave",
				background = {
					dark = "wave",
					light = "lotus",
				},
			})
			--vim.cmd("colorscheme kanagawa-wave")
			--vim.api.nvim_set_hl(0, "Visual", { bg = "#fe8019", fg = "#3c3836" })
		end,
		build = function()
			vim.cmd("KanagawaCompile")
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1003,
	},
	{
		"olimorris/onedarkpro.nvim",
		name = "onedark",
		priority = 1002,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		opts = {
			style = "moon",
			transparent = true,
		},
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd.colorscheme("tokyonight")
			vim.api.nvim_set_hl(0, "Visual", { bg = "#fe8019", fg = "#3c3836" })
		end,
	},
}
